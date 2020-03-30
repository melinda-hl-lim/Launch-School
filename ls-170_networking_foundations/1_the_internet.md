# The Internet

### Chapter Focus:
- Build a general picture of the network infrastructure
- Know the limitations of the physical network
- Understand that protocols are systems of rules
- IP (Internet Protocol) enables communication between devices


## What is the Internet?

The internet is a "network of networks". 

To understand this network of networks, we need to create a simpler model first. 

### A Basic Network:

A network, at the most basic level, is two devices connected in a way that they can communicate or exchange data. 
One way to connect two computers is with a *LAN* cable. 

### Local Networks:

*Local Area Network (LAN)* connect devices via a network bridging device like a hub or switch. All devices are connected via network cables.

At home, we follow the same principle by connecting to a wireless hub/switch. This is *Wireless LAN (WLAN)*.

### Inter-network Communication:

For networks to communicate between each other, we need *routers*, network devices that can route network traffic to other networks

### A Network of Networks

The internet is a vast number of these networks connected together. Between the sub-networks are systems of routers that direct network traffic.


## Protocols

**Def'n Protocols.** A set of rules governing the exchange or transmission of data.

There are a large number of different protocol for network communications mainly becuase:
1. Different protocols were developed to *address different aspects* of network communication
2. Different protocols were developed to *address the same aspects* of network communication, but in a *different way or for a specific use-case*

### Different Aspects of Communication

*Syntactical rules* govern the structure of the message.
For example:
- "are? today, how hellow you" does not follow English syntactical protocol
- "hellli, how are you today?" does follow English syntactical protocol

*Message transfer* rules determine the *flow and order* of messages.
For example, think about the rules of human conversation.


## A Layered System

Protocols function within layers of an overall system of communication. 

### Two Models of Computer Network Communcations

Two most popular models are the **OSI model** and the **Internet Protocol Suite** (a.k.a. TCP/IP model; DoD model)

![two internet models][models]

[models]: https://da77jsbdz4r05.cloudfront.net/images/ls170/layered-system-osi-tcp-ip-comparison.png

The two models model the internet differently:
- OSI model: divides layers in terms of the functions each layer provides (physical addressing, logical addressing and routing, encryption, compression, etc.)
- Internet Protocol Suite: divides layers in terms of the scope of communications within each layer (within a local network, between networks, etc.)

### Data Encapsulation

Within network models, ecnapsulation refers to hiding data from one layer by enclosing/encapsulating it within a data unit from the layer below

#### Protocol Data Units

**Def'n Protocol Data Unit (PDU).** An amount/block of data transferred over a network.
- Within different layers of the Internet model, PDUs are referenced by different names
- In general, the components of a PDU include: a header, a data payload, sometimes a trailer/footer

#### Header and Trailer

*Purpose*: provide protocol-specific metadata about the PDU
- Exact structure of headers/trailers vary from protocol to protocol.

#### Data Payload

**Def'n Payload.** The data we want to transport over the network using a specific protocol at a particular network layer. 

The data payload is the *key to the way encapsulation is implemented*. 
- The entire PDU from a protocol at one layer is set as the data payload for a protocol at the layer below.

![payload and encapsulation][encapsulation]

[encapsulation]: https://da77jsbdz4r05.cloudfront.net/images/ls170/layered-system-encapsulation.png

- The benefit of this approach is the separation it creates between the protocols at different layers. 
    - A protocol at one layer doesn't need to know anything about how a protocol at another layer is implemented.
    - It just knows it needs to encapsulate some data from the layer above and provide the result to the layer below.


## The Physical Network

Model layers:
- OSI: Physical Layer - Layer 1
- Internet Protocol Suite: no dedicated layer, but touches on some aspects of physical network in the Link layer

The 'physical' network is made of tangible pieces such as networked deices, cables, wires, electricity, radio waves, light, ...

The limitations of the physical world determine the physical characteristics of a network, and thus impact how protocols function further up at the conceptual level (i.e. top of model). 

### Bits and Signals

Depending on the transportation medium used, bits are converted to electrical signals, light signals or radio waves.

### Characteristics of a Physical Network

Two main characteristics in terms of the performance of a phsyical network are *latency* and *bandwidth*.

**Def'n Latency.** A measure of the time it takes for some data to get from point A to point B 

**Def'n Bandwidth.** The amount of data that can be sent at once. 

#### The Elements of Latency

