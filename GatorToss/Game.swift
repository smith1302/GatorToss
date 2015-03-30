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
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var points:Int {
        get {
            if let points = defaults.stringForKey("points")?.toInt() {
                return points
            } else {
                return 0
            }
        }
        set (value) {
            defaults.setValue(value, forKey: "points")
            defaults.synchronize()
        }
    }
    var bounceMultiplier:[CGFloat]
    var bestDistance:Int {
        get {
            if let distance = defaults.stringForKey("distance")?.toInt() {
                return distance
            } else {
                return 0
            }
        }
        set (value) {
            defaults.setValue(value, forKey: "distance")
            defaults.synchronize()
        }
    }
    var round:Int {
        get {
            if let round = defaults.stringForKey("round")?.toInt() {
                return round
            } else {
                return 0
            }
        }
        set (value) {
            defaults.setValue(value, forKey: "round")
            defaults.synchronize()
        }
    }
    
    var nameToVar:[String:CGFloat]!
    
    var power:CGFloat {
        get {
            return nameToVar["Arm Strength"]!
        }
        set (value) {
            nameToVar["Arm Strength"] = value
            defaults.setValue(value, forKey: "Arm Strength")
            defaults.synchronize()
        }
    }
    var accuracy:CGFloat {
        get {
            return nameToVar["Accuracy"]!
        }
        set (value) {
            nameToVar["Accuracy"] = value
            defaults.setValue(value, forKey: "Accuracy")
            defaults.synchronize()
        }
    }
    var speed:CGFloat {
        get {
            return nameToVar["Speed"]!
        }
        set (value) {
            nameToVar["Speed"] = value
            defaults.setValue(value, forKey: "Speed")
            defaults.synchronize()
        }
    }
    var calmness:CGFloat {
        get {
            return nameToVar["Calmness"]!
        }
        set (value) {
            nameToVar["Calmness"] = value
            defaults.setValue(value, forKey: "Calmness")
            defaults.synchronize()
        }
    }
    
    init() {
        nameToVar = ["Arm Strength":1, "Calmness": 1, "Accuracy": 1 , "Speed": 1] // just set some defaults
        
        // Using key values of "nameToVar" get saved values and store
        for (key,value) in nameToVar {
            if let prop = defaults.stringForKey(key)?.toInt() {
                nameToVar[key] = CGFloat(prop)
            }
        }
        bounceMultiplier = [0.98,0.9,0.8,0.65,0.5]
    }
    
}