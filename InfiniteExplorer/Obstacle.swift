//
//  Obstacle.swift
//  InfiniteExplorer
//
//  Created by Galimova Galina on 2017-12-27.
//  Copyright © 2017 Ryan Falcon. All rights reserved.
//

import UIKit

class Obstacle: NSObject {
    var id: Int!
    var name: String!
    var sprite: String!
    
    let names = ["cactus 1", "cactus 2"]
    let urls = ["Assets/Elements/Cactus1.png", "Assets/Elements/Cactus2.png"]
    
    override init() {
        super.init()
        self.setup(id: 1)
    }
    
    required init?(id: Int){
        super.init()
        if (id > 2){
            setup(id: 1)
        }
        setup(id: id)
        
    }
    
    func setup(id: Int) {
        self.name = names[id - 1]
        self.sprite = urls[id - 1]
        self.id = id
    }
}
