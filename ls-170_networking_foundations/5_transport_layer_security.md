# Transport Layer Security

### Chapter focus:
- TLS provides for secure message exchange over an unsecure channel
- There are multiple aspects to security


## The Transport Layer Security (TLS) Protocol

The **Transport Layer Security (TLS) protocol** started out as the *Secure Sockets Layer (SSL) protocol*. Nowadays, people will use SSL certificates, TLS cerificates and Public Key certificates interchangably. 

Three important security services provided by TLS are:
- **Encryption:** a process of encoding the message so that it can only be read by those with an authorized means of decoding the message
- **Authentication:** a process to verify the identity of a particular party in the message exchange
- **Integrity:** a process to detect whether a message has been interfered with or faked

Not all three services are used simultaneousy. However, using all three services together provides the most secure connection possible.


## TLS Encryption

### Symmetric Key Encryption

![symmetric key encryption][symmetric_key_encryption]

[symmetric_key_encryption]: https://da77jsbdz4r05.cloudfront.net/images/ls170/tls-encryption-symmetric.png

Both parties must agree on a *shared secret key* and keep a copy of it. The key is used for both encrypting and decrypting the message. 

The issue with this system is: how do sender and receiver exchange encryption keys in the first place? We need a mechanism to encrypt the key itself so it cannot be used if intercepted.

### Asymmetric Key Encryption

![asymmetric key encryption][asymmetric_key_encryption]

[asymmetric_key_encryption]:https://da77jsbdz4r05.cloudfront.net/images/ls170/tls-encryption-asymmetric.png

Asymmetric key encryption (a.k.a. public key encryption) uses a *pair of keys*:  
- Messages are encrypted with the *public key*
- Messages are decrypted with the *private key*

Encryption works in one direction: Bob can send Alice messages encrypted with her public key, and she can decrypt the message with her private key. However, Alice would use Bob's public key to encrypt her message, and he would decrypt using his private key. 

### The TLS Handshake

To securely send messages via HTTP we want both the request and response to be encrypted in a way that it can only be decrypted by the intended recipient. 

TLS uses a **combination of symmetric and asymmetric cryptography**. 
- The initial symmetric key exchange is conducted using asymmetric key encryption
- The rest of the message exchange is conducted via symmetric key encryption

**Def'n TLS Handshake.** The process by which the initial secure connection is set up. 
- TLS assumes TCP is being used at the Transport layer. 
- The TLS Handshake takes place after a TCP Handshake.

![TLS Handshake][tls_handshake]

[tls_handshake]: https://da77jsbdz4r05.cloudfront.net/images/ls170/tls-encryption-tls-handshake.png

Step by step the TLS handshake looks something like:
1. A `ClientHello` message is sent immediately after the TCP `ACK`. 
    - This message includes (not limited to) the max version of TLS protocol client supports and a list of Cipher Suites
2. Server responds with `ServerHello`, which includes:
    - setting the protocol version and Cipher Suite (among other things)
    - its certificate containing its public key
    - `ServerHelloDone` marker 
3. Client initiates key exchange process so both client and server can securely obtain a copy of the symmetric encryption key
    - Details vary depending on which key exchange algorithm was selected from the Cipher Suite

**Key points**: TLS Handshake is used to:
- agree which version of TLS to be used in establishing a secure connection
- agree on various algorithms that will be included in the cipher suite
- enable exchange of symmetric keys that will be used for message encyrption

*Note a consequence:* The TLS handhshake (with its complexity) can add up to two round-trips of latency to establish a connection between client and server prior to sending any application data. 

*Side note:* The protocol called Datagram Transport Layer Security (DTLS) is based in TLS and used with network connections which use UDP at the Transport layer. 

### Cipher Suites

**Cipher:** a cryptographic algorithm (set of steps for encryption, decryption, etc.)

TLS uses different ciphers for different aspects of establishing and maintaining a secure connection. There are various different algorithms for the performing the key exchange process, as well as for carrying out authentication, symmetric key encryption, and checking message integrity.

The algorithms for performing each of these tasks, when combined, form the **cipher suite**. The suite to be used is agreed as part of the TLS Handshake.


## TLS Authentication

