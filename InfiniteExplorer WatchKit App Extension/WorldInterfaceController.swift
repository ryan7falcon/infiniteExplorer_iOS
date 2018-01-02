//
//  ScoreInterfaceController.swift
//  InfiniteExplorer WatchKit App Extension
//
//  Created by Ryan Galimova on 2017-12-30.
//  Copyright © 2017 Ryan Galimova. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class WorldInterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        self.update()
    }
    
    // request data from the phone and accept the reply
    func update () {
        if(WCSession.default.isReachable){
            let message = ["getProgData":[:]]
            WCSession.default.sendMessage(message, replyHandler:
                {
                    (result) -> Void in
                    if result["progData"] != nil
                    {
                        let loadedData = result["progData"]
                        NSKeyedUnarchiver.setClass(World.self, forClassName: "World")
                        let loadedWorld = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? World
                        self.world = loadedWorld!
                        self.display()
                        
                    }
                    
            }
                , errorHandler: {
                    (error) -> Void in
                    print(error)
            }
                
            )
        }
    }
    
    // display world name, description and image
    func display() {
        self.lblName.setText(self.world.name)
        self.lblDesc.setText(self.world.desc)
        self.img.setImageNamed(self.world.picUrl)
    }
    
    // proceess the received data and reply with success message
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, AnyObject>()
        let loadedData = message["progData"]
        let loadedWorld = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? World
        
        self.world = loadedWorld!
        self.display()
        
        replyValues["status"] = "Data Received" as AnyObject?
        replyHandler(replyValues)
    }
    
    // world name label
    @IBOutlet var lblName : WKInterfaceLabel!
    // world name description
    @IBOutlet var lblDesc : WKInterfaceLabel!
    // a cat picture
    @IBOutlet var img : WKInterfaceImage!
    // world object - will be received from the phone
    var world : World = World()
    
    // activate session
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        self.update()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}

