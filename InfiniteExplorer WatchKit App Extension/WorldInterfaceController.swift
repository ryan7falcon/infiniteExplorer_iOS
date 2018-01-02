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
    
    func display() {
        self.lblName.setText(self.world.name)
        self.lblDesc.setText(self.world.desc)
        self.img.setImageNamed(self.world.picUrl)
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, AnyObject>()
        let loadedData = message["progData"]
        let loadedWorld = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? World
        
        self.world = loadedWorld!
        self.display()
        
        replyValues["status"] = "Program Received" as AnyObject?
        replyHandler(replyValues)
    }
    
    @IBOutlet var lblName : WKInterfaceLabel!
    @IBOutlet var lblDesc : WKInterfaceLabel!
    @IBOutlet var img : WKInterfaceImage!
    var world : World = World()
    
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

