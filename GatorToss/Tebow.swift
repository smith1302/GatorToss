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

    var sprite:SKSpriteNode
    var didThrow:Bool
    var power:CGFloat
    
    init(sprite:SKSpriteNode) {
        self.sprite = sprite
        self.didThrow = false
        self.power = 10
    }
    
    func getXPower(rad:CGFloat) -> CGFloat {
        let xRatio = cos(rad)
        return self.getVelocityBonus()*power*xRatio
    }
    
    func getYPower(rad:CGFloat) -> CGFloat {
        let yRatio = sin(rad)
        return self.getVelocityBonus()*power*yRatio
    }
    
    func getXVelocity() -> CGFloat? {
        return self.sprite.physicsBody?.velocity.dx
    }
    
    func getVelocityBonus() -> CGFloat {
        let cap:CGFloat = 500
        let capBonus:CGFloat = 9
        
        if let xVel = self.getXVelocity() {
            let ratio = xVel/cap
            var speedBonus = capBonus * ratio
            return (speedBonus < 1) ? 1 : speedBonus
        } else {
            return 1
        }
    }
    
}