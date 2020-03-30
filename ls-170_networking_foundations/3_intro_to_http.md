# Intro to HTTP

### What to Focus On
- Understand the role of HTTP in conjunction with the other network technologies
- Break things down into individual components


## The Application Layer

Model layers:
- OSI model: Session, Presentation and Application - Layers 5-7
- Internet Protocol Suite: Application - Layer 4

The Application Layer is **not** the application itself, but rather *a set of protocols which provide communication services to applications*. 

Application layer protocols *focus on the structure of the message (syntactical rules) and the data it should contain* . It relies on lower level protocols for managing the establishment and flow of communication. 

### Application Layer Protocols

Since application layer protocols focus on syntactical level rules, many different protocols exist in this layer. 

In this lesson, we focus primarily on HTTP, the primary protocol for communication on the Web.


## HTTP and the Web

First we must define 'internet' and 'web'.

Recall, the internet is a network of networks. It's the infrastructure that enables inter-network communication.

**Def'n World Wide Web (web).** A service that can be accessed via the internet. It's a vast information system comprised of resources which are navigable by URL (Uniform Resuorce Locator).

### A Brief History of the Web

Some CERN workers wanted an easily accessible information system that could be accessed from any computer connected to a network.

A key element of such a system is uniformity. As an MVP, the web consisted of:
- **Hypertext Markup Language (HTML):** uniformly structure the resources (text information) within the system 
- **Uniform Resource Identifier (URI):** uniformly address resources within the system
- **Hypertext Transfer Protocol (HTTP):** a set of rules to uniformily transfer resources between applications


## The HTTP Book

### Background

#### How the Internet Works

![browser request][browser_request]

[browser_request]: https://d186loudes4jlv.cloudfront.net/http/images/internet.png

##### DNS

The **Domain Name System (DNS)** provies a mapping of URL to IP addresses. It's a distributed database that translates 'http://google.com' into an IP address and maps the request to a remote server. 

**DNS servers** store the DNS databses. There's a large world-wide network of hierarchically organized DNS servers, and no single server contains the complete database. 

#### Clients and Servers

**Clients** request information, **servers** provide information as a response.

**Web Browser:** the most common client; an application we use daily
- web browsers issue HTTP requests and process HTTP responses

#### Resources

**Resource** is a generic term for things you interact with on the Internet. Resources can include files, web pages, software for playing video games, etc...

#### Statelessness

A protocol is **stateless** when it's designed in a way that each request/response pair is completely independent of the previous one. 

**HTTP is a stateless protocol.** 
- The server doesn't need to keep track of any information (state) between requests
- When a request breaks en route to the server, no part of the system has any cleanup to do.

This means web developers have to work hard to simulate a stateful experience in web applications.

### What is a URL?

**Def'n URI (Uniform Resource Identifier).** A general concept that specifies how resources are located.

**Def'n URL (Uniform Resource Locator).** The address you enter into a browser to request a specific resource

#### URL Components

This is an example URL: `http://www.example.com:88/home?item=book`. The URL ontains 5 parts:
1. The scheme - `http`: tells the web client how to access the resource
    - always before the `://`
    - other popular schemes include: `ftp`, `mailto`, `git`
2. The host - `www.example.com`: tells the client where the resource is hosted/located
3. The port - `:88`: only required if you want to use a port other than the default
    - default for HTTP is `80`
4. The path - `/home/`: shows what local resource is being requested
    - optional
5. The query string - `?item=book`: used to send data to the server
    - made up of query parameters
    - optional.

#### Query Strings/Parameters

Query strings are passed in through the URL, so they are only used in HTTP GET requests. 

Some limits of query strings:
- Maxmimum length limit
- name/value pairs are visible in the URL - cannot pass sensitive information 
- Space and special characters like `&` can't be used - they must be URL encoded

#### URL Encoding

URLs are designed to accept only certain characters in the standard 128-character ASCII character set. Characters that are reserved, unsafe, or not included in the character set must be encoded - replace the char with a `%XX` where `XX` is a two hexadecmial digit.

So what's safe in a URL?
- alphanumeric
- these special characters: `$-_.+!'()",`
- reserved characters when used for their reserved purpose

### Preparations: Tools for Demonstrating How HTTP works

**HTTP GUI Tools**

Launch School uses Paw 3 (a paid app :c ). Other alternatives are Insomnia and Postman.

**HTTP Command line Tools**

`curl` is a free command line tool to issue HTTP requests.

### Making HTTP Requests

#### HTTP Request with a Browser vs. Tool

With a browser, it's super easy: Type the URL into a browser, and the browser processes the response for us into a pretty web page.

