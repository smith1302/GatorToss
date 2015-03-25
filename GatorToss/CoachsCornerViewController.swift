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
    var power:UILabel!
    var powerButton:UIButton!
    var accuracy:UILabel!
    var accuracyButton:UIButton!
    var speed:UILabel!
    var speedButton:UIButton!
    var pointsLabel:UILabel!
    var backButton:UIButton!
    
    var coachImage:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()

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
        
        // Upgrades
        let textPadding:CGFloat = 13
        let textH:CGFloat = 19
        startingY = 0
        
        pointsLabel = UILabel(frame: CGRectMake(0, startingY, upgradeView.frame.width, textH))
        pointsLabel.text = "\(game.points) points"
        pointsLabel.font = UIFont.systemFontOfSize(textH)
        pointsLabel.textAlignment = .Right
        
        startingY += textH + textPadding
        power = UILabel(frame: CGRectMake(0, startingY, upgradeView.frame.width, textH))
        power.text = "Power: \(game.power)"
        power.font = UIFont.systemFontOfSize(textH)
        
        powerButton = UIButton(frame: CGRectMake(upgradeView.frame.width - 20, startingY, textPadding, textH))
        powerButton.setTitle("+", forState: UIControlState.Normal)
        powerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        powerButton.titleLabel?.textAlignment = .Right
        powerButton.titleLabel?.font = UIFont.boldSystemFontOfSize(textH)
        powerButton.addTarget(self, action: "upgradePressed:", forControlEvents: .TouchUpInside)
        
        startingY += textH + textPadding
        accuracy = UILabel(frame: CGRectMake(0, startingY, upgradeView.frame.width, textH))
        accuracy.text = "Accuracy: \(game.accuracy)"
        accuracy.font = UIFont.systemFontOfSize(textH)
        
        accuracyButton = UIButton(frame: CGRectMake(upgradeView.frame.width - 20, startingY, textPadding, textH))
        accuracyButton.setTitle("+", forState: UIControlState.Normal)
        accuracyButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        accuracyButton.titleLabel?.textAlignment = .Right
        accuracyButton.titleLabel?.font = UIFont.boldSystemFontOfSize(textH)
        accuracyButton.addTarget(self, action: "upgradePressed:", forControlEvents: .TouchUpInside)
        
        startingY += textH + textPadding
        speed = UILabel(frame: CGRectMake(0, startingY, upgradeView.frame.width, textH))
        speed.text = "Speed: \(game.speed)"
        speed.font = UIFont.systemFontOfSize(textH)
        
        speedButton = UIButton(frame: CGRectMake(upgradeView.frame.width - 20, startingY, textPadding, textH))
        speedButton.setTitle("+", forState: UIControlState.Normal)
        speedButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        speedButton.titleLabel?.textAlignment = .Right
        speedButton.titleLabel?.font = UIFont.boldSystemFontOfSize(textH)
        speedButton.addTarget(self, action: "upgradePressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(upgradeView)
        self.view.addSubview(coachImage)
        self.view.addSubview(backButton)
        
        upgradeView.addSubview(pointsLabel)
        upgradeView.addSubview(power)
        upgradeView.addSubview(accuracy)
        upgradeView.addSubview(speed)
        upgradeView.addSubview(powerButton)
        upgradeView.addSubview(accuracyButton)
        upgradeView.addSubview(speedButton)
        
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
        if button == powerButton {
            game.power++
            game.points -= 10
        } else if button == accuracyButton {
            game.accuracy++
            game.points -= 10
        } else if button == speedButton {
            game.speed++
            game.points -= 10
        }
        
        updateText()
    }
    
    func updateText() {
        pointsLabel.text = "\(game.points) points"
        accuracy.text = "Accuracy: \(game.accuracy)"
        power.text = "Power: \(game.power)"
        speed.text = "Speed: \(game.speed)"
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
