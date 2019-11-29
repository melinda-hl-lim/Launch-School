### Dynamic Server Responses

At this point we have:
    - a route sending requests to our action
    - our action rendering a view
However, all of our content is **static**, meaning the server just fetches an HTML document, wraps it in an HTTP response and returns it to the client.

Web applications, however, are more than statics: they can assemble repsonses on the fly to respond to requests.

The dynamic nature of web apps com from *two sources*:

    1. The client *embedding a piece of data in the URL* for the server to respond to:
        - ex: "https://www.google.com/search?q=robots" asks Google to dynamically assemble a web page containing only search results for "robots"
    2. The server responds with data based on some *internal state* of the data in the server's database.
        - ex: when visiting a blog, the server retrieves the blog posts stored in the DB and dynamically assembles a web page based on this data

### Dynamic Documents with Embedded Ruby

ERB (embedded Ruby) is a *templating engine* that allows us to embed Ruby code in a text document to have dynamic documents.

When we render a template into an HTML document, we are running the template through a *rendering engine*. In the case of using ERB, ERB is also a rendering engine.

### Responses with Query Parameters

The most basic way to pass values from the client to the server is to use **query parameters** in the URL (source 1).

    For example: http://localhost:3000/hello_world?name=John

The part following `?` in the path (i.e. `name=John`) is the *query string* interpreted by the server.

To access these parameters in the action:

``` ruby
class ApplicationController < ActionController::Base
  def hello_world
    name = params['name'] || 'World'
    render 'application/hello_world', locals: { name: name }
  end
end
```

Rails parses the query parameters into a hash called `params`. In our action, we take the value of the `name` query paramater and pass it to the ERB rendering engine to render the `hello_world.html.erb` template.

### Responses with URL Capture Pattern

We can pass data to the server by specifying URL matching patterns for routing and capturing data.

For example, in `routes.rb`:

``` ruby
Rails.application.routes.draw do
  get '/hello_world/' => 'application#hello_world'
  get '/hello/:name'  => 'application#hello_world'
end
```

The pattern `/hello/:name` tells Rails to route any requests with URL like `/hello/Puppi` to the `hello_world` action in the `ApplicationController`. The value that matches the `name` placeholder is going to be accessible in the controller with `params['name']`.


