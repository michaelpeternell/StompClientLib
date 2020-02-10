# StompClientLib

<p align="center">
<img width="200" height="200" src="Screenshots/socket.png">
</p>

<p align="center">
License: MIT, Platform: iOS, Carthage: compatible
</p>

<p align="center">
Language: Swift 5
</p>

## Introduction

If you are wondering "what is STOMP??" - see the [Apache ActiveMQ website](http://activemq.apache.org) for an introduction to message brokers, MQTT, Websockets and STOMP.

StompClientLib is a STOMP client in Swift. It uses Facebook's [SocketRocket](https://github.com/facebook/SocketRocket) as a websocket dependency. SocketRocket is written in Objective-C but StompClientLib's STOMP part is written in Swift and its usage is Swift. You can use this library in your Swift 5+ projects.

This is a fork from [StompClientLib](https://github.com/WrathChaos/StompClientLib), forked in February 6th 2020 by michaelpeternell. StompClientLib is a fork from [AKStompClient](https://github.com/alibasta/AKStompClient).

### Changes in this fork

- Carthage works now properly (I added a Cartfile that specifies dependencies)
- Proper configurable logging instead of just printing to the console.
- Added documentation about how to login with username and password.

## Example

To run the example project, clone the repo and set a development team for code signing (or run in the simulator). (Node by michaelpeternell: I didn't manage to make the example actually work, but I could compile it and run it.)

## Requirements

- iOS 8.0+
- XCode 11
- Swift 5

## Installation

StompClientLib is available through [Carthage](https://github.com/Carthage/Carthage).

#### Carthage

Add the following line to your Cartfile:

```ruby
github "michaelpeternell/StompClientLib" ~> 1.4
```

## Usage

```swift
import StompClientLib
```

Once imported, you can open a connection to your WebSocket server.

```swift
var socketClient = StompClientLib()
let url = NSURL(string: "wss://your-url.example.com:1337")!
socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: self, connectionHeaders: ["login": "kermit", "passcode": "Miss Piggy"])
```

You may provide username and password by specifying the `connectionHeaders` "login" and "passcode". If you don't need authentication, just omit that parameter. You should use "ws" or "wss" as a protocol.

After you are connected, StompClientLib will call some delegate methods, which you will need to implement.

# StompClientLibDelegate

## stompClientDidConnect

```swift
func stompClientDidConnect(client: StompClientLib!) {
    print("Socket is connected")
    // Stomp subscribe will be here!
    socketClient.subscribe(destination: topic)
    // Note : topic needs to be a String object
}
```

## stompClientDidDisconnect

```swift
func stompClientDidDisconnect(client: StompClientLib!) {
    print("Socket is Disconnected")
}
```

## didReceiveMessageWithJSONBody ( Message Received via STOMP )

Your json message will be converted to JSON Body as AnyObject and you will receive your message in this function

```swift
func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
    print("Destination : \(destination)")
    print("JSON Body : \(String(describing: jsonBody))")
    print("String Body : \(stringBody ?? "nil")")
}
```

## didReceiveMessageWithJSONBody ( Message Received via STOMP as String )

Your json message will be converted to JSON Body as AnyObject and you will receive your message in this function

```swift
func stompClientJSONBody(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
    print("DESTIONATION : \(destination)")
    print("String JSON BODY : \(String(describing: jsonBody))")
}
```

## serverDidSendReceipt

If you will use STOMP for in-app purchase, you might need to use this function to get receipt

```swift
func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
    print("Receipt : \(receiptId)")
}
```

## serverDidSendError

Your error message will be received in this function

```swift
func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
  print("Error Send : \(String(describing: message))")
}
```

## serverDidSendPing

If you need to control your server's ping, here is your part

```swift
func serverDidSendPing() {
    print("Server ping")
}
```

## How to subscribe and unsubscribe

There are functions for subscribing and unsubscribing.
Note : You should handle your subscribe and unsubscibe methods !
Suggestion : Subscribe to your topic in "stompClientDidConnect" function and unsubcribe to your topic in stompClientWillDisconnect method.

## Subscribe

```swift
let topic = "/topic/FOO.BAR.1337"
socketClient.subscribe(destination: topic)
```

## Unsubscribe

```swift
socketClient.unsubscribe(destination: topic)
```

Important: You have to send your destination for both subscribe or unsubscribe!

## Unsubsribe with header

```swift
let destination = "/topic/your_topic"
let ack = destination
let id = destination
let header = ["destination": destination, "ack": ack, "id": id]

// subscribe
socketClient?.subscribeWithHeader(destination: destination, withHeader: header)

// unsubscribe
socketClient?.unsubscribe(destination: subsId)
```

## Auto Reconnect with a given time

You can use this feature if you need to auto reconnect with a spesific time or it will just try to reconnect every second.

```swift
// Reconnect after 4 sec
socketClient.reconnect(request: NSURLRequest(url: url as URL) , delegate: self as StompClientLibDelegate, time: 4.0)
```

## Auto Disconnect with a given time

```swift
// Auto Disconnect after 3 sec
socketClient.autoDisconnect(time: 3)
```

# Change Log

## [1.4.1](https://github.com/michaelpeternell/StompClientLib/tree/1.4.1) (2020-02-10)

Delegate protocol `StompClientLibDelegate` now uses `client: StompClientLib` instead of `client: StompClientLib!` in its signatures.

## [1.4.0](https://github.com/michaelpeternell/StompClientLib/tree/1.4.0) (2020-02-06)

First version after I (michaelpeternell) forked the library.

- Improve documentation
- Better carthage support
- Better logging

## Previous versions

See versions 1.3.6 and below at https://github.com/WrathChaos/StompClientLib
