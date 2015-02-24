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

    var tebow:Tebow!
    var river1:SKSpriteNode!
    var river2:SKSpriteNode!
    var ground:SKSpriteNode!
    var sprite:SKSpriteNode!
    var groundWidth:CGFloat = 600
    var offsetX:CGFloat! = 0
    var offsetY:CGFloat = 0
    var runButton:UIButton!

    override func didMoveToView(view: SKView) {
        
        self.size = view.bounds.size
        
        self.backgroundColor = UIColor(red: 135/255.0, green: 187/255.0, blue: 222/255.0, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(0, -3)
        
        //Make a river1

        river1 = SKSpriteNode(color:UIColor.blueColor(), size: CGSizeMake(self.frame.size.width+7, self.frame.size.height/2.5-25))
        river1.anchorPoint = CGPointMake(0,0)
        river1.position = CGPointMake(0, 0)
        river1.xScale = 1
        river1.yScale = 1
        self.addChild(river1)
        
        //Make a river2
        river2 = SKSpriteNode(color:UIColor(hex: 0x2EB6DB), size: CGSizeMake(self.frame.size.width+7, self.frame.size.height/2.5-25))
        river2.anchorPoint = CGPointMake(0,0)
        river2.position = CGPointMake(frame.size.width-1, 0)
        river2.xScale = 1
        river2.yScale = 1
        self.addChild(river2)

        // Make ground
        ground = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(groundWidth, self.frame.size.height/2.5))
        //ground.anchorPoint = CGPointMake(0, 0)
        ground.position = CGPointMake(ground.size.width/2, ground.size.height/2)
        ground.xScale = 1
        ground.yScale = 1
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody!.dynamic = false
        self.addChild(ground)
        
        //let tebowSprite = SKSpriteNode(imageNamed:"Tebow")
        //tebowSprite.anchorPoint = CGPointMake(0, 0)
        //tebowSprite.xScale = -0.2
        //tebowSprite.yScale = 0.2
        let tebowSprite = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(35, 70))
        tebowSprite.position = CGPointMake(50 + tebowSprite.size.width/2, ground.frame.origin.y + ground.size.height + tebowSprite.size.height/2 + 10)
        tebowSprite.physicsBody = SKPhysicsBody(circleOfRadius: tebowSprite.frame.size.height/2)
        tebowSprite.physicsBody!.dynamic = true
        tebowSprite.physicsBody?.allowsRotation = false
        tebowSprite.physicsBody?.friction = 0.5
        self.addChild(tebowSprite)
        tebow = Tebow(x: tebowSprite.frame.size.width + 50, y: self.frame.size.height/2.5 - 20, sprite: tebowSprite)
        
        // Make Rotator
        let rotator = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(40, 5))
        rotator.anchorPoint = CGPointMake(0, 0.5)
        tebowSprite.addChild(rotator)
        // Rotate animation
        rotator.position = CGPointMake(tebowSprite.size.width/2, 0)
        let duration:Double = 0.6
        let degToRad:CGFloat = 0.0175
        let rotateUp = SKAction.rotateToAngle(80*degToRad, duration: duration)
        let rotateDown = SKAction.rotateToAngle(5*degToRad, duration: duration)
        let sequence = SKAction.repeatActionForever(SKAction.sequence([rotateUp, rotateDown]))
        rotator.runAction(sequence)
        
        //Make running button
        let runButtonSize:CGFloat = 50
        runButton = UIButton(frame: CGRectMake(25, self.view!.frame.size.height - runButtonSize - 25, runButtonSize, runButtonSize))
        runButton.layer.cornerRadius = runButtonSize/2
        runButton.backgroundColor = UIColor(hex: 0xFFBE63)
        runButton.addTarget(self, action: "runButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(runButton)
        
        //Make throwing button
        let throwButtonSize:CGFloat = 50
        let throwButton = UIButton(frame: CGRectMake(600, self.view!.frame.size.height - throwButtonSize - 25, throwButtonSize, throwButtonSize))
        throwButton.layer.cornerRadius = throwButtonSize/2
        throwButton.backgroundColor = UIColor(hex: 0xFFBE63)
        throwButton.addTarget(self, action: "throwButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(throwButton)
    }
    
    //when runButton is clicked
    func runButtonClicked() {
        println("Pressed")
        tebow.sprite.physicsBody?.applyImpulse(CGVectorMake(6, 0))
    }
    
    //when throwButton is clicked
    //need to release the mascot
    func throwButtonClicked(Button:UIButton){
        println("Throw clicked")
        runButton.removeFromSuperview()
        Button.removeFromSuperview()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //moves the ground 1 position at a time to left
//        if(ground.position.x < -groundWidth) {
//            self.removeChildrenInArray([ground])
//        }
//        ground.position.x = ground.position.x - 10
//        
//        //moves Tim Tebow 1 position at a time to left
//        //COME BACK TO THIS
//        if(tebow.sprite.position.x < -tebow.sprite.frame.size.width){
//            self.removeChildrenInArray([tebow.sprite])
//        }
//        tebow.sprite.position.x = tebow.sprite.position.x - 10
//        
//       
//        //moves river1 1 position at a time to left
//        river1.position.x = river1.position.x - 10
//        if(river1.position.x <= 1-self.frame.size.width){
//            river1.position.x = self.frame.size.width+1
//        }
//        
//        //moves river2 1 position at a time to left
//        river2.position.x = river2.position.x - 10
//        if(river2.position.x <= 1-self.frame.size.width){
//            river2.position.x = self.frame.size.width+1
//        }

        if tebow.xVel > 0 {
            tebow.xVel -= friction
        } else {
            tebow.xVel = 0
        }
        tebow.x += tebow.xVel
        //tebow.sprite.position.x = tebow.x
        
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
