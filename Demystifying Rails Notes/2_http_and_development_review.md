## HTTP and Web Apps

The fundamental paradigm of a web application is to react to an *HTTP request* and to create an appropriate *HTTP response*. Rails just makes it this paradigm easier to deal with.

**Melinda must read "Introduction to HTTP" after other Andrew homework**

### The Client-Server Model

Http uses the client-server model.

In context of Rails web applications:
- client is a web browser
- server is what the Rails app runs on

Any interaction begins with the client sending an HTTP request to the server. The Rails app (server) then:

    1. figures out where to direct the request to be processed
    2. processes the request with pre-defined logic
    3. constructs a response

When these three steps are done, the server sends an HTTP response back to the client. The browser (client) then displays the response to the user.

### Every Client-Server Interaction Begins with an HTTP Request

An HTTP request has three parts:

    1. request line
    2. request headers
    3. request message body

For a basic understanding, we're only concerned with two pieces of the *request line*:

    1. the **request verb** (a.k.a. **request method**)
    2. the **request path**

For example... With domain name `http://www.launchschool.com` we might have the following requests:

    `GET /hello_world`
    `POST /create_post`

Based on the verb-path combination, the app decides what to do with the request.

### Every Client-Server Interaction Ends with an HTTP Response

An HTTP response has three parts:

    1. status code: tells client the general result of how the server processed the request
    2. headers: tells the client how the information should be handled
    3. body: can be empty; most of the time there's HTML carried as "payload"

### The Web Application in the Middle

The web application:
- interprets incoming requests
- pulls necessary data from the database
- follows pre-defined business rules
- generates the responses that carry the HTML document to be displayed in the user's browser


