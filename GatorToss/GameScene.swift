//
//  GameScene.swift
//  GatorToss
//
//  Created by Eric Smith on 2/18/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import SpriteKit

let friction:CGFloat = 0.25

class GameScene: SKScene {

    var world:SKNode!
    var tebow:Tebow!
    var mascot1:Mascot!
    var river1:SKSpriteNode!
    //var mascot:SKSpriteNode!
    var ground:SKSpriteNode!
    var sprite:SKSpriteNode!
    var rotator:SKSpriteNode!
    let mascotSize:CGFloat = 15
    var groundWidth:CGFloat = 400
    var offsetX:CGFloat! = 0
    var offsetY:CGFloat = 0
    var runButton:UIButton!
    var throwButton:UIButton!
    var worldGoalPos:CGPoint!

    override func didMoveToView(view: SKView) {
        
        self.size = view.bounds.size
        
        self.backgroundColor = UIColor(red: 135/255.0, green: 187/255.0, blue: 222/255.0, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(0, -2)
        
        // World Scene (basically our camera)
        world = SKNode()
        world.position = CGPointMake(0, 0)
        self.addChild(world)
        worldGoalPos = world.position

        let tebowSprite = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(25, 55))
        world.addChild(tebowSprite)
        tebow = Tebow(sprite: tebowSprite)
        
        // Make Rotator
        rotator = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(20, 3))
        rotator.anchorPoint = CGPointMake(0, 0.5)
        tebowSprite.addChild(rotator)
        
        // Make Mascot
        let mascot = SKSpriteNode(color:UIColor.orangeColor(), size: CGSizeMake(mascotSize, mascotSize))
        mascot.anchorPoint = CGPointMake(0.5, 0.5)
        mascot.hidden = true
        mascot.xScale = 1
        mascot.yScale = 1
        //physics body is applied when thrown
        world.addChild(mascot)
        mascot1 = Mascot(sprite: mascot)
        
        // Make a river1
        river1 = SKSpriteNode(color:UIColor.blueColor(), size: CGSizeMake(self.frame.size.width*2, self.frame.size.height))
        river1.anchorPoint = CGPointMake(0.5, 0.5 - ((mascot.size.height*3/4)/river1.size.height))
        river1.position = CGPointMake(river1.size.width/2, -1*river1.size.height/3 - mascot.size.height)
        river1.xScale = 1
        river1.yScale = 1
        river1.alpha = 0.5
        world.addChild(river1)
        
