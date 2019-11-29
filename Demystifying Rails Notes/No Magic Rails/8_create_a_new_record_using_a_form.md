### Displaying a Form

To give the user a means to create a new post we need two parts:

    1. provide the user with a form to collect the details of the new post
    2. receive the submitted form data and add it as a data entry in our DB table

To first display a form to collect user input, we need to definte a route, action and view.

*Note*: the view has `<form>` element with `method` and `action` attributes:
    `<form method="post" action="/create_post">`

`method` determines the HTTP request method for form submission (i.e. POST)
`action` determines the request path

The view also has `<input>` elements with `name` attributes:
    `<input name="title" type="text" />`


When a form is submitted with a `POST` request, it sends the form data to the server (in the body of the HTTP request) as **POST data**.


### Creating a Post

Now that there's a form for a new post, we need to define the route and action it submits to.

Route:
    `post '/create_post' => 'application#create_post'`

And an action with no Rails magic:

``` ruby
def create_post
    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, created_at)
      VALUES (?, ?, ?, ?)
    SQL

    connection.execute insert_query,
      params['title'],
      params['body'],
      params['author'],
      Date.current.to_s

    redirect_to '/list_posts'
end
```

#### Redirect vs. Render

When we do HTTP POST, we use a redirect instead of a render because of HTTP semantics.

The meaning of a POST request is different from that of a GET request.
    - POST: we request the server to do something
    - GET: we ask the server to give us something

Since we're making the POST request from a browser, we still have to show the user *something* (even though a POST request is not a request for a document). So once we complete our POST action, we delegate the responsibility for displaying something to the user to another action by redirecting.

If we render after a POST request, there may be errors when trying to refresh the page as the URL from the POST request hasn't changed, even though a new page was rendered.


