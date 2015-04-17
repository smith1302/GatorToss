//
//  GameScene.swift
//  GatorToss
//
//  Created by Eric Smith on 2/18/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import SpriteKit
import QuartzCore
import UIKit

let friction:CGFloat = 0.25

class GameScene: SKScene {

    var world:SKNode!
    var tebow:Tebow!
    var mascot1:Mascot!
    var clouds:[SKSpriteNode] = [SKSpriteNode]()
    var river1:SKSpriteNode!
    var cloud1:SKSpriteNode!
    var cloud2:SKSpriteNode!
    var gradNode:SKSpriteNode!
    var buoy:SKSpriteNode?
    var ground:SKSpriteNode!
    var groundArt:Ground!
    var sprite:SKSpriteNode!
    var rotator:SKSpriteNode!
    let mascotSize:CGFloat = 15
    var groundWidth:CGFloat = 400
    var riverHeight:CGFloat!
    var startingPoint:CGFloat = 50
    var offsetX:CGFloat! = 0
    var offsetY:CGFloat = 0
    var runButton:UIButton!
    var throwButton:UIButton!
    var resetButton:UIButton!
    var distanceLabel:UILabel!
    var worldGoalPos:CGPoint!
    var bounceLabel:UILabel?
    let spaceColor:UIColor = UIColor(hex: 0x32394F)
    let bounceLabelTimer:Double = 1.5
    var canBounce:Bool!
    var distanceDivider:CGFloat = 11 // Dividing the pixel distance to meters
    var popUpController:PopupViewController?
    var gameViewController:GameViewController!
    
    let waterGravity:CGFloat = -0.9
    let airGravity:CGFloat = -2
    
    // Tutorial stuff
    var maskLayer = CAShapeLayer()
    var tutorialFrames:[CGRect] = [CGRect]()
    var tutorialText:[String] = [String]()
    var currentTutIndex:Int = -1
    var tutorialLabel:UILabel!
    var tutorialInstruction:UILabel!
    var doTutorial:Bool {
        get {
            let defaults = NSUserDefaults.standardUserDefaults()
            if let val = defaults.boolForKey("doTutorial") as Bool? {
                return val
            } else {
                return true
            }
        }
        set(val) {
            NSUserDefaults.standardUserDefaults().setBool(val, forKey: "doTutorial")
        }
    }

