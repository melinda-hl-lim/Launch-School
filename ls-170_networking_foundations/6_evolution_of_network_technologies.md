# The Evolution of Network Technologies

We explore the *how* and *why* network protocols and technologies have changed, and the importance of those changes for anyone developing networked applications today.

### Chapter Focus
- Know how and why HTTP is evolving
- Be aware of the functionality that browser APIs can provide
- Be aware that Client-Server isn't the only network paradigm


## HTTP: Past, Present, and Future

### HTTP/0.9

This version of HTTP was characterized by its *simplicity*. 

The request was a single line (no headers or request body) consisting of the method (`GET`) and path (for resource on the server).

The response would be a single hypertext document with no headers or other meta-data. 

### HTTP/1.0

Between 1991 and 1996 a number of pieces placed would eventually lead to the mass adoption of the internet and the use of the web:
- *Dramatic improvement in browser technology*. The first commercial browser - Netscape Navigator 1.0 - was built on the limited browsers developed by CERN
- Telecom companies started providing internet *access to the public via dial-up connections*
- The W3C (World Wide Web Consortium) and HTTP-WG (HTTP Working Group) were formed to provide a *framework for documentation and standardization* of web technologies
- Improvements to HTTP
  - HTTP methods `HEAD` and `POST`
  - HTTP headers to hold meta-data to requests/responses
  - `Content-Type` header: so HTTP can deliver more than HTML

### HTTP/1.1

Some issues/limitations at this point:
- No official standard
- Certain built-in inefficiencies that didn't serve the more complex content being produced

For each request-response cycle, a separate TCP connection was used. A major advance provided by HTTP/1.1 was connection *re-use* - the same TCP connection could be used for making multiple requests. 

HTTP/1.1 also added HTTP methods: `PUT`, `DELETE`, `TRACE`, `OPTIONS`

### HTTP/2

Standardized in 2015. HTTP/1.1 still had major drawbacks in supporting modern web applications of ever-increasing complexity. 

HTTP/1.1 pipelining allowed multiple reqquets to be sent at once; however, the server must respond to the requests in the order they are sent, sometimes resulting in a head-of-line blocking.

HTTP/2 provided multiplexed requests, compression of headers, ...

### HTTP/3

In development! It offers an alternative by using a protocol known as QUIC to provide the reliability and security features traditionally providd by a combination of TCP and TLS.


## Web Performance and HTTP Optimizations

### The Birth of the Modern Web

Started with single HTML documents (i.e. plain text with basic formatting and support for hyperlinks to other documents).

Now we have rich web pages with hypermedia resources (i.e. images, audio, richer layouts, ...)

New technologies to help reduce time for requests, loading web page

### Browser Optimizations

There are two broad types of optimizations:
- **Document-Aware Optimizations:** the browser leverages networking with parsing techniques to identify and prioritize fetching resources
  - Goal: more efficiently load a web page by prioritizing resources (ex: CSS layouts and JS) which take the longest amount of time
- **Speculative Optimizations:** the browser learns the navigation patterns of the user over time and attempts to predict user action
  - Includes: pre-resolving DNS names; pre-rendering pages of frequently visited sites; open a TCP connection in anticipation of an HTTP request when a user hovers a link

### Latency As The Main Limiter 

Latency can really be a major performance limiter for networked applications. However much the network infrastructure is improved, there will always be a base amount of latency developers must deal with.

Since we can't eliminate latency, we need to mitigate its impact. Optimizations include:
- eliminating unnecessary roundtripss
- minimizing resources to be fetched
- adding components to our system
- etc...

### Further Optimizations

- **Limit resources used on the site**

- **Compression Techniques:** reduce size of resources
  - gzip: text-based assets such as HTML, CSS, JS
  - minification: process of removing unnecessary/redundant data without affecting how its processed by the browser

