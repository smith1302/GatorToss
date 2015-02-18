//
//  GameScene.swift
//  GatorToss
//
//  Created by Eric Smith on 2/18/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var river:SKSpriteNode!
    var ground:SKSpriteNode!
    var sprite:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {

        self.backgroundColor = UIColor(red: 135/255.0, green: 187/255.0, blue: 222/255.0, alpha: 1)
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        //self.physicsWorld.contactDelega

        //Make a river
        river = SKSpriteNode(color:UIColor.blueColor(), size: CGSizeMake(self.frame.size.width, self.frame.size.height/2.5-25))
        river.anchorPoint = CGPointMake(0,0)
        river.position = CGPointMake(0, 0)
        river.xScale = 1
        river.yScale = 1
        self.addChild(river)

        // Make ground
        ground = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(600, self.frame.size.height/2.5))
        ground.anchorPoint = CGPointMake(0,0);
        ground.position = CGPointMake(0, 0)
        ground.xScale = 1
        ground.yScale = 1
        self.addChild(ground)
        
        let tebowSprite = SKSpriteNode(imageNamed:"Tebow")
        tebowSprite.anchorPoint = CGPointMake(0,0);
        tebowSprite.xScale = -0.3
        tebowSprite.yScale = 0.3
        tebowSprite.position = CGPointMake(tebowSprite.frame.size.width + 50, self.frame.size.height/2.5 - 20)
        self.addChild(tebowSprite)

        //Make button
        let runButtonSize:CGFloat = 50
        let runButton = UIButton(frame: CGRectMake(25, self.view!.frame.size.height - runButtonSize - 25, runButtonSize, runButtonSize))
        runButton.layer.cornerRadius = runButtonSize/2
        runButton.backgroundColor = UIColor(hex: 0xFFBE63)
        runButton.addTarget(self, action: "runButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.view?.addSubview(runButton)
        
    }
    
    func runButtonClicked() {
        println("Pressed")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            println(location)
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//
//            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if(ground.position.x < -600) {
            self.removeChildrenInArray([ground])
        }
        ground.position.x = ground.position.x - 1
        river.position.x = river.position.x - 1
        
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
