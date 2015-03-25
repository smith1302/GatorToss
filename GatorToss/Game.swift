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
    
    var power:CGFloat
    var accuracy:CGFloat
    var speed:CGFloat
    
    init() {
        bestDistance = 0
        points = 0
        bounceMultiplier = [0.9,0.8,0.5]
        power = 1
        accuracy = 1
        speed = 3.5
        power = 1.0
    }
    
}