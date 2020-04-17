require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  session[:lists] ||= []
end

get "/" do
  redirect "/lists"
end

# Display all lists
get "/lists" do
  @lists = session[:lists]
  erb :lists, layout: :layout
end

# Render new list form
get "/lists/new" do
  erb :new_list, layout: :layout
end

# Return an error message is list name is invalid; otherwise, returns nil
def error_for_list_name?(name)
  if !(1..100).cover? name.size
    "List name must be 1-100 characters long"
  elsif session[:lists].any? { |list| list[:name] == name }
    "List name must be unique"
  end
end

# Create new list
post "/lists" do
  list_name = params["list_name"].strip

  error = error_for_list_name?(list_name)
  if error 
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << { name: list_name, todos: [] }
    session[:success] = "The list has been created."
    redirect "/lists"
  end
end

# Show a list
get "/lists/:id" do
  id = params[:id].to_i
  @list = session[:lists][id]

  erb :list, layout: :layout
end

# Edit a list
get "/lists/:id/edit" do
  id = params[:id].to_i
  @list = session[:lists][id]

  erb :edit_list, layout: :layout
end

# Update a existing list
post "/lists/:id" do
  list_name = params["list_name"].strip
  id = params[:id].to_i
  @list = session[:lists][id]

  error = error_for_list_name?(list_name)
  if error 
    session[:error] = error
    erb :new_list, layout: :layout
  else
    @list[:name] = list_name
    session[:success] = "The list has been updated."
    redirect "/lists/#{params[:id]}"
  end
end

post "/lists/:id/destroy" do
  id = params[:id].to_i
  session[:lists].delete_at(id)

  if env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    "/lists"
  else
    session[:success] = "The list has been deleted."
    redirect "/lists"
  end
end

def next_todo_id(todos)
  max = todos.map { |todo| todo[:id] }.max || 0
  max + 1
end

post "/lists/:id/todos" do
  list_id = params[:id].to_i
  @list = session[:lists][list_id]
  text = params[:todo].strip

  error = error_for_todo?(text)
  if error
    session[:error] = error
    erb :list, layout: :layout
  else
    id = next_todo_id(@list[:todos])
    @list[:todos] << { id: id, name: text, completed: false }
    session[:success] = "The todo has been added."
    redirect "/lists/#{list_id}"
  end
end

def error_for_todo?(name)
  if !(1..100).cover? name.size
    "List name must be 1-100 characters long"
  end
end

post "/lists/:list_id/todos/:todo_id/destroy" do
  list_id = params[:list_id].to_i
  todo_id = params[:todo_id].to_i
  @list = session[:lists][list_id]

  @list[:todos].delete_at(todo_id)

  if env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    status 204
  else
    session[:success] = "The todo has been deleted."
    redirect "/lists/#{list_id}"
  end
end

post "/lists/:list_id/todos/:todo_id/complete" do
  list_id = params[:list_id].to_i
  todo_id = params[:todo_id].to_i
  @list = session[:lists][list_id]
  @todo = @list[:todos][todo_id]
  is_completed = params[:completed] == "true"

  @todo[:completed] = is_completed
  session[:success] = "The todo has been updated."
  redirect "/lists/#{list_id}"
end

post "/lists/:list_id/complete_all" do
  list_id = params[:list_id].to_i
  @list = session[:lists][list_id]

  @list[:todos].each { |todo| todo[:completed] = true }

  session[:success] = "All todos have been completed."
  redirect "/lists/#{list_id}"
end