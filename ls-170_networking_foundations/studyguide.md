## The Internet

#### Have a broad understanding of what the internet is and how it works

The internet is a network of networks. It is made up of its network infrastructure (i.e. physical components) and the sets of protocols which allow us to transfer data through the physical infrastructure.

#### Understand the characteristics of the physical network, such as latency and bandwidth

Within the physical network, we transfer data through signals such as light, electricity, and waves (in the air). Because of this, all data transfer through the internet is limited by the physical laws of the world around us. 

Two main limitations we pay attention to are latency and bandwidth.

Latency refers to the time delay in a data transmission. It can be caused by:
- the physical travelling distance (propagation delay)
- the amount of time it takes to push a data from one segment of the network to another (transmission delay)
- data processing between network hops (processing delay)
- and the data waiting its turn to be passed on by a busy network device (queueing delay). 

Bandwidth refers to the capacity of our data transfer channel. As bandwidth can vary throughout the length of a transmission's path, the bandwidth of a transfer is generally determined by its minimum capacity along the path.

#### Have a basic understanding of how lower level protocols operate

Lower level protocols refer to protocols that operate at the physical layer, link/data link layer, and the internet/network layer. 

BLANK

However, these lower layer protocols do not provide any network reliability (as no lost data is replaced) -- this responsibility falls on the higher level protocols BLANK and BLANK.

#### Know what an IP address is and what a port number is

An **IP address** is a unique identification address assigned to a device that enters a local network. 

A **port number** refers to the channel through which we are communicating with the application. 

The IP address and port number combined create **socket**, a conceptual endpoint for inter-process communication that allows for **multiplexing** (transport layer). 

#### Have an understanding of how DNS works

The **Domain Name System (DNS)** provies a mapping of URL to IP addresses. It's a distributed database that translates 'http://google.com' into an IP address and maps the request to a remote server.

DNS servers store the DNS databses. There's a large world-wide network of hierarchically organized DNS servers, and no single server contains the complete database. 

If a DNS server does not contain a requested domain name, the DNS server routes the request to another DNS server up the hierarchy.

#### Understand the client-server model of web interactions, and the role of HTTP as a protocol within that model

In the client-server model of web interactions, the two devices have clear roles: the client requests information, and the server provides information as a response. 

HTTP is the protocol used within the Application Layer of the network model. It creates a standardized means through which we can pass messages. The HTTP protocol focuses on uniformly structuring messages sent between the client and the server. 

HTTP messages are paired as requests and responses - the client requests and the server responds. 

**Different servers**

A web server is typically a server that responds to requests for static assets: files, images, css, javascript, etc. These requests don't require any data processing, so can be handled by a simple web server.

An application server, on the other hand, is typically where application or business logic resides, and is where more complicated requests are handled. This is where your server-side code lives when deployed.

The application server will often consult a persistent data store, like a relational database, to retrieve or create data.


## TCP & UDP

#### Have a clear understanding of the TCP and UDP protocols, their similarities and differences.

TCP and UDP tradeoffs:
- Simplicity of UDP over TCP provides speed and flexibility
  - As a connectionless protocol, applications using UDP can start sending data without having to wait for a connection to be established.
  - Fewer issues with latency and head-of-line blocking
  - Software engineers can choose to implement specific services (provided by TCP) to create the network reliability they need
- TCP provides reliability through message acknowledgement and retransmission, and in-order delivery. UDP does not.

Similarities:
- Operate at the transport layer
- Provides multiplexing

Differences:
- TCP is a connection-oriented protocol, while UDP is a connectionless protocol
- TCP provides reliability (in network connection), while UDP does not

#### Have a broad understanding of the three-way handshake and its purpose

The three-way handshake is completed to establish a TCP connection. 

The handshake first starts with the sender of data sending a SYN message. Upon receiving the SYN message, the receiver sends back a SYN ACK message to tell the sender it received the first SYN message. Upon receiving the SYN ACK message, the sender sends an ACK message to tell the receiver that it has received its SYN ACK message. Once the ACK message is sent, the sender can send data to the receiver; after the receiver receives the ACK message, it can send data to the sender. 

#### Have a broad understanding of flow control and congestion avoidance

Flow control is a mechanism to prevent the sender from overwhelming *the receiver* with too much data. TCP uses the `window` field to help with flow control: each side of the connection can let the other side know about the amount of data it can accept through the `window` field. Furthermore, this field holds a dynamic value so it can be adapted to the current capacity of the device's buffer. 

