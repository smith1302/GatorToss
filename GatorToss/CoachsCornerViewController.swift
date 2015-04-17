//
//  CoachsCornerViewController.swift
//  GatorToss
//
//  Created by NG38 on 3/17/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import UIKit

class CoachsCornerViewController: UIViewController {
    
    //arm strength - increases power
    //calmness - slows down the arrow
    //accuracy - makes getting perfect easier, good easier, poor harder
    //speed - increases speed of tebow running up
    //ability to purchase mascots - we'll worry about it later.
    
    var titleLabel:UILabel!
    // Upgrades
    var upgradeView:UIView!
    var pointsLabel:UILabel!
    var backButton:UIButton!
    var roundLabel:UILabel!
    
    //Upgrade Text
    var power:UILabel!
    var accuracy:UILabel!
    var speed:UILabel!
    var calmness:UILabel!
    
    // Purchase buttons
    var powerButton:UIButton!
    var accuracyButton:UIButton!
    var speedButton:UIButton!
    var calmnessButton:UIButton!
    
    //Pricing
    var powerPrice:UILabel!
    var accuracyPrice:UILabel!
    var speedPrice:UILabel!
    var calmnessPrice:UILabel!
    
    
    var coachImage:UIImageView!
    var upgradePriceLabel:[String:UILabel] = [String:UILabel]()
    var upgradeButtons:[String:UIButton] = [String:UIButton]()
    var upgradeLabels:[String:UILabel] = [String:UILabel]()
    var upgrades:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        upgrades = ["Arm Strength", "Calmness", "Accuracy" , "Speed"]

        var startingY:CGFloat = 30
        let backButtonH:CGFloat = 24
        let titleLabelH:CGFloat = 24
        titleLabel = UILabel(frame: CGRectMake(0, startingY, self.view.frame.size.width, titleLabelH))
        titleLabel.text = "Coachs Corner"
        titleLabel.font = UIFont.boldSystemFontOfSize(titleLabelH)
        titleLabel.textAlignment = .Center
        
        startingY += titleLabelH + 30
        upgradeView = UIView(frame: CGRectMake(25, startingY, self.view.frame.size.width/2, self.view.frame.size.height - startingY - backButtonH - 30))
        
        let coachImageStartX:CGFloat = upgradeView.frame.origin.x + upgradeView.frame.size.width + 25
        coachImage = UIImageView(frame: CGRectMake(coachImageStartX, startingY, self.view.frame.size.width - coachImageStartX - 25, upgradeView.frame.size.height))
        coachImage.backgroundColor = UIColor.redColor()
        
        startingY += upgradeView.frame.height + 15
        backButton = UIButton(frame: CGRectMake(upgradeView.frame.origin.x, startingY, 100, backButtonH))
        backButton.setTitle("Back", forState: .Normal)
        backButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        backButton.titleLabel?.font = UIFont.boldSystemFontOfSize(backButtonH)
        backButton.titleLabel?.sizeToFit()
        backButton.frame.size.width = backButton.titleLabel!.frame.size.width
        backButton.addTarget(self, action: "goBack", forControlEvents: .TouchUpInside)
        
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(upgradeView)
        self.view.addSubview(coachImage)
        self.view.addSubview(backButton)
        
        // Upgrades
        let textPadding:CGFloat = 13
        let textH:CGFloat = 19
        let priceW:CGFloat = 50
        let upgradeButtonPadding:CGFloat = 20
        let upgradeButtonSize:CGFloat = textH + 5
        startingY = 0
        
        roundLabel = UILabel(frame: CGRectMake(0, startingY, upgradeView.frame.width/2, textH))
        roundLabel.text = "Round \(game.round)"
        roundLabel.font = UIFont.systemFontOfSize(textH)
        roundLabel.textAlignment = .Left
        
        pointsLabel = UILabel(frame: CGRectMake(upgradeView.frame.width/2, startingY, upgradeView.frame.width/2, textH))
        pointsLabel.text = "\(game.points) points"
        pointsLabel.font = UIFont.systemFontOfSize(textH)
        pointsLabel.textAlignment = .Right
        
        startingY += textH + textPadding + 5
        
