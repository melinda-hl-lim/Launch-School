## Outlining Our First App

Let's make the app respond to an HTTP request. Say we want a request from our browser to `/hello_world` to result in the text `Hello, world!` being displayed in the browser.

In Rails, it's a two-step process:

    1. Define where the request should go
    2. Define the code to handle a request of this kind

Accomplish step 1 by declaring a **route**.
Accomplish step 2 by defining a method on a **controller**.

    A method on a controller containing logic for handling a request is called in **action**.


## Sending Requests And Responses

### Defining a Route

A route is a combination of:

    1. an HTTP verb (GET, POST, ...) and
    2. a URL pattern, mapping to a combination of a *controller* and an *action*

Example route declaration in `config/routes.rb`:

``` ruby
get({ '/hello_world' => 'application#hello_world' })
```

The above is a method call to the `get` method and its passing in a hash as a parameter.

### Defining an Action

A controller action responds to an HTTP request and builds an appropriate HTTP response.

``` ruby
class ApplicationController < ActionController::Base
  def hello_world
    render plain: 'Hello, World!'
  end
end
```

Note: `render` is also another method call that takes a hash as an argument.
