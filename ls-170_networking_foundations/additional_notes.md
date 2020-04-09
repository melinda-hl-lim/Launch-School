### The Intenet - An Overview of Layers

|   OSI Model   |    TCP/IP     |     Protocol (PDU)    |
|:-------------:|:-------------:|:---------------------:|
| Application   |               | HTTP (Request/Response) |
| Presentation  | Application   |                       |
| Session       |               | TLS                   |
| Transport     | Transport     | TCP (Segment) / UDP (Datagram) |
| Network       | Internet      | IP (Packet)           |
| Data Link     | Link          | Ethernet (Frame)      |
| Physical      |               |                       |

*Note:* The Application Layer is not the application itself, but rather a set of protocols which provide communication services to applications.

#### More In Depth:

*Physical layer:* bits (binary data) are transported as signals in the form of electricity, light and waves.
- Limitations:
  - latency
  - bandwidth

*Link/Data Link layer:* 
- Protocol: Ethernet Protocol
- Purpose: add logical structure to binary data via ethernet frame
- Key features:
  - framing
  - addressing
- Key components of PDU: 
  - Source/Destination MAC addresses
  - data payload

*Internet/Network layer:* 
- Protocol: Internet Protocol (IP)
- Purpose: facilitate communication between hosts on different networks
- Key features: 
  - routing capability via IP addressing
  - encapsulation of data into packets
- Key components of PDU:

*Transport layer:*
- Protocol: Transmission Control Protocol (TCP)
- Purpose: provide (an abstraction) of reliable network communications and data transfer
- Key features:
  - multiplexing: provide direction connection between applications
  - reliable data transfer
  - encapsulation
- Key components of PDU:
  - Source and destination ports 
  - Checksum - error detection
  - Sequence and Acknowledgement number (help with in-order delivery, handling data loss, and handling duplication)
  - Window size - flow control
  - Flag fields 

- Protocol: User Datagram Protocol (UDP)
- Key features:
  - does *not* provide components for a reliable protocol

*Application layer:*
- Protocol: Hypertext Transfer Protocol (HTTP)
- Purpose: Focuses on the structure of the message and the data it should contain


### Building a Reliable Protocol 

The fundamental elements required for reliable data transfer include:
- In-order delivery: data is received in the order that it was sent
- Error detection: corrupt data is identfied using a checksum
- Handling data loss: missing data is retransmitted based on acknowledgements and timeouts
- Handling duplication: duplicate data is eliminated through the use of sequence numbers