- **Reusing TCP Connections**
  - TCP connections that we can reuse are 'keepalive connections' and standard behaviour with HTTP/1.1.
  - We need to check our application and server configurations to ensure they support keepalive connections
  - With HTTP/1.0, enable keep alive connections by adding the Connection: Keep-Alive header to HTTP requests/responses

- **DNS Optimizations**
  - Browser is responsible for performing the initial DNS lookup and various dependencies. Until the lookup is complete and domain name resolved, browser cannot connect to the server and download any resources
  - Optimize by:
    - reducing the number of hostnames that need to be resolved
    - download any external resources and host them locally on the server (remove DNS lookup for these resources)
    - pay for a faster DNS provider

- **Caching:** server-side caching
  - server-side caches are a separate component from the host sever -- think short-term memory bank
  - stores content that was recently requested so that it can be delivered more quickly next time it's requested


## Browser Networking APIs

### HTTP and Real-Time Data Synchronization

The request-response model isn't suited to real-time data synchronization because it requires a request to be sent by the client before a response can be returned. 

Modern browsers provide us with several APIs that can be levaraged to provide real-time data synchronization.

#### XHR (XMLHttpRequest)

XML is a markup language that defines a set of rules for encoding documents. However, XHR can also use data in JSON, HTML or text form.

XHR is key in AJAX, now a fundamental building block for nearly every modern web app.

*Polling*: an implementation to manage requests and responses asynchronously and programmatically by writing a script that issues a request to the server perioidically to check for updates (ex: every 60 seconds)

*Long polling*: Client makes a request but rather than returning an empty/negative response, the server keeps the connection idle until an update is available and then issues a response

#### SSE (Server-Sent Events)

Enables efficient server-to-client streaming of text-based event data -- i.e. server can send realtime notifications/updates to client without requiring client to send a request.

How? Delivery of messages over a single, long-lived TCP connection. After the client and server complete the TCP handshake and first request-response cycle, client keeps it open to the server to receive future updates. 

Trade-offs:
- Only works with client-server model
- Does not allow request streaming (such as when streaming a large upload to the server)
- streaming support is specifically designed to transfer UTF-8 data, so binary streaming is inefficient

#### WebSocket

A simple and minimal API that enables us to layer and deliver arbitrary application protocols between the client and server such that either side can send data to the other at any time. 


## Peer to Peer Networking

So far the network concepts we've explored have been framed within a particular netowrk architecture: the *client-server model*. 
- Participants in a data message exchange have clearly defined roles: client makes a request, server issues a response

Another model is **peer-to-peer (P2P) model**. There aren't clearly defined roles - each computer acts as a *node* that can function as both a client and a server. 

When we talk about a P2P network architecture, it refers to the way the *devices in the architecture interact*. The underlying infrastructure is the same for client-server architecture, including many of the protocols.

### Use Cases

- Lacks reliance on a central server:
  - No need to set up and maintain a server to provide they system with functionality - you just need >2 nodes
  - Use case: file sharing

- No need for communication to be routed through a central point
  - Reduces latency by giving shorter paths between a client and server
  - Use case: Real time communication like video calling

### Complexities of P2P

- Setting up a P2P network involves discovery (finding other nodes on the network)
  - Specific nodes may not always have the same IP address, and may be online at different times

- Solution: 
  - *flooding*, where a message is sent out to the network and each node forwards it until a specified number of network 'hops' has elapsed
  - *Distributed Hash Table (DHT)*: essentially a table of key-value pairs

### WebRTC


## Summary

- HTTP has changed considerably over the years, and is continuing to change.

- Many of the changes to HTTP are focussed on improving performance in response to the ever increasing demands of modern networked applications.

- Latency has a big impact on the performance of networked applications. As developers and software engineers we need to be aware of this impact, and try to mitigate against it through the use of various optimizations.

- In building networked applications, there are tools and techniques available to us that work around or go beyond the limitations of basic HTTP request-response functionality.

- For certain use cases a peer-to-peer architecture may be more appropriate than a client-server architecture.