Network congestion occurs when more data is being transmissted on *the network* than there is capacity. TCP uses the `checksum` field to facilitate *congestion avoidance*: if data is being dropped because the network is at full capacity, the `checksum` field reflects this data loss; TCP can then use this information to detect and avoid network congestion and adjust data transfer accordingly. 


## URLs

#### Be able to identify the components of a URL, including query strings, and be able to construct a valid URL

Example: `http://www.example.com:88/home?item=book`

Within the example above we have:
1. The scheme - http: tells the web client how to access the resource
2. The host - www.example.com: tells the client where the resource is hosted/located
3. The port - :88: only required if you want to use a port other than the default
4. The path - /home/: shows what local resource is being requested
5. The query string - ?item=book: used to send data to the server

#### Have an understanding of what URL encoding is and when it might be used

URLs are designed to accept only certain characters from the standard ASCII set. In URL encoding, any character that is reserved, unsafe, or not included is encoded like so: `%XX` where `XX` is two hexadecimal digits.


## HTTP and the Request/Response Cycle

#### Be able to explain what HTTP requests and responses are, and identify the components of each

WHAT ARE HTTP REQUESTS/RESPONSES?

The *required components for a HTTP request* include: the host, HTTP method, and path. Optional components include: parameters, all other headers, and the HTTP message body.

The *required components for a HTTP response* include: the status code. All other headers and the HTTP message body is optional. 

#### Be able to describe the HTTP request/response cycle



#### Be able to explain what status codes are, and provide examples of different status code types

A HTTP Status Code is a three-digit number the server sends back after a request. 

Some common status codes include:
- 200 OK
- 302 Found: a redirect
- 404 Not Found: the requested resource can't be found
- 500 Internel Server Error: a server-side issue

#### Understand what is meant by 'state' in the context of the web, and be able to explain some techniques that are used to simulate state

In the context of the web, a 'state' is the idea of BLANK. 

Some techniques to simulate state include:
- simulating user sessions by using browser cookies
- AJAX

Cookies: a cookie is a piece of data that is sent from the server and stored in the client. These cookies can help simulate a stateful experience since the cookie contains session information.

AJAX: Asynchronous JavaScript and XML allows browsers to issue requests and process responses asynchronously (i.e. without a full page refresh). 

#### Explain the difference between GET and POST, and know when to choose each

The `GET` request is used to retrieve a resource. The response for a `GET` request can be any type of resource.

The `POST` request is used to initiate some action or send data to a server. `POST` requests allow us to send more and/or sensitive data to the server. 

With these differences in mind, we would want to use a `GET` request anytime we want to simply view a resource (ex: a wikipedia article, a GIF on Reddit, ...), while a `POST` request is more suitable for interacting with the server (ex: submitting a sign up form, submitting a new record for a database, ...)


## Security

#### Have an understanding of various security risks that can affect HTTP, and be able to outline measures that can be used to mitigate against these risks

HTTP risks happen because...

Some measures to mitigate these risks include:
- Secure HTTP (HTTPS): encrypts messages
- Same-origin Policy
- Sanitizing params - avoid Cross-Site Scripting (XSS)
- Performing countermeasures to session hijacking

*HTTPS* ensures that every request/response is encrypted before being transported on the network (via TLS Protocol). This prevents packet sniffing, a phenomenon where a malicious third party attaches to the same network, intercepts the packet, and reads the message.

*Same-origin Policy* permits unrestricted interactions between resources from the same origin (combination of a url's scheme, hostname and port), but limits some interactions between resources from different origins. Typically the cross-origin requests limited are those where resources are being accessed via an API. Requests through linking, redirects, form submission, and embedded resources are usually fine. 

*Cross-Site Scripting (XSS)* is a type of attack that occurs if you don't sanitize the parameters you receive from user inputs. When you allow users to input HTML/JS that ends up being displayed by the site directly, users can inject raw HTML/JS into the input and the browser will interpret that code and execute it. An easy way to avoid XSS is sanitizing user inputs, and escaping all user input data when displaying it.

Countermeasures for *session hijacking*:
- Resetting sessions: a successful login renders an old session id invalid and creates a new one
- Expiration time on sessions
- HTTPs across the entire app to minimze chances of an attacker getting the session id

#### Be aware of the different services that TLS can provide, and have a broad understanding of each of those services

The services that TLS provides include:
- **encryption**: encoding the message so only those that can decode can read the message
- **authentication**: verify the identity of a particular party in the message exchange
- **integrity**: detect whether a message has been interfered with or faked 

TLS provides these services through:
- The TLS Handshake (encryption)
- The TLS Certificate (authentication)
- The `MAC` field (Message Authentication Code) generated through a hashing algorithm
