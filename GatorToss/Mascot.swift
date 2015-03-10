//
//  Tebow.swift
//  GatorToss
//
//  Created by NG38 and Eric Smith on 2/18/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Mascot {
    
    var x:CGFloat
    var y:CGFloat
    var mascotIdentity:UIColor
    var sprite:SKSpriteNode
    
    init(x:CGFloat, y:CGFloat, mascotIdentity: UIColor, sprite:SKSpriteNode) {
        self.x = x
        self.y = y
        self.mascotIdentity = mascotIdentity
        self.sprite = sprite
    }
    
    
}