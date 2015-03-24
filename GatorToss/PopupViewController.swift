//
//  PopupViewController.swift
//  GatorToss
//
//  Created by Eric Smith on 3/17/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    var popUp: UIView!
    var continueButton:UIButton!
    var upgradeButton:UIButton!
    var leagueLabel:UILabel!
    var distanceLabel:UILabel!
    var chasingLabel:UILabel!
    var pointsLabel:UILabel!
    var gameDelegate:GameScene?
    var distance:Int
    
    init(distance:Int) {
        self.distance = distance
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        let paddingX:CGFloat = screenWidth/5
        let paddingY:CGFloat = 50
        var buttonH:CGFloat = 60
        var buttonPadding:CGFloat = 20
        var popUpH:CGFloat = screenHeight - paddingY*2 - buttonH - buttonPadding
        var popUpW:CGFloat = screenWidth - paddingX*2
        var buttonW:CGFloat = popUpW/2 - buttonPadding/2
        
        popUp = UIView(frame: CGRectMake(paddingX, paddingY, popUpW, popUpH))
        popUp.backgroundColor = UIColor(hex: 0xFFEAB8)
        popUp.layer.cornerRadius = 9
        popUp.layer.borderColor = UIColor(hex:0xF5DB9F).CGColor
        popUp.layer.borderWidth = 6
        self.view.addSubview(popUp)
        
        continueButton = UIButton(frame: CGRectMake(paddingX, popUpH + paddingY + buttonPadding, buttonW, buttonH))
        continueButton.backgroundColor = UIColor(hex: 0xFFEAB8)
        continueButton.layer.cornerRadius = 6
        continueButton.titleLabel?.textColor = UIColor.blackColor()
        continueButton.setTitle("Play", forState: .Normal)
        continueButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        continueButton.addTarget(self, action: "resumePlay", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(continueButton)
        
        upgradeButton = UIButton(frame: CGRectMake(paddingX + buttonW + buttonPadding, popUpH + paddingY + buttonPadding, buttonW, buttonH))
        upgradeButton.backgroundColor = UIColor(hex: 0xFFEAB8)
        upgradeButton.layer.cornerRadius = 6
        upgradeButton.setTitle("Coaches Corner", forState: .Normal)
        upgradeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        upgradeButton.addTarget(self, action: "upgradePressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(upgradeButton)
        
        var startingY:CGFloat = 20
        let titleH:CGFloat = 20
        let title = UILabel(frame: CGRectMake(0, startingY, popUpW, titleH))
        title.text = "Title"
        title.font = UIFont.boldSystemFontOfSize(titleH)
        title.textColor = UIColor.blackColor()
        title.textAlignment = .Center
        title.alpha = 0.9
        popUp.addSubview(title)
        
        let sideInnerPadding:CGFloat = 25
        let labelH:CGFloat = 19
        startingY += titleH+20
        distanceLabel = UILabel(frame: CGRectMake(sideInnerPadding, startingY, popUpW, labelH))
        distanceLabel.text = "Distance: \(distance) Yards"
        popUp.addSubview(distanceLabel)
        
        startingY += labelH+20
        pointsLabel = UILabel(frame: CGRectMake(sideInnerPadding, startingY, popUpW, labelH))
        pointsLabel.text = "Points: \(game.points)"
        popUp.addSubview(pointsLabel)
        handlePoints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resumePlay() {
        gameDelegate?.reset()
        self.view.removeFromSuperview()
    }
    
    func upgradePressed() {
        
    }
    
    func calculatePoints(distance:Int) -> Int {
        let base = Int(distance/50) * 3
        let safety = ((distance%50) > 0) ? 2 : 0
        return base + safety
    }
    
    func handlePoints() {
        let thisThrowPoints = calculatePoints(distance)
        game.points += thisThrowPoints
        pointsLabel.text = "Points: \(game.points)"
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
