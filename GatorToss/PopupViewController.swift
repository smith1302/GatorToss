//
//  PopupViewController.swift
//  GatorToss
//
//  Created by Eric Smith on 3/17/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import UIKit
import GameKit

class PopupViewController: UIViewController, GKGameCenterControllerDelegate {
    
    var popUp: UIView!
    var continueButton:UIButton!
    var upgradeButton:UIButton!
    var leaderboardButton: UIButton!
    var leagueLabel:UILabel!
    var bestLabel:UILabel!
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
        
        popUp = UIView(frame: CGRectMake(paddingX, paddingY, popUpW, popUpH))
        popUp.backgroundColor = UIColor(hex: 0xFFEAB8)
        popUp.layer.cornerRadius = 9
        popUp.layer.borderColor = UIColor(hex:0xF5DB9F).CGColor
        popUp.layer.borderWidth = 5
        self.view.addSubview(popUp)
        
        let numButtons:CGFloat = 3
        let buttonW:CGFloat =  (popUpW - (numButtons-1)*buttonPadding)/numButtons
        
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
        
        leaderboardButton = UIButton(frame: CGRectMake(paddingX + buttonW*2 + buttonPadding*2, popUpH + paddingY + buttonPadding, buttonW, buttonH))
        leaderboardButton.backgroundColor = UIColor(hex: 0xFFEAB8)
        leaderboardButton.layer.cornerRadius = 6
        leaderboardButton.setTitle("Leaderboard", forState: .Normal)
        leaderboardButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        leaderboardButton.addTarget(self, action: "leaderboardPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(leaderboardButton)
        
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
        
        startingY += titleH+20
        bestLabel = UILabel(frame: CGRectMake(sideInnerPadding, startingY, popUpW, labelH))
        bestLabel.text = "Best: \(game.bestDistance) Yards"
        popUp.addSubview(bestLabel)
        
        startingY += labelH+20
        pointsLabel = UILabel(frame: CGRectMake(sideInnerPadding, startingY, popUpW, labelH))
        pointsLabel.text = "Points: \(game.points)"
        popUp.addSubview(pointsLabel)
        handlePoints()
        
        saveHighscore(distance)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resumePlay() {
        gameDelegate?.reset()
    }
    
    func leaderboardPressed() {
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        self.presentViewController(gc, animated: true, completion: nil)
    }
    
    func upgradePressed() {
        gameDelegate?.goToCoachsCorner()
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
    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //send high score to leaderboard
    func saveHighscore(score:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "gatortoss_leaderboard") //leaderboard id here
            
            scoreReporter.value = Int64(score) //score variable here (same as above)
            
            var scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
            
        }
        
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