    override func didMoveToView(view: SKView) {
        self.size = view.bounds.size
        self.backgroundColor = spaceColor
        
        self.physicsWorld.gravity = CGVectorMake(0, airGravity)
        
        // World Scene (basically our camera)
        world = SKNode()
        self.addChild(world)
        
        //Make running button
        let buttonSize:CGFloat = 80
        runButton = UIButton(frame: CGRectMake(25, self.view!.frame.size.height - buttonSize - 25, buttonSize, buttonSize))
        runButton.setImage(UIImage(named: "running"), forState: .Normal)
        runButton.layer.cornerRadius = buttonSize/2
        runButton.layer.borderWidth = 4
        runButton.layer.borderColor = UIColor(hex: 0xEDA745).CGColor
        runButton.backgroundColor = UIColor(hex: 0xFFBE63)
        runButton.addTarget(self, action: "buttonDown:", forControlEvents: UIControlEvents.TouchDown)
        runButton.addTarget(self, action: "buttonUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        runButton.addTarget(self, action: "runButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        runButton.imageEdgeInsets = UIEdgeInsetsMake(21,21,21,21)
        self.view?.addSubview(runButton)
        
        //Make throwing button
        throwButton = UIButton(frame: CGRectMake(self.view!.frame.size.width-buttonSize-25, self.view!.frame.size.height - buttonSize - 25, buttonSize, buttonSize))
        throwButton.setImage(UIImage(named: "football"), forState: .Normal)
        throwButton.layer.cornerRadius = buttonSize/2
        throwButton.layer.borderWidth = 4
        throwButton.layer.borderColor = UIColor(hex: 0xEDA745).CGColor
        throwButton.backgroundColor = UIColor(hex: 0xFFBE63)
        throwButton.addTarget(self, action: "buttonDown:", forControlEvents: UIControlEvents.TouchDown)
        throwButton.addTarget(self, action: "buttonUp:", forControlEvents: UIControlEvents.TouchUpOutside)
        throwButton.addTarget(self, action: "throwButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        throwButton.imageEdgeInsets = UIEdgeInsetsMake(21,21,21,21)
        self.view?.addSubview(throwButton)

        //make reset button
        resetButton = UIButton(frame: CGRectMake(self.view!.frame.size.width-buttonSize-25, self.view!.frame.size.height - buttonSize - 225, buttonSize, buttonSize))
        resetButton.layer.cornerRadius = buttonSize/2
        resetButton.backgroundColor = UIColor(hex:0xFFBE63)
        resetButton.addTarget(self, action: "resetButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        //self.view?.addSubview(resetButton)

        // Distance label
        distanceLabel = UILabel()
        distanceLabel.textAlignment = .Right
        distanceLabel.frame = CGRectMake(self.frame.size.width - 120, 0, 100, 50)
        distanceLabel.text = "0 meters"
        self.view?.addSubview(distanceLabel)
        reset()
        
        if doTutorial {
            let tutColor:UIColor = UIColor(white: 0, alpha: 0.6)
            maskLayer.opaque = false
            maskLayer.fillColor = tutColor.CGColor
            maskLayer.fillRule = kCAFillRuleEvenOdd
            self.view!.layer.addSublayer(maskLayer)
            maskLayer.frame = self.view!.layer.bounds
            
            tutorialLabel = UILabel(frame: CGRectMake(self.view!.frame.width/4, 40, self.view!.frame.width/2, 60))
            tutorialLabel.textAlignment = .Center
            tutorialLabel.numberOfLines = 2
            tutorialLabel.textColor = UIColor(white: 1, alpha: 0.95)
            tutorialLabel.font = UIFont.boldSystemFontOfSize(21)
            self.view?.addSubview(tutorialLabel)
            
            tutorialInstruction = UILabel(frame: CGRectMake(0, self.view!.frame.size.height - 50, self.view!.frame.size.width, 30))
            tutorialInstruction.textAlignment = .Center
            tutorialInstruction.textColor = UIColor(white: 1, alpha: 0.7)
            tutorialInstruction.text = "Tap to continue"
            self.view?.addSubview(tutorialInstruction)
            
            let tbf = throwButton.frame
            let rbf = runButton.frame
            let sbf = tebow.sprite.frame
            
            let pad:CGFloat = 10
            let firstTF = CGRectMake(sbf.origin.x - pad*2, sbf.origin.y - pad*2.5 - sbf.size.height, sbf.size.height + pad*2, sbf.size.height + pad*2)
            let secondTF = CGRectMake(sbf.origin.x + pad*3.5, sbf.origin.y - pad*3.5 - sbf.size.height, sbf.size.height - pad, sbf.size.height - pad)
            let thirdTF = CGRectMake(rbf.origin.x - pad, rbf.origin.y - pad, rbf.size.width + pad*2, rbf.size.height + pad*2)
            let fourTF = CGRectMake(tbf.origin.x - pad, tbf.origin.y - pad, tbf.size.width + pad*2, tbf.size.height + pad*2)
            tutorialFrames.append(firstTF)
            tutorialText.append("This is Tim Tebow.")
            tutorialFrames.append(secondTF)
            tutorialText.append("This represents the angle of his throw.")
            tutorialFrames.append(thirdTF)
            tutorialText.append("Tap this once to choose your angle.")
            tutorialFrames.append(thirdTF)
            tutorialText.append("Then, tap it repeatedly to speed Tebow up")
            tutorialFrames.append(fourTF)
            tutorialText.append("Tap this before Tebow falls off the ledge to throw.")
            nextTutorialStep()
        }
        
    }
    
    func nextTutorialStep() -> Bool {
        if currentTutIndex+1 >= tutorialFrames.count {
            doTutorial = false
            maskLayer.removeFromSuperlayer()
            tutorialLabel.removeFromSuperview()
            tutorialInstruction.removeFromSuperview()
            return false
        }
        ++currentTutIndex
        let time:Double = 0.4
        UIView.animateWithDuration(time, animations: {
                self.tutorialLabel.alpha = 0
            }, completion: {
                finished in
                self.tutorialLabel.text = self.tutorialText[self.currentTutIndex]
                UIView.animateWithDuration(time, animations: {
                    self.tutorialLabel.alpha = 1
                    }, completion: nil)
                
        })
        let path = UIBezierPath(rect: self.view!.layer.frame)
        let frame = tutorialFrames[currentTutIndex]
        path.appendPath(UIBezierPath(ovalInRect: frame))
        path.closePath()
        maskLayer.path = path.CGPath
        return true
    }
    
    //when resetButton is clicked
    func resetButtonClicked() {
        reset()
    }
    
    func buttonDown(button:UIButton) {
        if doTutorial { return }
        button.transform = CGAffineTransformMakeScale(1.1, 1.1)
        button.alpha = 0.6
    }
    
    func buttonUp(button:UIButton) {
        if doTutorial { nextTutorialStep(); return }
        button.transform = CGAffineTransformMakeScale(1, 1)
        button.alpha = 1
    }
    
    //when runButton is clicked
    func runButtonClicked(button:UIButton) {
        if doTutorial { return }
        tebow.sprite.physicsBody?.applyImpulse(CGVectorMake(log10(game.speed)+7.0, 0))
        rotator.removeActionForKey("rotateSequence")
        tebow.didMove = true
        buttonUp(button)
        tebow.setMoving()
    }
    
    //when throwButton is clicked
    //need to release the mascot
    func throwButtonClicked(Button:UIButton){
        if doTutorial { return }
        if !tebow.canThrow {
            return
        }
        tebow.setThrowing()
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
        buttonUp(Button)

    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if doTutorial {
            nextTutorialStep()
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if tebow.didThrow && mascot1.bounceFriction == mascot1.bounceFrictionDefault && canBounce == true && mascotDistance() > 0 && !doTutorial {
            let river1Y = river1.position.y + river1.frame.height/2
            let mascotY = mascot1.sprite.position.y - mascot1.sprite.frame.height/2
            let distance = distanceToBounce()
            let mascotHeight = mascot1.sprite.frame.size.height
            
            if distance < mascotHeight/3.50 + game.accuracy/1000{
                mascot1.bounceFriction = game.bounceMultiplier[0]
                println("PERFECT!")
                addBounceLabel("PERFECT!")
            }
            else if distance < mascotHeight * 1.5 + game.accuracy/1000 {
                mascot1.bounceFriction = game.bounceMultiplier[1]
                println("Very Good!")
                addBounceLabel("Very Good!")
            } else if distance < mascotHeight*2.5 + game.accuracy/1000 {
                mascot1.bounceFriction = game.bounceMultiplier[2]
                println("Good")
                addBounceLabel("Good")
            } else if distance < mascotHeight*4.0 + game.accuracy/1000 {
                mascot1.bounceFriction = game.bounceMultiplier[3]
                println("OK")
                addBounceLabel("OK")
            } else if distance < mascotHeight*5.0 + game.accuracy/1000{
                mascot1.bounceFriction = game.bounceMultiplier[4]
                println("Poor")
                addBounceLabel("Poor")
            }
        }
    }

    func distanceToBounce() -> CGFloat {
        let river1Y = river1.position.y + river1.frame.height/2
        let mascotY = mascot1.sprite.position.y - mascot1.sprite.frame.height/2
        let distance = abs(mascotY - river1Y)
        return distance
    }

    func addBounceLabel(textForLabel: String) {
        canBounce = false
        bounceLabel?.text = textForLabel
        bounceLabel!.frame = CGRectMake(0, self.frame.size.height - 20 - 30, self.frame.size.width, 25)
        bounceLabel!.font = UIFont.boldSystemFontOfSize(24)
        bounceLabel!.textColor = UIColor.whiteColor()
        bounceLabel?.layer.borderColor = UIColor.blackColor().CGColor
        self.view?.addSubview(bounceLabel!)
        self.bounceLabel!.alpha = 0
        self.bounceLabel!.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: {
            self.bounceLabel!.alpha = 1
            self.bounceLabel!.transform = CGAffineTransformMakeScale(1, 1)
        }, completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(bounceLabelTimer, target: self, selector: "resetDistanceLabel", userInfo: nil, repeats: false)
    }
    
    func resetDistanceLabel() {
        bounceLabel?.removeFromSuperview()
    }
    
    func mascotStopped() {
        mascot1.didStop = true
        distanceLabel.hidden = true
        let distanceAdjusted = (mascotDistance() < 0) ? 0 : mascotDistance()
        if game.bestDistance < distanceAdjusted {
            game.bestDistance = distanceAdjusted
        }
        game.round++
        self.physicsWorld.gravity = CGVectorMake(0, waterGravity)
        river1.physicsBody = nil
        
        let delay = 1 * Double(NSEC_PER_SEC)
        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            self.popUpController = PopupViewController(distance: distanceAdjusted)
            self.popUpController!.gameDelegate = self
            self.popUpController!.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
            self.view?.addSubview(self.popUpController!.view)
        })
    }
    
    func mascotDistance() -> Int {
        let mascotDistanceToSide = self.convertPoint(mascot1.sprite.position, fromNode: mascot1.sprite.scene!)
        let distanceThrownX = mascotDistanceToSide.x - ground.size.width
        let distanceAdjusted = Int(distanceThrownX/distanceDivider)
        return distanceAdjusted
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        // If tebow isnt moving set state to standing
        if tebow.sprite.physicsBody?.velocity.dx <= 1 && tebow.isMoving() {
            tebow.setStanding()
        }

        //Save landing speed to use when he bounces back up
        if let fallSpeed = mascot1.sprite.physicsBody?.velocity.dy { // Check for nil
            if fallSpeed < 0 { // check if falling downwards
                mascot1.fallSpeed = fallSpeed
            }
        }
        
        // Do the bounce
        if let mascotYVel = mascot1.sprite.physicsBody?.velocity.dy {
            if mascot1.oldDy < 0 && mascotYVel >= 0 {
                mascot1.sprite.physicsBody?.velocity.dy = (mascot1.fallSpeed * -1)*mascot1.bounceFrictionDefault
            }
            mascot1.oldDy = mascotYVel
        }
        
        if distanceToBounce() <= mascot1.sprite.frame.size.height*3/4 {
            // Water particles yay!
            for i in 0..<3 {
                let particle = WaterParticle()
                particle.position = CGPointMake(mascot1.sprite.position.x, mascot1.sprite.position.y - distanceToBounce())
                particle.zPosition = mascot1.sprite.zPosition+1
                world.addChild(particle)
            }
        }
        
        if distanceToBounce() > mascot1.sprite.frame.size.height*5 {
            canBounce = true
        }

        if mascot1.sprite.physicsBody?.velocity.dx <= 1 && mascot1.sprite.physicsBody?.velocity.dy <= 1 && mascot1.didStop == false && tebow.didThrow == true {
            mascotStopped()
        } else {
            // Distance Label
            let mascotDistanceToSide = self.convertPoint(mascot1.sprite.position, fromNode: mascot1.sprite.scene!)
            let distanceThrownX = mascotDistanceToSide.x - ground.size.width
            if distanceThrownX >= 0 {
                distanceLabel.text = "\(Int(distanceThrownX/distanceDivider)) Yards"
                if mascot1.sprite.physicsBody?.velocity.dx > 680 {
                    for i in 0..<3 {
                        let particle = Particle()
                        particle.position = mascot1.sprite.position
                        particle.zPosition = mascot1.sprite.zPosition+1
                        world.addChild(particle)
                    }
                }
            }
        }
        
        
        // If we have a bounce bonus and the user is going up, add additional speed.
        // We use the last known falling speed since if the user gets a bonus after the
        // mascot is bouncing up, the speed may have already decreased some
        if mascot1.bounceFriction > mascot1.bounceFrictionDefault {
            if mascot1.sprite.physicsBody?.velocity.dy > 0 {
                var newSpeed = mascot1.fallSpeed * mascot1.bounceFriction * -1
                mascot1.sprite.physicsBody!.velocity.dy = newSpeed
                mascot1.sprite.physicsBody?.applyImpulse(CGVectorMake((mascot1.bounceFriction * newSpeed)*0.005, 0))
                mascot1.bounceFriction = mascot1.bounceFrictionDefault
            }
        }
        
        //moves the ground 1 position at a time to left
        let groundPos = self.convertPoint(ground.position, fromNode: world)
        if(groundPos.x < -ground.size.width) {
            self.removeChildrenInArray([ground])
        }
       
        //moves river1 1 position at a time to left
        let river1Pos = self.convertPoint(river1.position, fromNode: world)
        if(river1Pos.x <= 0){
            river1.position.x += river1.scene!.frame.size.width
        }
        
        //moves background 1 position at a time to left
        let gradNodePos = self.convertPoint(gradNode.position, fromNode: world)
        if(gradNodePos.x <= 0){
            gradNode.position.x += gradNode.scene!.frame.size.width
        }
        
        //moves clouds 1 poisiton at a time to left
        for cloud in clouds {
            let cloudPosition = self.convertPoint(cloud.position, fromNode: world)
            if(cloudPosition.x <= 0 - cloud.size.width/2){
                cloud.position.x += self.frame.size.width + cloud.size.width
            }
        }
        
        if !tebow.didThrow {
            mascot1.sprite.hidden = false
            mascot1.sprite.position.x = tebow.sprite.position.x - tebow.sprite.size.width/2 + mascot1.sprite.size.width/2 - 2
            mascot1.sprite.position.y = tebow.sprite.position.y + tebow.sprite.frame.height/2 + mascot1.sprite.frame.height/2 - 28
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
        self.physicsWorld.gravity = CGVectorMake(0, airGravity)
        if popUpController != nil {
            popUpController!.view.removeFromSuperview()
        }
        
        resetDistanceLabel()
        bounceLabel = UILabel()
        bounceLabel?.textAlignment = .Center
        bounceLabel?.shadowColor = UIColor.blackColor()
        bounceLabel?.shadowOffset = CGSizeMake(1.0, 1.0);
        distanceLabel.hidden = false
        distanceLabel.text = "0 Yards"

        canBounce = true

        world.removeAllActions()
        world.removeAllChildren()
        self.removeAllActions()
        
        world.position = CGPointMake(0, 0)
        worldGoalPos = world.position
        
        //make gradient background
        let gradHRatio:CGFloat = 9
        UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width*2.5, self.frame.size.height*gradHRatio))
        let context = UIGraphicsGetCurrentContext()
        let gradient : CAGradientLayer = CAGradientLayer()
        let arrayColors: [AnyObject] = [
            spaceColor.CGColor,
            UIColor(hex: 0xACDCFC).CGColor
        ]
        gradient.frame = CGRectMake(0, 0, self.frame.size.width*2.5, self.frame.size.height*gradHRatio)
        gradient.colors = arrayColors
        gradient.renderInContext(context)
        let gradImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let texture = SKTexture(CGImage: gradImage.CGImage)
        gradNode = SKSpriteNode(texture: texture)
        gradNode.position = CGPointMake(gradNode.size.width/2, gradNode.size.height/2)

        //Make clouds
        makeCloud(50, y: 240, alpha: 1, cloudType: 0)
        makeCloud(450, y: 350, alpha: 1, cloudType: 1)
        makeCloud(20, y: 790, alpha: 0.8, cloudType: 1)
        makeCloud(400, y: 920, alpha: 0.8, cloudType: 0)
        
        // Make ground
        ground = SKSpriteNode(imageNamed: "ground.fw.png")
        // if the grounds height is bigger than half the screen, move it down until it fills half the screen
        let groundRemainderH = (ground.size.height - self.frame.size.height/2)
        let groundPosition = (groundRemainderH > 0) ? (groundRemainderH + self.frame.size.height/20): 0
        ground.anchorPoint = CGPointMake(0.5, 0.45)
        ground.position = CGPointMake(ground.size.width/2, ground.size.height/2 - groundPosition)
        ground.xScale = 1
        ground.yScale = 1
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody!.dynamic = false
        
        
        // Make Tebow
        let tebowSprite = SKSpriteNode(texture: SKTexture(imageNamed: "tebow_stand.png"))
        //tebowSprite = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(25, 55))
        tebowSprite.position = CGPointMake(startingPoint + tebowSprite.size.width/2, ground.size.height + (tebowSprite.size.height*0.6)/2 + 10)
        tebowSprite.xScale = 0.6
        tebowSprite.yScale = 0.6
        tebow = Tebow(sprite: tebowSprite)
        tebow.applyPhysicsBody()
        
        // Make Mascot
        let mascot = SKSpriteNode(texture: SKTexture(imageNamed: "seminole.png"))
        mascot.anchorPoint = CGPointMake(0.5, 0.5)
        mascot.physicsBody = nil
        mascot.xScale = 1
        mascot.yScale = 1
        mascot1 = Mascot(sprite: mascot)
        
        // Make a river1
        riverHeight = self.frame.size.height/4.5
        river1 = SKSpriteNode(color:UIColor(hex: 0x138BED), size: CGSizeMake(self.frame.size.width*2.5, riverHeight))
        river1.position = CGPointMake(river1.size.width/2, river1.size.height/2 - mascot.size.height)
        river1.anchorPoint = CGPointMake(0.5, 0.5 - ((mascot.size.height*3/4)/river1.size.height))
        river1.xScale = 1
        river1.yScale = 1
        river1.alpha = 0.7
        
        // Make Rotator
        rotator = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(40, 6))
        rotator = SKSpriteNode(imageNamed: <#String#>)
        rotator.anchorPoint = CGPointMake(-1, 0)
        // Rotate animation
        rotator.position = CGPointMake(tebow.sprite.size.width/2, 0)
        //let duration:Double = log10(Double(game.calmness)) + 0.2
        let duration:Double = log10(Double(game.calmness)) + 0.2-Double(game.calmness)/50
        let degToRad:CGFloat = 0.0175
        let rotateUp = SKAction.rotateToAngle(80*degToRad, duration: duration)
        let rotateDown = SKAction.rotateToAngle(5*degToRad, duration: duration)
        let rotateSequence = SKAction.repeatActionForever(SKAction.sequence([rotateUp, rotateDown]))
        rotator.runAction(rotateSequence, withKey: "rotateSequence")
        
        // Make best distance buoy
        if game.bestDistance > 0 {
            buoy = SKSpriteNode(imageNamed: "buoy.png")
            buoy!.xScale = 0.4
            buoy!.yScale = 0.4
            buoy!.position = CGPointMake(CGFloat(game.bestDistance)*distanceDivider + ground.size.width, riverHeight + buoy!.size.height/2 - 26)
            buoy!.zPosition = -1
        }
        
        runButton.hidden = false
        throwButton.hidden = false
        resetButton.hidden = false
    
        if game.bestDistance > 0 {
            world.addChild(buoy!)
        }
        tebowSprite.addChild(rotator)
        world.addChild(gradNode)
        world.addChild(ground)
        world.addChild(mascot)
        world.addChild(river1)
        world.addChild(tebowSprite)
        
        gradNode.zPosition = -10
        river1.zPosition = 10
        tebowSprite.zPosition = 8
        mascot.zPosition = 9
        ground.zPosition = 7

    }
    
    func makeCloud(x:CGFloat, y:CGFloat, alpha:CGFloat, cloudType:Int) {
        var cloud:SKSpriteNode!
        if cloudType == 0 {
            cloud = SKSpriteNode(imageNamed: "cloud1.png")
        } else {
            cloud = SKSpriteNode(imageNamed: "cloud2.png")
        }
        let randomNum = arc4random_uniform(15)
        let scale = 0.35 + CGFloat(randomNum/100)
        cloud.xScale = scale
        cloud.yScale = scale
        cloud.position = CGPointMake(x, y)
        cloud.zPosition = -2
        cloud.alpha = alpha
        clouds.append(cloud)
        world.addChild(cloud)
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
    
    func goToCoachsCorner() {
        let coachsCorner = CoachsCornerViewController()
        gameViewController.navigationController?.pushViewController(coachsCorner, animated: true)
        self.reset()
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
