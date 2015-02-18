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

class Tebow {
    
    var x:CGFloat
    var y:CGFloat
    var xVel:CGFloat
    var sprite:SKSpriteNode
    
    init(x:CGFloat, y:CGFloat, sprite:SKSpriteNode) {
        self.x = x
        self.y = y
        xVel = 0
        self.sprite = sprite
    }
    
}