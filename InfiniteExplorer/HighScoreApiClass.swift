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
    
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    // Step 5 - Create method below to do JSON parsing
    func GetWorld1Scores() {
        
        // step 5a - create URL object
        guard let endpoint = URL(string: myUrl) else {
            print("Error creating endpoint")
            return
        }
       
        // step 5b - create URL request object
        let request = URLRequest(url: endpoint)
        // step 5c - create asynchronous request using dataTask
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                // step 5d - retrieve JSON objects, convert to string and print to verify data received.
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                // step 5e - check for empty data
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                // step 5f - convert json into a dictionary
                // catch errors, then move on to Table View Controller
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
        
        // step 5a - create URL object
        
        guard let endpoint2 = URL(string: myUrl2) else {
            print("Error creating endpoint")
            return
        }
        // step 5b - create URL request object
        let request2 = URLRequest(url: endpoint2)
        // step 5c - create asynchronous request using dataTask
        URLSession.shared.dataTask(with: request2) { (data, response, error) in
            do {
                // step 5d - retrieve JSON objects, convert to string and print to verify data received.
                let datastring = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(datastring!)
                
                // step 5e - check for empty data
                guard let data = data else {
                    throw JSONError.NoData
                }
                
                // step 5f - convert json into a dictionary
                // catch errors, then move on to Table View Controller
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
}

