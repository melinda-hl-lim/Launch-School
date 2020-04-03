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



## Web Performance and HTTP Optimizations

### The Birth of the Modern Web

### Browser Optimizations

There are two broad types of optimizations:
- **Document-Aware Optimizations:** the browser leverages networking with parsing techniques to identify and prioritize fetching resources
  - Goal: more efficiently load a web page by prioritizing resources (ex: CSS layouts and JS) which take the longest amount of time
- **Speculative Optimizations:** the browser learns the navigation patterns of the user over time and attempts to predict user action
  - Includes: pre-resolving DNA names; pre-rendering pages of frequently visited sites; open a TCP connection in anticipation of an HTTP request when a user hovers a link

### Latency As The Main Limiter

### Further Optimizations

- **Limit resources used on the site**
- **Compression Techniques**
- **Reusing TCP Connections**
- **DNS Optimizations**
- **Caching**




## Browser Networking APIs



## Peer to Peer Networking



## Optional: Blog Post



## Summary