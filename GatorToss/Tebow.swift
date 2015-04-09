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
    
    enum State {
        case Standing
        case Moving
        case Throwing
    }

    var sprite:SKSpriteNode
    var didThrow:Bool
    var canThrow:Bool
    var didMove:Bool
    var state:State
    let runTextures:[SKTexture]
    let throwTextures:[SKTexture]
    let maxRunVelocity:CGFloat = 800
    let maxRunFPS:CGFloat = 0.04
    
    init(sprite:SKSpriteNode) {
        self.sprite = sprite
        self.didThrow = false
        self.canThrow = true
        self.didMove = false
        self.state = State.Standing
        runTextures = PNGAnimation.getTextures("tebow_run", startFrame: 1, totalFrame: 39)
        throwTextures = PNGAnimation.getTextures("tebow_throw", startFrame: 1, totalFrame: 8)
    }
    
    func isMoving() -> Bool {
        return self.state == State.Moving
    }
    
    func isStanding() -> Bool {
        return self.state == State.Standing
    }
    
    func isThrowing() -> Bool {
        return self.state == State.Throwing
    }
    
    func setStanding() {
        if !isStanding() {
            self.state = State.Standing
            sprite.removeAllActions()
            sprite.texture = SKTexture(imageNamed: "tebow_stand.png")
        }
    }
    
    func setMoving() {
        if !isMoving() {
            self.state = State.Moving
            sprite.removeAllActions()
            if let pb = self.sprite.physicsBody {
                let time:Double = Double(maxRunFPS - (maxRunFPS/maxRunVelocity)*pb.velocity.dx) - 0.01
                self.doMoveAnimation(time <= 0 ? 0 : time)
            }
        }
    }
    
    func setThrowing() {
        if !isThrowing() {
            self.state = State.Throwing
            sprite.removeAllActions()
            //let throwAnimation = SKAction.animateWithTextures(throwTextures, timePerFrame: 0.03)
            //sprite.runAction(throwAnimation)
            sprite.texture = SKTexture(imageNamed: "tebow_throw0008.png")
            sprite.size.width = 114*0.6
        }
    }
    
    func doMoveAnimation(time:Double) {
        if !isMoving() {
            return
        }
        println(time)
        let runAnimation = SKAction.animateWithTextures(runTextures, timePerFrame: time)
        sprite.runAction(runAnimation, completion: {
            if let pb = self.sprite.physicsBody {
                let time:Double = Double(self.maxRunFPS - (self.maxRunFPS/self.maxRunVelocity)*pb.velocity.dx) - 0.01
                self.doMoveAnimation(time <= 0 ? 0 : time)
            }
        })
    }
    
    func getXPower(rad:CGFloat) -> CGFloat {
        let xRatio = cos(rad)
        return self.getVelocityBonus()*(2*log10(game.power) + 2)*xRatio
    }
    
    func getYPower(rad:CGFloat) -> CGFloat {
        let yRatio = sin(rad)
        return self.getVelocityBonus()*(2*log10(game.power) + 2) * yRatio
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