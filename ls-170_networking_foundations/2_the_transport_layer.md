# The Transport Layer

### Chapter Focus:

Understanding the role of the Transport Layer is key to comprehending how networked applications communicate with each other. 

- How transport layer protocols enable communcation between processes
- Network reliability is engineered
- Understand the trade-offs


## Communication Between Processes

To create modern networked applications, we need a couple more things beyond what IP can provide:
1. direct connection between applications
2. reliable network communication

### Multiplexing and Demultiplexing

There may be many networked applications/processes running on a device at one time, and these applications will want to be able to send and receive data simultaneously. 

We can think of these different applications/processes as distinct *channels* for communication on a host machine.

**Def'n Multiplexing.** In context of a communication network, the idea of transmitting multiple signals over a single channel
**Def'n Demultiplexing.** The reverse process of multiplexing. 

In the Transport layer of the network communication model, this concept takes place through the use of **network ports**.

### Ports

**Def'n Port.** An identifier for a specific process running on a host; the identifier is an integer in range 0 to 65535.
- 0-1023: are well-known ports assigned to processes that provide commonly used network services (HTTP is port 80; FTP is port 20; ...)
- 1024-49151: are registered ports assigned as requested by private entities for specific services. 
- 49152-65535: are dynamic ports (aka private ports). They cannot be registered for a specific use, but can be used for customized services or allocation as *ephemeral ports*. 

A service running on a client machine won't use a well-known port, but have an ephemeral/temporary port assigned to it by the OS. 

Ports help with multiplexing and demultiplexing:
- source and destination port numbers are included in the PDU for the transport layer
- **IP address and port number together** "define" a *communication end-point* and enable end-to-end communication between specific applications on different machines

#### Netstat

Running `netstat -ntup` in terminal returns a list of active network connections. We see the Local Address and Foreign Address are combinations of IP addresses and port numbers. 

### Sockets

**Def'n Socket.** 
- At a conceptual level, it's an abstraction for an endpoint used for inter-process communication.
- At the implementation level, it can refer to:
    - UNIX socket: a mechanism for inter-process communication between local processes running on the same machine
    - Internet sockets (such as a TCP/IP socket): a mechanism for inter-process communication between networked proccesses

Focus here on the *concept* of a socket, and a teeny bit on the application in inter-network communication between networked applications (i.e. *Internet Sockets*).

### Sockets and Connections

There's two ways to manage multiple conversations: connectionless and connection-oriented networks communication.

An example of implementing a connectionless network communication:

![connectionless network communication][connectionless]

[connectionless]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-comms-between-processes-connectionless.png

One socket object defined by the IP address of the host machine and the port assigned to a particular process running on the machine. Messages to this socket can come from any source at any time in any order. 

An example of a connection-oriented networks communication:

![connection-oriented network communication][connection_oriented]

[connection_oriented]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-comms-between-processes-connection-oriented.png

Like a connectionless network, you could have a socket objected defined by the host IP and process port. However, when a message arrives we see the implementation difference. 

When a message arrives, we instantiate a new socket object defined by the source port, soure IP, destination port, and destination IP. The new socket object listens specifically for messages where all four pieces of information match, commonly referred to as a four-tuple. 

The connection-oriented networks communication creates a dedicated virtual connection for communication between specific processes. A benefit: we can more easily put rules in place for managing the communication such as the order of messages, acknolwedgements of receipt, retransmission of messages, etc. These additional communication rules add more reliability to the communication.


## Network Reliability

Because the protocols operating in the lower layers (ex: Ethernet and IP) do not replace any data that was lost, these layers of the model create an *unreliable communication channel*. 

To create a reliable channel, we need to develop a protocol to ensure that all the data sent is received in the correct order. 

### Building a Reliable Protocol

The fundamental elements required for reliable data transfer include:
- In-order delivery: data is received in the order that it was sent
- Error detection: corrupt data is identfied using a checksum
- Handling data loss: missing data is retransmitted based on acknowledgements and timeouts
- Handling duplication: duplicate data is eliminated through the use of sequence numbers

A model of a reliable protocol:

![reliable communication protocol][reliable_protocol_model]

[reliable_protocol_model]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-reliability-acknowledgement-sequence-number.png

with the following rules:
- Sender sends one message at a time, with a sequence number, and sets a timeout
- If message received, receiver sends an acknowledgement which uses the sequence number of the message to indicate which message was received
- When acknowledgement is received, sender sends next message in the sequence
- If acknowledgement is not received before the timeout expires, sender assumes either the message or the acknowledgement went missing and sends the same message again with the same sequence number
- If the recipient receives a message with a duplicate sequence number it assumes the sender never received the acknowledgement and so sends another acknowledgement for that sequence number and discards the duplicate


The issue with this model is its lack of efficiency. This is a Stop-and-Wait protocol: each message is sent one at a time and an acknolwedgement is received before the next message is sent.

### Pipelining for Performance

To improve the throughput of the above reliable protocol, we can send multiple messages one after the other without waiting for acknowledgements - mulitple messages are being transferred at any one time. This approach is referred to as *pipelining*. 

The sender implements a 'window' representing the maximum number of messages that can be in the 'pipeline'. Once the sender has received the appropriate acknowledgements for the messages in the window, it moves the window on.

![pipline window][pipeline_window]

[pipeline_window]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-reliability-windowing.png

The pipelined approach more efficiently uses the avaiable bandwidth. 


## Transmission Control Protocol (TCP)

The Transmission Control Protocol (TCP) is a corner-stone of the Internet. A key element is providing reliable data transfer. 