There are different types of delay that, all together, determine the overall latency of a network connection.
- **Propagation delay:** the amount of time it takes a message to travel from the sender to the receiver (i.e. distance / speed).
- **Transmission delay:** the amount of time it takes to push the data onto the link, a segment/piece of the physical network that connects point A to B.
- **Processing delay:** data travelling across the physical network doesn't directly cross from one link to another, but is processed in various ways.
- **Queuing delay:** network devices (ex: routers) can only process so much data at one time. When it's at full processing capacity, the router queues/buffers the data. 

Total latency is the sum of all delays above in milliseconds.

Some additional terms we may encounter when discussing latency:
- **Last-mile latency:** A lot of the delays above take place closest to the network end points. 
- **Round-trip Time (RTT):** The total time for a signal to be sent and receive an acknowledgement/response

*Side note: Network Hops.* The journey of a piece of data on the network consists of several 'hops' between nodes on the network. We can view the 'hops' taken by executing `traceroute [host]` in terminal.

#### Bandwidth

Bandwidth varies across the network. The bandwidth a connection receives is the lowest amount at a particular point in the overall connection. 

#### Limitations of the Physical Networks

**Why do we care?**

As developers and software engineers, the performance of the applications we build is limited to the implementation of the application in terms of how we use higher-level protocols. Understanding the physical limitations of the Internet can impact the way we think about these higher-level protocols and how we use them in our application.


## The Link/Data Link Layer

Model layers:
- OSI model: Data Link - Layer 2
- Internet Protocol Suite: Link - Layer 1

This layer is an interface between the workings of the physical network and the more logical layers above, and is the lowest layer at which encapsulation takes place. Protocols at the layer are primarily concerned with *idenfitiying devices* on the physical network and *moving data between devices* that create the physical network.

The most commonly used protocol at this layer is the **Ethernet protocol**. The two most important aspects of Etherhnet are:
- **Framing**
- **Addressing**

### Ethernet Frames

Ethernet Frames are a Protocol Data Unit and encapsulate data from the Internet/Network layer above. 

An Ethernet Frame adds logical structure to the binary data that is transported by the physical layer to define which bits are the data payload and which bits are the metadata to be used in transporting the frame.

Different 'fields' of data have specific lengths in bytes and appear in a set order. The main takeaway: Ethernet Frames are *structured data*. Key components to remember are the *Source and Desination MAC addresses* and the *Data Payload*.

![ethernet frame data fields][ethernet_frame]

[ethernet_frame]: https://da77jsbdz4r05.cloudfront.net/images/ls170/data-link-layer-frame-structure.png

- **Preamble and SFD:** The Preamble and Start of Frame Delimiter (SFD/SOF) aren't considered part of the actual frame; they're sent prior to the frame as a synchronization measure to notify the receiving device to expect frame data and to indentify the start point of the data.
- **Source and Destination MAC address:** The next two fields each six bytes (48 bits) long. The source address is the address of the device which created the frame, and the destination address is the address of the device for which the data is intended.
- **Length:** This field indicates the size of the data payload (two bytes/16 bits).
- **DSAP, SSAP, Control:** These three fields are each one byte (8 bits) long. The DSAP and SSAP fields identify the Network Protocol used for the Data Payload. The Control field provides information about the specific communication mode for the frame, thus helping facilitate flow control.
- **Data Payload:** This contains the entire PDU from the layer above.
- **Frame Check Sequence (FCS):** The final four bytes (32 bits) is a checksum generated by the device which creates the frame and is used by a later receiving devie to see if any data was lost in transmission. 
    - Ethernet doesn't implement any kind of retransmission functionality - it's up to the higher leevl protocols to manage retransmission of lost data

*Side note: Differences Between Ethernet Standards*

The model and structure above describes a frame under IEEE 802.3 Ethernet standard, the most popular and widely used standard. Other versions have slightly different framing structures. The differences between standards don't matter too much - our main focus on MAC Address and Data Payload fields exist across Ethernet standards.

#### Interframe Grap

Ethernet specifies an *interframe gap (IFG)*, a brief pause between the transmission of each frame. This permits the receiver to prepare to receive the next frame. (This is in addition to the Preamble and SFD.)

### MAC Addresses

MAC Addresses are linked to a specific physical device - these addresses are assigned by the manufacturer. It's sometimes referred to as *physical address* or *burned-in address*. 

In a network where a hub connects the devices, each device receives the frame, checks the MAC address, and ignores the frame if the recipient address doesn't match its address. This is inefficient and not used often nowadays.

In a network connected by a switch, the switch keeps records of the MAC addresses of its connected devices, and the associated ethernet port. This way, it can send the frame to the one correct device. 

