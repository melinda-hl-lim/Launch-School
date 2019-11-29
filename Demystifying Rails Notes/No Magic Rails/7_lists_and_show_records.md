### Listing Our Posts

Recall that the `hello_world` action needed three things:

    1. A route
    2. An action
    3. A view

To display a list of all post titles in our blog app, we'll need the same three things listed above.

So define a route:

``` ruby
Rails.application.routes.draw do
  get '/list_posts' => 'application#list_posts'
end
```

a controller action:

``` ruby
class ApplicationController < ActionController::Base
  def list_posts
    connection = SQLite3::Database.new 'db/development.sqlite3'
    connection.results_as_hash = true

    posts = connection.execute("SELECT * FROM posts")

    render 'application/list_posts', locals: { posts: posts }
  end
end
```

and then a view to display the information.


### Show a Post to the User

Remmeber the three components to complete an HTTP request/response.


### Extract Shared Logic for DB Connection

Create a private method in the `ApplicationController` file to connect with the DB and avoid repeated code.