TCP provides that abstraction of reliable network communications on top of an unreliable channel. It hides the complexity of reliable communication from the application layer. Complexities include: data integrity, de-duplication, in-order delivery, and retransmission of lost data. 

Things TCP provides:
- reliable data transfer
- encapsulation
- multiplexing

### TCP Segments

*Segments* are the PDU of TCP. 

![TCP segment][tcp_segment]

[tcp_segment]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-layer-tcp-segment.png

**The TCP Header**

![TCP header fields][tcp_header]

[tcp_header]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-tcp-segment-header.png

TCP Segment header contains fields including:
- Implementing multiplexing:
    - Source port and destination port
- Implementing reliability:
    - *Checksum*: the error detection aspect of TCP -- if the receiver does not generate the same value as in the header, the segment is dropped
    - *Sequence Number* and *Acknowledgement Number*: these fields used together help with in-order delivery, handling data loss, and handling duplication
    - Window size: related to flow control
    - Flag fields:
        - `URG` and `PSH`: related to urgency of the data contained in the segment
        - `SYN`, `ACK`, `FIN`, `RST`: establish and end a TCP connection

### TCP Connections

TCP is a connection-oriented protocol and doesn't start sending application data until a connection has been established.

To establish a connection, TCP uses a **three-way handshake**. A *four-way handshake* is used for terminating connections.

![TCP three-way handshake][tcp_three_way_handshake]

[tcp_three_way_handshake]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-tcp-thre-way-handshake-data-delay.png
To establish a connection:
1. Sender sends a SYN message (a TCP segment with the `SYN` flag set to `1`)
2. Upon receiving this SYN message, the receiver sends back a SYN ACK message (segment w/ `SYN` and `ACK` flags set to `1`)
3. Upon receiving the SYN ACK, the sender sends an `ACK` (segment w/ `ACK` flag set to `1`)
    - sender can now send application data to receiver
    - after receiver receives this ACK, it can now send data to sender

This process synchronizes the sequence numbers that will be used during the connection. 

These flags in the TCP header manage the *connection state*. We are mostly concerned with the `ESTABLISHED` state and `LISTEN` on the server side. 

Here's [a table](https://launchschool.com/lessons/2a6c7439/assignments/d09ddd52) of connection states. (Ctrl+F "Three-way Handshake to Establish a Connection, with Connection States")

TCP involves a lot of overhead in terms of establishing connections and providing reliability through retransmission of lost data. 

### Flow Control

To facilitate efficient data transfer once a connection is estblished, TCP provides mechanisms for flow control and congestion avoidance.

**Flow Control:** a mechanism to prevent the sender from overwhelming the receiver with too much data at once. 
- Each side of the connection can let the other side know about the amount of data it can accept via the *Window* TCP header, a dynamic field that can adapt to the current capacity of the buffer.
- Flow control only prevents the sender from overwhelming the *receiver*, not the underlying network

### Congestion Avoidance

**Network Congestion:** occurs when more data is being transmitted on the network than there is network capacity. 

Context: At the next layer down, IP packets move across networks in a series of 'hops'. Before each hop, the packet needs to be processed by the router: checksum generation and routing a path to the destination. During this processing, packets queue up in buffers. If the router's buffer over-flows then those data packets are dropped. 

*TCP uses data loss as a feedback mechanism to detect and avoid network congestion.* 

### Disadvantages of TCP

- Latency overhead in establishing a TCP connection via handshakes
- Head-of-Line (HOL) blocking: a general networking concept that relates to how issues in delivering/processing a message in a sequence can delay/block the delivery/processing of subsequent messages


## User Datagram Protocol (UDP)

The PDU of UDP is known as a *Datagram*. 

![UDP Datagram Header][udp_header]

[udp_header]: https://da77jsbdz4r05.cloudfront.net/images/ls170/transport-udp-datagram-header.png

The header contains four fields:
- (1) Source port and (2) Destination port
    - Provides multiplexing 
- (3) UDP Length (i.e. the length in bits of the Datagram)
- (4) Checksum

UDP does *not* provide:
- a guarantee of message delivery
- a guarantee of message delivery order
- a built-in congestion avoidance or flow-control mechanisms
- a connection state tracking 

Basically, UDP doesn't provide anything for establishing a reliable network connection.

### The Case for UDP

The simplicity of UDP over TCP provides two advantages: speed and flexibility.

- UDP is a connectionless protocol - applications using UDP can start sending data without having to wait for a connection to be established. 
- Latency is less of an issue when no acknowledgements are required. 
- The lack of in-order delivery also removes the issue of Head-of-line blocking.
- Software engineers can choose to implement specific services (provided by TCP) to create the network reliability they need


## Summary

- *Multiplexing* and *demultiplexing* provide for the transmission of multiple signals over a single channel

- Multiplexing is enabled through the use of *network ports*

- *Network sockets* can be thought of as a combination of IP address and port number

- At the implementation level, sockets can also be socket objects

- The underlying network is *inherently unreliable*. If we want reliable data transport we need to implement a system of rules to enable it.

### TCP:
- TCP is a *connection-oriented* protocol. It establishes a connection using the *Three-way-handshake*

- TCP provides reliability through message acknowledgement and retransmission, and in-order delivery

- TCP also provides Flow Control and Congestion Avoidance

- The main downsides of TCP are the latency overhead of establishing a connection, and the potential Head-of-line blocking as a result of in-order delivery.

### UDP:
- UDP is a very simple protocol compared to TCP. It provides multiplexing, but no reliability, no in-order delivery, and no congestion or flow control.

- UDP is *connectionless*, and so doesn't need to establish a connection before it starts sending data

- Although it is unreliable, the advantage of UDP is speed and flexibility