        for key in upgrades {
            upgradeLabels[key] = UILabel(frame: CGRectMake(0, startingY, upgradeView.frame.width, textH))
            upgradeLabels[key]?.text = "\(key): \(Int(game.nameToVar[key]!))"
            upgradeLabels[key]?.font = UIFont.systemFontOfSize(textH)
            
            upgradePriceLabel[key] = UILabel(frame: CGRectMake(upgradeView.frame.width-priceW, startingY, priceW, textH))
            upgradePriceLabel[key]?.text = "$\(scalePrice(game.nameToVar[key]!))"
            upgradePriceLabel[key]?.font = UIFont.systemFontOfSize(textH)
            upgradePriceLabel[key]?.textColor = UIColor(hex: 0x1AB000)
            upgradePriceLabel[key]?.textAlignment = .Right
            
            upgradeButtons[key] = UIButton(frame: CGRectMake(upgradeView.frame.width - upgradePriceLabel[key]!.frame.width - upgradeButtonPadding, startingY - upgradeButtonSize/4, upgradeButtonSize, upgradeButtonSize))
            upgradeButtons[key]?.setTitle("+", forState: UIControlState.Normal)
            upgradeButtons[key]?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            upgradeButtons[key]?.titleLabel?.textAlignment = .Right
            upgradeButtons[key]?.titleLabel?.font = UIFont.boldSystemFontOfSize(upgradeButtonSize)
            upgradeButtons[key]?.addTarget(self, action: "upgradePressed:", forControlEvents: .TouchUpInside)
            startingY += textH + textPadding
            
            upgradeView.addSubview(upgradeLabels[key]!)
            upgradeView.addSubview(upgradePriceLabel[key]!)
            upgradeView.addSubview(upgradeButtons[key]!)
        }
        
        upgradeView.addSubview(roundLabel)
        upgradeView.addSubview(pointsLabel)
        
        let seminoleImage:UIButton = UIButton(frame: CGRectMake(30, 200, 25, 25))
        seminoleImage.setImage(UIImage(named: "seminole.png"), forState: UIControlState.Normal)
        upgradeView.addSubview(seminoleImage)
        
        let bulldogImage:UIButton = UIButton(frame: CGRectMake(90, 200, 25, 25))
        bulldogImage.setImage(UIImage(named: "bigDog.png"), forState: UIControlState.Normal)
        upgradeView.addSubview(bulldogImage)
        
        let tennesseeImage:UIButton = UIButton(frame: CGRectMake(150, 200, 25, 25))
        tennesseeImage.setImage(UIImage(named: "bigDog.png"), forState: UIControlState.Normal)
        upgradeView.addSubview(tennesseeImage)
        
        let bamaImage:UIButton = UIButton(frame: CGRectMake(210, 200, 25, 25))
        bamaImage.setImage(UIImage(named: "bigDog.png"), forState: UIControlState.Normal)
        upgradeView.addSubview(bamaImage)
        
        
        //Navigation Controller
        self.navigationController?.navigationBarHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goBack() {
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func upgradePressed(button:UIButton) {
        if button == upgradeButtons["Arm Strength"] && game.points >= scalePrice(game.nameToVar["Arm Strength"]!) {
            game.power++
            game.points -= scalePrice(game.power-1)
        } else if button == upgradeButtons["Accuracy"] && game.points >= scalePrice(game.nameToVar["Accuracy"]!) {
            game.accuracy++
            game.points -= scalePrice(game.accuracy-1)
        } else if button == upgradeButtons["Speed"] && game.points >= scalePrice(game.nameToVar["Speed"]!) {
            game.speed++
            game.points -= scalePrice(game.speed-1)
        } else if button == upgradeButtons["Calmness"] && game.points >= scalePrice(game.nameToVar["Calmness"]!) {
            game.calmness++
            game.points -= scalePrice(game.calmness-1)
        }
        updateText()
    }
    
    func updateText() {
        pointsLabel.text = "\(game.points) points"
        
        for (key, value) in upgradeLabels {
            upgradeLabels[key]?.text = "\(key): \(Int(game.nameToVar[key]!))"
            upgradePriceLabel[key]?.text = "$\(scalePrice(game.nameToVar[key]!))"
        }
    }
    
    func scalePrice(unit:CGFloat) -> Int {
        return Int(unit*6)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
