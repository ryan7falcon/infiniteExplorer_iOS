//
//  World.swift
//  InfiniteExplorer
//
//  Created by Ryan Galimova on 2017-12-27.
//  Copyright © 2017 Ryan Galimova. All rights reserved.
//

import UIKit

class World: NSObject, NSCoding {
    var id: Int!
    var name: String!
    var desc: String!
    var picUrl: String!
    
    let names = ["World 1", "World 2"]
    let descriptions = ["In the box", "Out of the box"]
    let urls = ["cats", "cat2"]
    
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
    
    func initWithData ( name: String,
                        desc: String,
                        picUrl: String,
                        id: Int)
    {
        self.name = name
        self.id = id
        self.desc = desc
        self.picUrl = picUrl
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String,
            let desc = aDecoder.decodeObject(forKey: "desc") as? String,
            let picUrl = aDecoder.decodeObject(forKey: "picUrl") as? String,
            let id = aDecoder.decodeObject(forKey: "id") as? Int
            else {
                return nil
        }
        self.init()
        self.initWithData(name: name, desc: desc, picUrl: picUrl, id: id)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.desc, forKey: "desc")
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.picUrl, forKey: "picUrl")
    }
    
}
