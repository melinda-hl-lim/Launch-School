# Lesson 2: Handling Requests Manually

### Lesson Focuses & Goals

- Remember: HTTP is just an exchange of textual information between a client and server

**Learning Objectives:**

- Understand the structure of requests and responses as well and how they are interpreted by software

- Gain some intuition/sense of the benefits of higher-level tools providing a nice interface for working with HTTP

## Coding Along With This Lesson

Recall: a server consists of many different components - web server, application server, data store, ...

In this lesson, our server is just an application server.

The focus here is understanding application code and HTTP, not server infrastructure (for now). 

Keep this diagram in mind as we continue through the lesson:

![server](https://da77jsbdz4r05.cloudfront.net/images/handling_requests_manually/server-zoom-tcp-ruby.png "Our server")

Our application is made up of our TCP server and some Ruby code.


## A Simple Echo Server

In a file called server.rb:
``` ruby
require "socket"

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept
  
  request_line = client.gets
  puts request_line # print to console for us

  client.puts request_line # display in browser
  client.close
end
```
What's nice about this small program: our requests and responses are just text, which is ultimately, under HTTP, what everything is. 

Next we'll look at what we need to do to handle a request and send back a response. 


## Parsing Path & Parameters

Given dice rolling program:
``` ruby
require "socket"

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept
  
  request_line = client.gets

  client.puts request_line # display in browser
  client.puts rand(6) + 1 # display a random number - like a die!

  client.close
```

Requests to a server are kind of like function calls in that they can take arguments and returns a value (response).

What information do we need to send along to the program to determine: (a) number of dice and (b) sides on each dice?

We can use query parameters:
`http://localhost:3003/?rolls=2&sides=6`
or paths:
`http://localhost:3003/rolls/2/sides/6`. 
However, paths implies a hierarchy between rolls and sides.

We're writing code to parse URL parameters.

GET request line to parse: `GET /?rolls=2&sides=6 HTTP/1.1`

``` ruby
require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ") 
  path, params = path_and_params.split("?")

  params = params.split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept
  request_line = client.gets

  # parse URL
  http_method, path, params = parse_request(request_line)

  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  # display result of all dice rolls
  rolls.times do
    roll = rand(sides) + 1
    client.puts roll
  end

  client.close
end
```


## Sending a Complete Response

Continuing off last section's code:
``` ruby
require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ") 
  path, params = path_and_params.split("?")

  params = (params || "").split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept
  request_line = client.gets

  # parse URL
  http_method, path, params = parse_request(request_line)

  # create response
  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"

  client.puts "<h1>Rolls!</h1>"
  rolls = params["rolls"].to_i
  sides = params["sides"].to_i

  # display result of all dice rolls
  rolls.times do
    roll = rand(sides) + 1
    client.puts "<p>#{roll}</p>"
  end
  client.puts "</body>"
  client.puts "</html>"

  client.close
end
```
Negative about our code: We mix our Ruby logic and HTML together

**Learning point (other than inconvenience):**
A HTTP response needs three components:
- status code: the overall result of processing request
- headers: other values of the response in a key-value format
  - the only one in our response is the `Content-Type`
- body: 
  - here we were generating HTML and rolling our virtual dice


## Persisting State in the URL

We want to write a counter. Click a link to increment, another link to decrement.

This program will have to remember a state for the current number. This will be a parameter in the URL.

``` ruby
require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split(" ") 
  path, params = path_and_params.split("?")

  params = (params || "").split("&").each_with_object({}) do |pair, hash|
    key, value = pair.split("=")
    hash[key] = value
  end

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept
  request_line = client.gets

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.0 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<html>"
  client.puts "<body>"

  client.puts "<h1>Counter</h1>"

  number = params["number"].to_i
  client.puts "<p>The current number is #{number}.</p>"
  
  client.puts "<a href='?number=#{number - 1}'>Subtract one</a>"
  client.puts "<a href='?number=#{number + 1}'>Add one</a>"
  client.puts "</body>"
  client.puts "</html>"

  client.close
end
```

**Learning point:**
- By carefully crafting URLs and links, we can give the impression of a persistant state across refreshes


## Dealing with Empty Requests

Since this project is at such a low level, there's some strange behaviours we need to work with. 

Once is handling empty requests. We can add `next unless request_line` in our code to avoid this issue.


## Summary

- Although it is not something you'd normally do, it is possible to interact with HTTP manually because it is a *text-based protocol*. 

- HTTP is built on top of TCP, which is a networking layer that handles communicating between two computers.

- URLs are made up of many components: a protocol, a host, a port, a path, and parameters.

- Query parameters are parameters that are included in a URL. They are appended to the path using ?. Parameters are specified in the URL using the form key=value.

- Parameters after the first are appended to the URL using &.

- HTTP is stateless, which means that each request is handled separately by the server. By carefully crafting URLs and parameters, stateful interactions can be built on top of HTT