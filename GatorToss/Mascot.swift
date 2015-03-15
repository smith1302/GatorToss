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
    
    var sprite:SKSpriteNode
    var mascotIdentityTracker: Int  //used to keep track of the position we are in within the array
    var mascotIdentities:[UIColor]! //used to keep track of all the different mascots
    //var bounceFrictionDefault:CGFloat
    //var fallSpeed:CGFloat // tracks the speed in which the mascot hits the water
    //var bounceFriction:CGFloat
    var defaultRestituion: CGFloat
    
    init(sprite:SKSpriteNode) {
        self.mascotIdentityTracker = 0
        self.mascotIdentities = [UIColor.redColor(), UIColor.purpleColor(), UIColor.brownColor(), UIColor.blueColor(), UIColor.blackColor()]
        self.sprite = sprite
        self.sprite.color = mascotIdentities[mascotIdentityTracker]
        self.defaultRestituion = 0.4
        //self.bounceFriction = bounceFrictionDefault
        //self.fallSpeed = 0
        
    }
    
    //returns the POSITION we are currently in regarding the mascotIdentities array
    func getMascotIdentityTracker() -> Int{
        return self.mascotIdentityTracker
    }

    
    //returns the current mascot being used
    func getMascot() -> UIColor{
        return self.sprite.color
    }
    
    //Changes the mascot according to the array. Changes the number keeping track in the array
    func setMascot(mascotIdentityTracker:Int){
        
        //if statement used to make sure we don't go out of bounds in the array.
        if(mascotIdentityTracker >= 0 && mascotIdentityTracker < 5){
            self.mascotIdentityTracker = mascotIdentityTracker
            self.sprite.color = mascotIdentities[mascotIdentityTracker]
        }
        else{
            println("OUT OF BOUNDS")
        }
    }
    
    func applyPhysicsBody() {
        self.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.size)
        self.sprite.physicsBody!.dynamic = true
        self.sprite.physicsBody!.allowsRotation = true
        self.sprite.physicsBody!.restitution = defaultRestituion //self.bounceFrictionDefault
    }
    
    //make a method that reads current points and updates the mascot accordingly
    
}