### A Problem of Scale

MAC Addressing works well for local networks. However, we couldn't scale the approach of using MAC addresses on a wider network since:
- MAC addresses are tied to a specific physical address
- Keep records of all MAC addresses create a flat, not hierarchical, lookup record 


## The Internet/Network Layer

Model layers:
- OSI model: Network - Layer 3
- Internet Protocol Suite: Internet - Layer 2

Primary function of protocols in this layer is to faciliate communication between hosts (e.g. computers) on different networks

The Internet Protocol (IP) is the predominant protocol used at this layer. The primary features are:
- routing capability via IP addressing
- encapsulation of data into packets

### Data Packets

The PDU within the IP Protcol is referred to as a *packet*. Packets are comprised of a Data Payload and a Header.
- *Data Payload*: The PDU from the layer above (Transport layer). It's usually a TCP segment or a UDP datagram. 
- *Header*: contains logical fields providing metadata used for transporting the packet

![IP packet][ip_packet]

[ip_packet]: https://da77jsbdz4r05.cloudfront.net/images/ls170/network-layer-ip-packet-structure.png

Some important header fields to keep in mind are:
- Version: version of the Internet Protocol used
- ID, Flags, Fragment Offset: these fields relate to fragmentation in the case that the Transport layer PDU is too large to be sent as one packet and needs to be sent as multiple packets and reassembled by the recipient
- TTL: Time to Live value in number of network 'hops' - ensures that any packets that don't reach their destination aren't left to endlessly bounce around the network
- Protocol: indicates the protocol used for the data payload
- Checksum: error-checking value to help the destination device know if it should drop the packet (IP doesn't handle retransmission)
- Source Address: 32-bit IP address of sender
- Destination Address: 32-bit IP address of intended recipient

### IP Addresses (IPv4)

IP Addresses are logical in nature -- they are not tied to a specific device, but assigned as required to devices as they join a network. 
- IP address of device must fall within a range of addresses available to the local network
- Range of addresses is defined by a network hierarchy, with a start address and end address (broadcast address) defining the range

Splitting a network into segments is sub-netting. 

#### Routing and Routing Tables

All routers on the network store a local routing table. These network addresses define a range of addresses within a particular subnet. The matching network address will determine where in the network hierarchy the subnet exists. 

### IPv6

In IPv4, addresses were 32-bits long. In IPv6, addresses are 128-bits long. There's also slight differences with their header strucure and lack of error checking. 

### Networked Applications

Internet Protocol enables communication between two networked devices anywhere in the world (whereas Ethernet protocol provides communication between devices on the same local network). 

However, for networked applications, communication between devices isn't enough. As devices may have many applications running on it, we need more beyond IP to ensure that specific application on the client can access the correct service on the server. This'll be within the Transport layer protocols that enable communication between specific applications. 


## Summary

- The internet is a vast *network of networks*. It's comprised of both *network infrastructure* (physical components) and *protocols* that enable the infrastructure to function.

### Protocols and Encapsulation:
- Protocols are *systems of rules*. Network protocols are systems of rules governing the exchange or transmission of data over a network.

- Different types of protocol are concerned with different aspects of network communication. It can be useful to think of these different protocols as operating at particular 'layers' of the network.

- *Encapsulation* is a means by which protocols at different network layers can work together.

- Encapsulation is implemented through the use of *Protocol Data Units (PDUs)*. The PDU of a protocol at one layer, becomes the data payload of the PDU of a protocol at a lower layer.

### Layers Covered: 

#### The Physical Network Layer:
- The *physical network* is the tangible infrastructure that transmits the electrical signals, light, and radio waves which carry network communications.

- *Latency* is a measure of delay. It indicates the amount of time it takes for data to travel from one point to another.

- *Bandwidth* is a measure of capacity. It indicates the amount of data that can be transmitted in a set period of time.

#### The Link/Data Link Layer:
- *Ethernet* is a set of standards and protocols that enables communication between devices on a local network.

- Ethernet uses a Protocol Data Unit called a *Frame*.

- Ethernet uses *MAC addressing* to identify devices connected to the local network.

#### The Internet/Network Layer:
- The *Internet Protocol (IP)* is the predominant protocol used at this layer for *inter-network communication*.

- There are two versions of IP currently in use: IPv4 and IPv6.

- The Internet Protocol uses a system of addressing (IP Addressing) to *direct data between one **device** and another across networks*.

- IP uses a Protocol Data Unit called a *Packet*.