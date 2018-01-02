//
//  Obstacle.swift
//  InfiniteExplorer
//
//  Created by Ryan Galimova on 2017-12-27.
//  Copyright © 2017 Ryan Galimova. All rights reserved.
//
// Obstacle class for the game

import UIKit

class Obstacle: NSObject {
    // obstacle id
    var id: Int!
    // obstacle name
    var name: String!
    // the sprite
    var sprite: String!
    
    // possible names
    let names = ["cactus 1", "cactus 2"]
    // possible pictures
    let urls = ["Assets/Elements/Cactus1.png", "Assets/Elements/Cactus2.png"]
    
    override init() {
        super.init()
        self.setup(id: 1)
    }
    
    //init by id
    required init?(id: Int){
        super.init()
        if (id > 2){
            setup(id: 1)
        }
        setup(id: id)
        
    }
    
    // assign values by id
    func setup(id: Int) {
        self.name = names[id - 1]
        self.sprite = urls[id - 1]
        self.id = id
    }
}
