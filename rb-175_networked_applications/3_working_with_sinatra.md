## Introduction

A web development framework is a productivity tool meant to help web developers speed up development by automating common tasks. It's powerful for the experienced, but confusing for the inexperienced.


## Rack

Rack is:
- a generic interface to help application developers connect to web servers
- a set of guidelines for how a web server and a Ruby app should talk to each other
- a web server interface that provides a fluid API for creating web applications
- a way to abstract away the mundane work of connecting and communicating with the web serving and content generating tiers of Ruby
- at the core, it's nothing more than some Ruby code connecting to a TCP server, handling requests and sending back responses all in an HTTP-compliant string format. 

Within our conceptual mental model:
![server_model](https://da77jsbdz4r05.cloudfront.net/images/working_with_sinatra/server-zoom-rack.png "Mental model of server")

**Resources Linked:**
- [Demystifying Ruby Applications, Ruby Application Servers, and Web Servers](https://medium.com/launch-school/demystifying-ruby-applications-ruby-application-servers-and-web-servers-c3d0fd415cb3)
  - Must re-read: explains the need for *web servers*, *application servers*

![modularity](https://miro.medium.com/max/1400/1*Z2ftxFcb03ZVU7Uml-SdIg.png)

- [What is 'Rack' in Ruby/Rails?](http://blog.gauravchande.com/what-is-rack-in-ruby-rails)

- [Launch School: Growing Your Own Web Framework with Rack] (https://launchschool.com/blog/growing-your-own-web-framework-with-rack-part-1)
  - This blog series is unread


  ## Notes from working with Sinatra