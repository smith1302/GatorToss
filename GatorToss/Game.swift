//
//  Tebow.swift
//  GatorToss
//
//  Created by Eric Smith on 2/18/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Game {
    
    var points:Int
    var bounceMultiplier:[CGFloat]
    var bestDistance:Int
    var round:Int
    
    var nameToVar:[String:CGFloat]!
    
    var power:CGFloat {
        get {
            return nameToVar["Arm Strength"]!
        }
        set (value) {
            nameToVar["Arm Strength"] = value
        }
    }
    var accuracy:CGFloat {
        get {
            return nameToVar["Accuracy"]!
        }
        set (value) {
            nameToVar["Accuracy"] = value
        }
    }
    var speed:CGFloat {
        get {
            return nameToVar["Speed"]!
        }
        set (value) {
            nameToVar["Speed"] = value
        }
    }
    var calmness:CGFloat {
        get {
            return nameToVar["Calmness"]!
        }
        set (value) {
            nameToVar["Calmness"] = value
        }
    }
    
    init() {
        bestDistance = 0
        points = 0
        round = 0
        nameToVar = ["Arm Strength":0, "Calmness": 0, "Accuracy": 0 , "Speed": 0]
        bounceMultiplier = [0.9,0.8,0.5]
        power = 1
        accuracy = 1
        speed = 3.5
        power = 1.0
        calmness = 1.0
    }
    
}