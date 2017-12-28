//
//  World.swift
//  InfiniteExplorer
//
//  Created by Galimova Galina on 2017-12-27.
//  Copyright © 2017 Ryan Falcon. All rights reserved.
//

import UIKit

class World: NSObject {
    var id: Int!
    var name: String!
    var desc: String!
    var picUrl: String!
    
    let names = ["World 1", "World 2"]
    let descriptions = ["In the box", "Out of the box"]
    let urls = ["cats.jpg", "cat2.jpeg"]
    
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
        self.desc = descriptions[id - 1]
        self.picUrl = urls[id - 1]
        self.id = id
    }
    
}