        // Make ground
        ground = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(groundWidth, self.frame.size.height))
        ground.xScale = 1
        ground.yScale = 1
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody!.dynamic = false
        world.addChild(ground)
        
        //Make running button
        let runButtonSize:CGFloat = 70
        runButton = UIButton(frame: CGRectMake(25, self.view!.frame.size.height - runButtonSize - 25, runButtonSize, runButtonSize))
        runButton.layer.cornerRadius = runButtonSize/2
        runButton.backgroundColor = UIColor(hex: 0xFFBE63)
        runButton.addTarget(self, action: "runButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(runButton)
        
        //Make throwing button
        let throwButtonSize:CGFloat = 70
        throwButton = UIButton(frame: CGRectMake(self.view!.frame.size.width-throwButtonSize-25, self.view!.frame.size.height - throwButtonSize - 25, throwButtonSize, throwButtonSize))
        throwButton.layer.cornerRadius = throwButtonSize/2
        throwButton.backgroundColor = UIColor(hex: 0xFFBE63)
        throwButton.addTarget(self, action: "throwButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(throwButton)
        
        reset()
    }
    
    //when runButton is clicked
    func runButtonClicked() {
        tebow.sprite.physicsBody?.applyImpulse(CGVectorMake(tebow.moveSpeed, 0))
        rotator.removeActionForKey("rotateSequence")
        tebow.didMove = true
    }
    
    //when throwButton is clicked
    //need to release the mascot
    func throwButtonClicked(Button:UIButton){
        if !tebow.canThrow {
            return
        }
        rotator.removeActionForKey("rotateSequence")
        runButton.hidden = true
        Button.hidden = true
        tebow.didThrow = true
        // Throw mascot
        mascot1.applyPhysicsBody()
        mascot1.sprite.physicsBody?.applyImpulse(CGVectorMake(tebow.getXPower(rotator.zRotation), tebow.getYPower(rotator.zRotation)))
        let rotateAction:SKAction = SKAction.rotateByAngle(CGFloat(-1*M_PI_2), duration: 1)
        let rotateForever = SKAction.repeatActionForever(rotateAction)
        //mascot1.sprite.runAction(rotateForever)
        // Stop tebow from sliding
        tebow.sprite.physicsBody = nil
        self.centerOnNode(tebow.sprite)
        // Make the water a physics block
        river1.physicsBody = SKPhysicsBody(rectangleOfSize: river1.size)
        river1.physicsBody!.dynamic = false

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if tebow.didThrow {
            let river1Y = river1.position.y + river1.frame.height/2
            let mascotY = mascot1.sprite.position.y - mascot1.sprite.frame.height/2
            let distanceToBounce = abs(mascotY - river1Y)
            let mascotHeight = mascot1.sprite.frame.size.height
            
            if distanceToBounce < mascotHeight {
                mascot1.bounceFriction = game.bounceMultiplier[0]
                println("Perfect")
            } else if distanceToBounce < mascotHeight*3 {
                mascot1.bounceFriction = game.bounceMultiplier[1]
                println("Good")
            } else if distanceToBounce < mascotHeight*5 {
                mascot1.bounceFriction = game.bounceMultiplier[2]
                println("Poor")
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //Save landing speed to use when he bounces back up
        if let fallSpeed = mascot1.sprite.physicsBody?.velocity.dy { // Check for nil
            if fallSpeed < 0 { // check if falling downwards
                mascot1.fallSpeed = fallSpeed
            }
        }
        
        // If we have a bounce bonus and the user is going up, add additional speed.
        // We use the last known falling speed since if the user gets a bonus after the
        // mascot is bouncing up, the speed may have already decreased some
        if mascot1.bounceFriction > mascot1.bounceFrictionDefault {
            if mascot1.sprite.physicsBody?.velocity.dy > 0 {
                var newSpeed = mascot1.fallSpeed * mascot1.bounceFriction * -1
                mascot1.sprite.physicsBody!.velocity.dy = newSpeed
                mascot1.bounceFriction = mascot1.bounceFrictionDefault
            }
        }
        
        //moves the ground 1 position at a time to left
        let groundPos = self.convertPoint(ground.position, fromNode: world)
        if(groundPos.x < -groundWidth) {
            self.removeChildrenInArray([ground])
        }
       
        //moves river1 1 position at a time to left
        let river1Pos = self.convertPoint(river1.position, fromNode: world)
        if(river1Pos.x <= 0){
            river1.position.x += river1.frame.size.width/2
        }
        
        if !tebow.didThrow {
            mascot1.sprite.hidden = false
            mascot1.sprite.position.x = tebow.sprite.position.x + tebow.sprite.frame.width/2
            mascot1.sprite.position.y = tebow.sprite.position.y + tebow.sprite.frame.height/2 + mascot1.sprite.frame.height/2
            self.centerOnNode(tebow.sprite)
            // Tebow cant throw if he is past the ledge (must have atleast 1/4 of his body on)
            if tebow.sprite.position.x - tebow.sprite.size.width/4 > ground.position.x + ground.size.width/2 {
                tebow.canThrow = false
            }
        } else {
            self.centerOnNode(mascot1.sprite)
        }
        
        // Animate camera to position. Animating to prevent jerkiness
        var diffX = worldGoalPos.x - world.position.x
        var diffY = worldGoalPos.y - world.position.y
        world.position.x += diffX/3
        world.position.y += diffY/3
        
        // If our player fell off the stage reset
        if (tebow.sprite.position.y < river1.position.y + river1.size.height/2) && tebow.didMove {
            tebow.canThrow = false // incase
            reset()
        }
    }
    
    func reset() {
        world.position = CGPointMake(0, 0)
        worldGoalPos = world.position
        river1.position = CGPointMake(river1.size.width/2, -1*river1.size.height/4)
        ground.position = CGPointMake(ground.size.width/2, -1*ground.size.height/10)
        tebow.sprite.position = CGPointMake(50 + tebow.sprite.size.width/2, (ground.size.height/2 - ground.size.height/10) + tebow.sprite.size.height/2 + 10)
        // Cant use anchor point on physics body. This means the default anchor point is in the middle of tebow instead of the corners
        tebow.applyPhysicsBody()
        tebow.canThrow = true
        tebow.didThrow = false
        tebow.didMove = false
        
        mascot1.sprite.position = CGPointMake(mascotSize/2,mascotSize/2)
        mascot1.sprite.hidden = true
        runButton.hidden = false
        throwButton.hidden = false
        
        // Rotate animation
        rotator.position = CGPointMake(tebow.sprite.size.width/2, 0)
        let duration:Double = 0.6
        let degToRad:CGFloat = 0.0175
        let rotateUp = SKAction.rotateToAngle(80*degToRad, duration: duration)
        let rotateDown = SKAction.rotateToAngle(5*degToRad, duration: duration)
        let rotateSequence = SKAction.repeatActionForever(SKAction.sequence([rotateUp, rotateDown]))
        rotator.runAction(rotateSequence, withKey: "rotateSequence")
    }
    
    func sceneRelativePosition(node:SKSpriteNode) -> CGPoint {
        var nodePositionInScene = node.scene!.convertPoint(node.position, fromNode: node.scene!)
        return nodePositionInScene
    }
    
    func centerOnNode(node:SKSpriteNode) {
        var nodePositionInScene = sceneRelativePosition(node)
        let centerOffsetX = nodePositionInScene.x - node.scene!.size.width/2
        let centerOffsetY = nodePositionInScene.y - node.scene!.size.height/2
        if centerOffsetX < 0 { // Dont follow it if its left of center
            return
        }
        if centerOffsetY > self.frame.size.height*3/4 {
            worldGoalPos = CGPointMake(-1*centerOffsetX, worldGoalPos.y);
            return
        }
        worldGoalPos = CGPointMake(-1*centerOffsetX, -1*centerOffsetY - node.scene!.size.height/7);
    }
    
}

extension UIColor {

    convenience init(hex: Int) {

        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )

        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)

    }

}
