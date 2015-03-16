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
    var cloud1:SKSpriteNode!
    var cloud2:SKSpriteNode!
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
    var resetButton:UIButton!
    var worldGoalPos:CGPoint!
    var bounceLabel:UILabel?
    let bounceLabelTimer:Double = 1.5
    //var canClick:Bool

    override func didMoveToView(view: SKView) {
        
        self.size = view.bounds.size
        
        self.backgroundColor = UIColor(red: 135/255.0, green: 187/255.0, blue: 222/255.0, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(0, -2)
        
        // World Scene (basically our camera)
        world = SKNode()
        self.addChild(world)
        
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

        //make reset button
        let resetButtonSize:CGFloat = 70
        resetButton = UIButton(frame: CGRectMake(self.view!.frame.size.width-resetButtonSize-25, self.view!.frame.size.height - resetButtonSize - 225, resetButtonSize, resetButtonSize))
        resetButton.layer.cornerRadius = throwButtonSize/2
        resetButton.backgroundColor = UIColor(hex:0xFFBE63)
        resetButton.addTarget(self, action: "resetButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(resetButton)
        
        
        reset()
    }
    
    //when resetButton is clicked
    func resetButtonClicked() {
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
        //let rotateAction:SKAction = SKAction.rotateByAngle(CGFloat(-1*M_PI_2), duration: 1)
        //let rotateForever = SKAction.repeatActionForever(rotateAction)
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
        if (tebow.didThrow) && (mascot1.bounceFriction == mascot1.bounceFrictionDefault) {
            let river1Y = river1.position.y + river1.frame.height/2
            let mascotY = mascot1.sprite.position.y - mascot1.sprite.frame.height/2
            let distanceToBounce = abs(mascotY - river1Y)
            let mascotHeight = mascot1.sprite.frame.size.height
            
            if distanceToBounce < mascotHeight {
                mascot1.bounceFriction = game.bounceMultiplier[0]
                println("Perfect")
                addBounceLabel("PERFECT!")
            } else if distanceToBounce < mascotHeight*3 {
                mascot1.bounceFriction = game.bounceMultiplier[1]
                println("Good")
                addBounceLabel("Good")
            } else if distanceToBounce < mascotHeight*5 {
                mascot1.bounceFriction = game.bounceMultiplier[2]
                println("Poor")
                addBounceLabel("Poor")
            }
        }
    }

    func addBounceLabel(textForLabel: String){
        bounceLabel?.text = textForLabel
        bounceLabel!.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 100, 25)
        self.view?.addSubview(bounceLabel!)
        NSTimer.scheduledTimerWithTimeInterval(bounceLabelTimer, target: self, selector: "resetText", userInfo: nil, repeats: false)
    }
    
    func resetText() {
        bounceLabel?.removeFromSuperview()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        //Save landing speed to use when he bounces back up
        if let fallSpeed = mascot1.sprite.physicsBody?.velocity.dy { // Check for nil
            if fallSpeed < 0 { // check if falling downwards
                mascot1.fallSpeed = fallSpeed
            }
        }
        
        if let mascotYVel = mascot1.sprite.physicsBody?.velocity.dy {
            if mascot1.oldDy < 0 && mascotYVel >= 0 {
                mascot1.sprite.physicsBody?.velocity.dy = (mascot1.fallSpeed * -1)*mascot1.bounceFrictionDefault
            }
            mascot1.oldDy = mascotYVel
        }
        
        
        // If we have a bounce bonus and the user is going up, add additional speed.
        // We use the last known falling speed since if the user gets a bonus after the
        // mascot is bouncing up, the speed may have already decreased some
        if mascot1.bounceFriction > mascot1.bounceFrictionDefault {
            if mascot1.sprite.physicsBody?.velocity.dy > 0 {
                var newSpeed = mascot1.fallSpeed * mascot1.bounceFriction * -1
                mascot1.sprite.physicsBody!.velocity.dy = newSpeed
                mascot1.sprite.physicsBody?.applyImpulse(CGVectorMake(mascot1.bounceFriction, 0))
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
        
        //moves clouds 1 poisiton at a time to left
        let cloud1Position = self.convertPoint(cloud1.position, fromNode: world)
        if(cloud1Position.x <= 0){
            //cloud1.position.x += cloud1.frame.size.width/2
            cloud1.position.x += self.frame.size.width
            
        }
        
        //moves clouds 1 poisiton at a time to left
        let cloud2Position = self.convertPoint(cloud2.position, fromNode: world)
        if(cloud2Position.x <= 0){
            //cloud2.position.x += cloud2.frame.size.width/2
            cloud2.position.x += self.frame.size.width
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
        
        bounceLabel = UILabel()
        resetText()
        

        world.removeAllActions()
        world.removeAllChildren()
        self.removeAllActions()
        
        world.position = CGPointMake(0, 0)
        worldGoalPos = world.position

        //Make clouds
        cloud1 = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(self.frame.size.width/4,self.frame.size.height/4))
        cloud1.anchorPoint = CGPointMake(0.5, 0.5)
        cloud1.xScale = 1
        cloud1.yScale = 1
        cloud1.position = CGPointMake(250, 250)
        
        cloud2 = SKSpriteNode(color:UIColor.whiteColor(), size: CGSizeMake(self.frame.size.width/4,self.frame.size.height/4))
        cloud2.anchorPoint = CGPointMake(0.5, 0.5)
        cloud2.xScale = 1
        cloud2.yScale = 1
        cloud2.position = CGPointMake(450, 250)
        
        // Make Mascot
        let mascot = SKSpriteNode(color:UIColor.orangeColor(), size: CGSizeMake(mascotSize, mascotSize))
        mascot.anchorPoint = CGPointMake(0.5, 0.5)
        mascot.position = CGPointMake(mascotSize/2,mascotSize/2)
        mascot.physicsBody = nil
        mascot.xScale = 1
        mascot.yScale = 1
        mascot1 = Mascot(sprite: mascot)
        
        // Make a river1
        river1 = SKSpriteNode(color:UIColor.blueColor(), size: CGSizeMake(self.frame.size.width*2, 150))
        river1.position = CGPointMake(river1.size.width/2, 0 - mascot.size.height)
        river1.anchorPoint = CGPointMake(0.5, 0.5 - ((mascot.size.height*3/4)/river1.size.height))
        river1.xScale = 1
        river1.yScale = 1
        river1.alpha = 0.5
        
        // Make ground
        ground = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(groundWidth, self.frame.size.height))
        ground.position = CGPointMake(ground.size.width/2, -1*ground.size.height/10)
        ground.xScale = 1
        ground.yScale = 1
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody!.dynamic = false
        
        let tebowSprite = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(25, 55))
        tebowSprite.position = CGPointMake(50 + tebowSprite.size.width/2, (ground.size.height/2 - ground.size.height/10) + tebowSprite.size.height/2 + 10)
        tebow = Tebow(sprite: tebowSprite)
        tebow.applyPhysicsBody()
        
        // Make Rotator
        rotator = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(20, 3))
        rotator.anchorPoint = CGPointMake(0, 0.5)
        // Rotate animation
        rotator.position = CGPointMake(tebow.sprite.size.width/2, 0)
        let duration:Double = 0.6
        let degToRad:CGFloat = 0.0175
        let rotateUp = SKAction.rotateToAngle(80*degToRad, duration: duration)
        let rotateDown = SKAction.rotateToAngle(5*degToRad, duration: duration)
        let rotateSequence = SKAction.repeatActionForever(SKAction.sequence([rotateUp, rotateDown]))
        rotator.runAction(rotateSequence, withKey: "rotateSequence")
        
        runButton.hidden = false
        throwButton.hidden = false
        resetButton.hidden = false
        
        world.addChild(tebowSprite)
        tebowSprite.addChild(rotator)
        world.addChild(cloud1)
        world.addChild(cloud2)
        world.addChild(mascot)
        world.addChild(river1)
        world.addChild(ground)
    }
    
    func sceneRelativePosition(node:SKSpriteNode) -> CGPoint {
        var nodePositionInScene = node.scene!.convertPoint(node.position, fromNode: node.scene!)
        return nodePositionInScene
    }
    
    func centerOnNode(nodeOpt:SKSpriteNode?) {
        if nodeOpt?.scene == nil{
            return
        }
        let node = nodeOpt!
        var nodePositionInScene = sceneRelativePosition(node)
        let centerOffsetX = nodePositionInScene.x - node.scene!.size.width/2
        let centerOffsetY = nodePositionInScene.y - node.scene!.size.height/2
        if centerOffsetX < 0 { // Dont follow it if its left of center
            return
        }
        worldGoalPos = CGPointMake(-1*centerOffsetX, -1*centerOffsetY + node.scene!.size.height/4);
        // Make sure the camera sticks to the bottom
        if worldGoalPos.y > 0 {
            worldGoalPos.y = 0;
        }
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
