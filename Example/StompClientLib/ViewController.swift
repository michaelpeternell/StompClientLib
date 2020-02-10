//
//  ViewController.swift
//  StompClientLib
//
//  Created by wrathchaos on 07/07/2017.
//  Copyright (c) 2017 wrathchaos. All rights reserved.
//

import UIKit
import StompClientLib

class ViewController: UIViewController, StompClientLibDelegate {
    
    var socketClient = StompClientLib()
    let topic = "/topic/greetings"
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socketClient.logger = StompClientLib.simplePrintLogger
        // Connect with socket
        registerSocket()
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        socketClient.sendMessage(message: "StompClientLib Foo", toDestination: "/app/hello", withHeaders: nil, withReceipt: nil)
    }
    func registerSocket(){
        url = URL(string: "ws://localhost:8080/hello/websocket")!
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url) , delegate: self)
    }
    
    func stompClientDidConnect(client: StompClientLib) {
        let topic = self.topic
        print("Socket is Connected : \(topic)")
        socketClient.subscribe(destination: topic)
        // Auto Disconnect after 3 sec
        socketClient.autoDisconnect(time: 3)
        // Reconnect after 4 sec
        socketClient.reconnect(request: NSURLRequest(url: url) , delegate: self, time: 4.0)
    }
    
    func stompClientDidDisconnect(client: StompClientLib) {
        print("Socket is Disconnected")
    }
    
    func stompClient(client: StompClientLib, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTIONATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
    }
    
    func stompClientJSONBody(client: StompClientLib, didReceiveMessageWithJSONBody jsonBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("DESTIONATION : \(destination)")
        print("String JSON BODY : \(String(describing: jsonBody))")
    }
    
    func serverDidSendReceipt(client: StompClientLib, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("Error : \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server Ping")
    }
    
}
