//
//  HighScoreApiClass.swift
//  InfiniteExplorer
//
//  Created by Xcode User on 2017-12-28.
//  Copyright © 2017 Ryan Falcon. All rights reserved.
//

import UIKit

class HighScoreApiClass: NSObject {

    
    var World1Scores : [NSDictionary]?
    var World2Scores : [NSDictionary]?
    let myUrl = "https://mysterious-coast-28480.herokuapp.com/api/v1/HighScore/GetHighScore/1" as String
    let myUrl2 = "https://mysterious-coast-28480.herokuapp.com/api/v1/HighScore/GetHighScore/2" as String
    let CreateSocreUrl = "https://mysterious-coast-28480.herokuapp.com/api/v1/HighScore/CreateHighScore/" as String
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    func GetWorld1Scores() {
        
        guard let endpoint = URL(string: myUrl) else {
            print("Error creating endpoint")
            return
        }
       
        let request = URLRequest(url: endpoint)
  
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
          
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
        
                guard let data = data else {
                    throw JSONError.NoData
                }
                
           
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                self.World1Scores = json
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    
    }
    
    func GetWorld2Scores() {
        
  
        
        guard let endpoint2 = URL(string: myUrl2) else {
            print("Error creating endpoint")
            return
        }
 
        let request2 = URLRequest(url: endpoint2)
   
        URLSession.shared.dataTask(with: request2) { (data, response, error) in
            do {
           
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
              
                guard let data = data else {
                    throw JSONError.NoData
                }
                
    
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary] else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                self.World2Scores = json
                
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
        
    }
    
    
    func PostScore( name: String ,score : Int, world: Int){
        
        let json: [String: Any] = ["name": name,
                                   "score": score, "world": world]
        
        
        // create post endpoint
        guard let endpoint3 = URL(string: CreateSocreUrl) else {
            print("Error creating endpoint")
            return
        }
        //creates the Post request
        var request = URLRequest(url: endpoint3)
        request.httpMethod = "POST"
        
        // insert json data to the request
        do{
        request.httpBody =  try JSONSerialization.data(withJSONObject: json)
        }
        catch let error{
            
            print(error)
        }
        //Adds Header Fields
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //Does this shit right
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
               
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
        
        
    }
}

