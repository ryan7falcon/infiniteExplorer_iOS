//
//  HighScoreApiClass.swift
//  InfiniteExplorer
//
//  Created by Xcode User on 2017-12-28.
//  Author Thomas Irwin
// This Class is used to support and manage all the API Calls to the Remote Server

import UIKit

class HighScoreApiClass: NSObject {

    //Dictinoary to store world 1 scores
    var World1Scores : [NSDictionary]?
    //Dictionary to hold world 2 scores
    var World2Scores : [NSDictionary]?
    //Url for the first set of scores
    let myUrl = "https://mysterious-coast-28480.herokuapp.com/api/v1/HighScore/GetHighScore/1" as String
    //Url for the second of the sets scores
    let myUrl2 = "https://mysterious-coast-28480.herokuapp.com/api/v1/HighScore/GetHighScore/2" as String
    //API Url for the Post creation
    let CreateSocreUrl = "https://mysterious-coast-28480.herokuapp.com/api/v1/HighScore/CreateHighScore/" as String
    //Sets Error codes for different Json errors
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    
    //This method connects with the remote database and stores the set of scores return into the apporiate nsdictionary
    func GetWorld1Scores() {
        
        guard let endpoint = URL(string: myUrl) else {
            print("Error creating endpoint")
            return
        }
       //creates the request
        let request = URLRequest(url: endpoint)
        //Creates a session to get the data
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
    //This method gets the data to store in the nsdictionary for the second set of scores
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
    
    //Connect with the remote database and performs a Post method to save a new Score to the database
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
        //Preforms the Post Task
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

