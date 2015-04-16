//
//  Particle.swift
//  GatorToss
//
//  Created by Eric Smith on 4/16/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import UIKit
import SpriteKit

class Particle: SKNode {
    
    let minR:UInt32 = 1
    let maxR:UInt32 = 9
    
    override init() {
        super.init()
        let radius:CGFloat = CGFloat(arc4random_uniform(maxR) + minR)
        let shape = SKShapeNode(circleOfRadius: radius)
        let alpha = CGFloat(arc4random_uniform(7)/10) + 0.1
        let darkness = CGFloat(arc4random_uniform(8)/10) + 0.1
        shape.fillColor = UIColor(white: darkness, alpha: alpha)
        shape.strokeColor = UIColor.clearColor()
        
        let rx = -1*CGFloat(arc4random_uniform(40)) + 3
        let ry = CGFloat(arc4random_uniform(30)) - 15
        shape.position = CGPointMake(rx, ry)
        self.addChild(shape)
        self.doFade()
    }
    
    func doFade() {
        let fadeOut = SKAction.fadeOutWithDuration(0.5)
        self.runAction(fadeOut)
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.removeFromParent()
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