With a tool, the tool sends the request but also allow us to see the raw HTTP response data. 

#### Using the Inspector

**Inspector:** A built-in browser tool that lets us view HTTP requests and responses. 

From looking at the network tab, we can see lots of requests and responses for individual resources (images, text posts, etc.). These requests are for all *referenced resources*. 

With HTTP tools, the individual requests and responses are displayed in one huge chunk of raw HTTP response data - but we can see each individual request/response in the inspector tool.

#### Request Methods

In Inspector under the *Network* tab, we can see two columns **Method** and **Status**.
- The *Method* column displays the **HTTP Request Method**. 
- The *Status* column displays the response status for each request. Note: every request gets a response - an error is still a response (except *time out*). 

#### GET Requests

- GET requests are used to retrieve a resource
    - Most links are GETs
- The response from a GET request can be anything
    - If it's HTML, and that HTML references other resources, your browser automatically requests those referenced resources (a HTML tool will not)

#### POST Requests

POST requests are used when you want to initiate some action on or send data to a server. 
- allows us to send much larger and sensitive data to the server

The **HTTP body** contains the data being transmitted in an HTTP message, and is optional.

#### HTTP Headers

HTTP headers allow the client and server to send additional information during the request/response HTTP cycle. 

#### Requests Headers

Request headers give more information about the client and the resource to be fetched. Some useful headers include:
- Host: domain name of server
- Accept-Language: list of acceptable human languages
- User-Agent: string that identifies the client
- Connection: type of connection the client would prefer

### Processing Responses

**Def'n Response.** The raw data returned by the server.

#### Status Code

**Def'n HTTP Status Code.** A three-digit number that the server sends back after receiving a request that signifies the status of the request

Status codes to know:
- *200 OK*
- *302 Found*: a redirect. See below.
- *404 Not Found*: The server returns this status code when the requested resource can't be found. 
- *500 Internel Server Error*: indicates a server-side issue. 

**302 Found**

When a resource is moved, we re-route the request from the original URL to the new URL. This is a `redirect`. The browser sees a status code of 302, knows the resource was moved, and automatically follows the new re-routed URL in the `Location` response header.

#### Response Headers

Response headers offer more information about the resource being sent back. Some common response headers include:
- Content encoding: type of encoding used on the data
- Server: name of server
- Location: notify client of a new resource location
- Content-type: type of data the response contains

### Stateful Web Applications

Recall, HTTP is a stateless protocol. Each request made to a resource is treated as a brand new entity, and different requests are not aware of each other. 

Here we discuss techniques used by web developers to simulate a stateful experience: sessions, cookies and AJAX. With some help from the client (i.e. browser), HTTP can be made to act as if it were maintaining a stateful connection. 

#### Sessions

A **session identifier** is a unique token provided by the sever to the client. The client appends the token as part of the request, allowing the server to identify clients. 

Some consequences:
- every request must be inspected to see if it contains a session ID
- if the request does, the server must check to ensure the session id is still valid
- the server needs to retrieve the session data based on the session id
- the server needs to recreate the application state from the sesion data and send it back to the client as a response

#### Cookies

One common way to store session information is with a browser cookie.

A **cookie** is a piece of data that's sent from the server and stored in the client during arequest/response cycle. **Cookies** or **HTTP cookies** are small files stored in the browser and contain the session information. 

When we access a website for the first time, the server sends session information and setes it in the browser cookie. The client side cookie is compared to the server-side session data on each request to identify the current session. 

#### AJAX

AJAX stands for Asynchronous JavaScript and XML. It allows browsers to issue requests and process responses without a full page refresh (i.e. asynchronously). 

Responses from these AJAx requests are processed by some `callback`, a piece of logic you pass on to some function to be executed after a certain event has happened.

### Security

The same attributes that make HTTP difficult to control also make it difficult to secure. 

#### Secure HTTP (HTTPS)

With HTTPS every request/response is encrypted before being trasnported on the network. This prevents *packet sniffing* techniques (where malicious hackers attached to the same network read the message).

HTTPS sends messages through a cryptographic protocol called **TLS** for encryption. Earlier versions of HTTPS used *SSL (Secure Sockets Layer)*.

#### Same-origin Policy

A concept that permits unrestricted interaction between resources originating from the same origin, but restricts certain interactions between resources originating from different origins. 
- *Origin* refers to the combination of a url's scheme, hostname, and port.

Same-origin policy doesn't restrict *all* cross-origin requests. What's typically restricted include:
- cross-origin requests where resources are being accessed programmatically using APIs

Requests that are typically okay:
- linking
- redirects
- form submissions to different origins
- embedding resources from other origins 

