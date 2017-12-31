//
//  Game.swift
//  InfiniteExplorer
//
//  Created by Ryan Galimova on 2017-12-27.
//  Copyright © 2017 Ryan Galimova. All rights reserved.
//

import UIKit

class Game: NSObject {
    var world: World!
    
    override init() {
        world = World()
    }
}
