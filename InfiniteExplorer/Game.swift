//
//  Game.swift
//  InfiniteExplorer
//
//  Created by Ryan Galimova on 2017-12-27.
//  Copyright © 2017 Ryan Galimova. All rights reserved.
//
// The game class that will hold the current world, username and score + other info needed by the game

import UIKit

class Game: NSObject {
    // the current world that the user is located in
    var world: World!
    
    override init() {
        world = World()
    }
}