To work around the same-origin policy, **cross-origin resource sharing (CORS)** is a mechanism that allows for those restricted interactions. It works by adding new HTTP headers. 

#### Session Hijacking

Session hijacking occurs if an attacker gets a hold of a session id. Both the user and the attacker can access the web application in that session, and the user wouldn't even know!

**Countermeasures for Session Hijacking**

- Resetting sessions: a successful login renders an old session id invalid and creates a new one
- Expiration time on sessions
- HTTPs across the entire app to minimze chances of an attacker getting the session id

#### Cross-Site Scripting (XSS)

**Cross-site scripting (XSS):** a type of attack that occurs if you don't sanitize your input. 
- When you allow users to input HTML/JS that ends up being displayed by the site directly, users can inject raw HTML/JS into the input and the browser will interpret that code and execute it.

**Countermeasures for XXS**
- Sanitize user input
- Escape all user input data when displaying it (so the browser doesn't interpret it as code)
    - 'escaping' means to replace any HTML character with a combination of ASCII characters, telling the client to display the character as is (not process it as code)


## Some Background and Diagrams

This chapter has a few diagrams to help set up an initiali mental model of how server-side development works. 

### Client-Server

So far, we underestand that the client issues an HTTP request to the server. The server then processes the request and sends a response back. 

![client-server][client_server]

[client_server]: https://da77jsbdz4r05.cloudfront.net/images/handling_requests_manually/client-sever.png

To understand server-side development we need to zoom in to the server above.

The server has three conceptual components (distributed across many machines). Three primary server-side infrastruture pieces include:
- *web server:* a server that responds to requests for static assets (no data processing required)
- *application server:* a server that contains application/business logic and handles more complicated requests
- *data store:* usually persistent; like a data base, simple files, key-value stores, etc.

### HTTP over TCP/IP

HTTP operates at the application layer and is concerned with structuring the messages that are exchanged between applications. 

TCP and IP does all the heavy lifting and ensuring that the request/response cycle getes completed between your browser and the server.


## URLs

**URI.** A "sequence of characters that identifies an abstract or physical resource"
**URL.** A subset of URIs that, in addition to identifying a resource, provide a means of locating the resource by describing its primary access mechanisms

### Scheme and Protocls

**Scheme.** The URL component that prepends `://`.

In the context of a URL, the scheme identifies which *protocol* should be used to access the resource

### URL and Filepaths

The path portion of the URL is determined by application logic and doesn't have any relationship to an underlying file structure. 

The way the path is used varies according to the specific implementation of the application/framework. It often involves URL pattern-matching to match the path to a pre-defined 'route' which executes some speciic logic.


## The Request Response Cycle

Required components of a HTTP request:
- host 
- method 
- path

The two above form a 'start-line'/'request-line'

Optional components of a HTTP request: 
- params
- all other headers
- message body

Required components of a HTTP response:
- status code

All other headers and body are optional

What determines whether a request should use `GET` or `POST` as its HTTP method?

`GET` requests should only retrieve content from the server (i.e. read only operations for a general rule of thumb).

`POST` requests involve changing values that are stored on the server. 


## Summary

- The **Domain Name System (DNS)** is a distributed database which translates a domain name such as google.com to an IP Address such as 216.58.213.14.

- A **URI** is an identifier for a particular resource within an information space.

- A **URL** is a subset of URI, but the two terms are often used interchangeably.

- URL components include the *scheme*, *host* (or hostname), *port*, *path*, and *query string*.

- Query strings are used to pass additional data to the server during an HTTP Request. They take the form of name/value pairs separated by an = sign. Multiple name/value pairs are separated by an & sign. The start of the query string is indicated by a ?.

- *URL encoding* is a technique whereby certain characters in a URL are replaced with an ASCII code.

- URL encoding is used if a character has no corresponding character in the ASCII set, is unsafe because it is used for encoding other characters, or is reserved for special use within the url.

- A single HTTP message exchange consists of a *Request and a Response*. The exchange generally takes place between a *Client* and a *Server*. The client sends a Request to the server and the server sends back a Response.

- An HTTP Request consists of a request line, headers, and an optional body.

- An HTTP Response consists of a status line, optional headers, and an optional body.

- Status codes are part of the status line in a Response. They indicate the status of the request. There are various categories of status code.

- HTTP is a *stateless protocol*. This means that each Request/ Response cycle is independent of Request and Responses that came before or those that come after.

- Statefulness can be simulated through techniques which use *session IDs*, *cookies*, and *AJAX*.

- HTTP is inherently insecure. Security can be increased by using HTTPS, enforcing Same-origin policy, and using techniques to prevent Session Hijacking and Cross-site Scripting.