With encryption, we are secure from a malicious third party intercepting messages. However, if the party (server) we connect with is malicious, then encryption doesn't help.

During the TLS Handshake `ServerHello` message, the server provides its certificate. In addition to providing the client with a public key, the certificate also provides *a means of identification* for the server.

### Authentication w/ TLS Certificate

The certificate (and Public Key it contains) help authenticate the server with a process like below:
- server sends certificate (which includes its public key)
- server creates a 'signature' in the form of some data encrypted with its private key
- signature transmitted in message along with original data from which signature was created
- client decrypts signature using server's public key and compares the decrypted data to the original version
- if two versions match, encrypted version could have only been created by a party holding the private key

This process lets us identify that the server that provided the certificate does, indeed, hold the associated private key and is the actual owner of the certificate.

But we still need another check to make sure that the certificate and key pairs aren't fake. 

### Certificate Authorities and Chain of Trust

Trustworthy sources of digital certificates are called **Certificate Authorities**. They:
- verify the party requesting the certificate is who they say they are
- digitally sign the certificate being isssued. This is often done by encrypting some data with the CA's own private key and using this encrypted data as a 'signature'. The unencrypted version is added to the certificate, and can be verified by using the public key to decrypt the signature and check for a match

**Chain of Trust**

There are different levels of certificate authorities. 
- 'Intermediate' CAs: any company or body authorised by a Root CA to issue certificates on its behalf
- 'Root' CAs: the most trustworthy, top-of-the-chain CA

Client software (ex: browsers) store a list of these authorities along with their Root Certificates. The browser can go up the chain to the Root Certificate to verify the legitimacy of the certificate. 


## TLS Integrity

TLS provides functionality to check the integrity of data transported via the protocol.

To understand how the functionality works, we need to first look at how the TLS protocol encapsulates data.

### TLS Encapsulation

OSI model: TLS as a Session Layer protocol (exists between the Application (HTTP) and Transport (TCP) layers). 

TLS encapsulates the data in the payload of its PDU, and attaches some meta data in the form of headers and trailers. *The field relavant to providing message integrity is the `MAC` field.* 

### Message Authentication Code (MAC)

The `MAC` field adds a layer of security by providing a means of checking that the message hasn't been altered/tampered with in transit. 

This field is different from the checksum fields in other PDUs, as they are more for error detection (testing if data was corrupted during transport). 

`MAC` fields are used for checking through a hashing algorithm that's something like:
- sender creates a *digest* of the data payload. 
    - *the digest:* a small amount of data from the actual data in the message created using a specific hashing algorithm combined with a pre-agreed hash value (determined during the handshake process)
- sender encrypts the data payload using the symmetric key, encapsulating it in a TLS record, and passes the record down to the transport layer
- receiver decrypts the payload using symmetric key, and then creates a digest of the payload using the same algorithm and hash value. If the two digests match, the message is confirmed to have kept its integrity.


## Summary

- HTTP Requests and Responses are transferred in plain text; as such they are essentially insecure.

- We can use the Transport Layer Security (TLS) Protocol to add security to HTTP communications.

- TLS encryption allows us to encode messages so that they can only be read by those with an authorized means of decoding the message

- TLS encryption uses a combination of Symmetric Key Encryption and Asymmetric Key Encryption. Encryption of the initial key exchange is performed asymmetrically, and subsequent communications are symmetrically encrypted.

- The TLS Handshake is the process by which a client and a server exchange encryption keys.

- The TLS Handshake must be performed before secure data exchange can begin; it involves several round-trips of latency and therefore has an impact on performance.

- A cipher suite is the agreed set of algorithms used by the client and server during the secure message exchange.

- TLS authentication is a means of verifying the identity of a participant in a message exchange.

- TLS Authentication is implemented through the use of Digital Certificates.

- Certificates are signed by a Certificate Authority, and work on the basis of a Chain of Trust which leads to one of a small group of highly trusted Root CAs.

- Certificates are exchanged during the TLS Handshake process.

- TLS Integrity provides a means of checking whether a message has been altered or interfered with in transit.

- TLS Integrity is implemented through the use of a Message Authentication Code (MAC).