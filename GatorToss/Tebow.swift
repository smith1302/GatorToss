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
    var moveSpeed:CGFloat
    var power:CGFloat
    var canThrow:Bool
    var didMove:Bool
    
    init(sprite:SKSpriteNode) {
        self.sprite = sprite
        self.didThrow = false
        self.canThrow = true
        self.didMove = false
        self.moveSpeed = 3.5
        self.power = 2
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
        let cap:CGFloat = 400
        let capBonus:CGFloat = 5
        
        if let xVel = self.getXVelocity() {
            let ratio = xVel/cap
            var speedBonus = capBonus * ratio
            return (speedBonus < 1) ? 1 : speedBonus
        } else {
            return 1
        }
    }
    
    func applyPhysicsBody() {
        self.sprite.physicsBody = SKPhysicsBody(circleOfRadius: self.sprite.frame.size.height/2)
        self.sprite.physicsBody!.dynamic = true
        self.sprite.physicsBody?.allowsRotation = false
        self.sprite.physicsBody?.friction = 0.5
    }
    
}