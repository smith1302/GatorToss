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
    var textHolder: UIView!
    var buttonHolder:UIView!
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
    
    // counting label (points/money)
    var countingLabelStart:Int = 0
    var increasePointsTimer:NSTimer?
    let countingTotalTime:NSTimeInterval = 3
    var timeIntervalStep:NSTimeInterval = 0
    
    init(distance:Int) {
        self.distance = distance
        if distance < 300 {
            countingTotalTime = 1
        } else {
            countingTotalTime = 3
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        
        popUp = UIView(frame: view.frame)
        popUp.backgroundColor = UIColor(hex: 0x81A7C9)
        popUp.alpha = 0.65
        
        var startingY:CGFloat = 50
        let distanceLabelH:CGFloat = 76
        let bestLabelH:CGFloat = 25
        let pointsLabelH:CGFloat = 25
        
        textHolder = UIView(frame: view.frame)
        
        distanceLabel = UILabel(frame: CGRectMake(0, startingY, screenWidth, distanceLabelH))
        distanceLabel.textColor = UIColor.whiteColor()
        distanceLabel.font = UIFont.boldSystemFontOfSize(distanceLabelH)
        distanceLabel.textAlignment = .Center
        distanceLabel.text = "\(distance) Yards"
        
        startingY += distanceLabelH + 16
        bestLabel = UILabel(frame: CGRectMake(0, startingY, screenWidth, bestLabelH))
        bestLabel.textColor = UIColor.whiteColor()
        bestLabel.font = UIFont.boldSystemFontOfSize(bestLabelH)
        bestLabel.textAlignment = .Center
        bestLabel.text = "Best: \(game.bestDistance) Yards"
        
        startingY += bestLabelH + 8
        pointsLabel = UILabel(frame: CGRectMake(0, startingY, screenWidth, pointsLabelH))
        pointsLabel.textColor = UIColor.whiteColor()
        pointsLabel.font = UIFont.boldSystemFontOfSize(pointsLabelH)
        pointsLabel.textAlignment = .Center
        pointsLabel.text = "Money: $\(game.points)"
        
        let buttonPadding:CGFloat = 70
        let buttonW:CGFloat = 130*0.6
        let buttonH:CGFloat = 159*0.6
        
        buttonHolder = UIView(frame: CGRectMake(screenWidth/2 - buttonPadding - buttonW*3/2, screenHeight - 20 - buttonH, buttonW*3 + buttonPadding*2, buttonH))
        
        continueButton = UIButton(frame: CGRectMake(0, 0, buttonW, buttonH))
        continueButton.setImage(UIImage(named: "keepPlaying.fw.png"), forState: .Normal)
        continueButton.addTarget(self, action: "resumePlay", forControlEvents: .TouchUpInside)
        continueButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        upgradeButton = UIButton(frame: CGRectMake(buttonW + buttonPadding, 0, buttonW, buttonH))
        upgradeButton.setImage(UIImage(named: "coachsCorner.fw.png"), forState: .Normal)
        upgradeButton.addTarget(self, action: "upgradePressed", forControlEvents: .TouchUpInside)
        upgradeButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        leaderboardButton = UIButton(frame: CGRectMake(buttonW*2 + buttonPadding*2, 0, buttonW, buttonH))
        leaderboardButton.setImage(UIImage(named: "leaderBoard.fw.png"), forState: .Normal)
        leaderboardButton.addTarget(self, action: "leaderboardPressed", forControlEvents: .TouchUpInside)
        leaderboardButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        view.addSubview(popUp)
        view.addSubview(textHolder)
        view.addSubview(buttonHolder)
        textHolder.addSubview(distanceLabel)
        textHolder.addSubview(bestLabel)
        textHolder.addSubview(pointsLabel)
        buttonHolder.addSubview(continueButton)
        buttonHolder.addSubview(upgradeButton)
        buttonHolder.addSubview(leaderboardButton)
        
        buttonHolder.transform = CGAffineTransformMakeTranslation(0, (buttonH+20))
        textHolder.transform = CGAffineTransformMakeTranslation(0, -1*self.view.frame.size.height)
        
        handlePoints()
        saveHighscore(distance)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.3, delay: 0.4, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.textHolder.transform = CGAffineTransformMakeTranslation(0, 0)
            self.buttonHolder.transform = CGAffineTransformMakeTranslation(0, 0)
        }, completion: {
            finished in
            if finished {
                self.handlePoints()
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resumePlay() {
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.buttonHolder.transform = CGAffineTransformMakeTranslation(0, (160+20))
            self.textHolder.transform = CGAffineTransformMakeTranslation(0, -1*(self.view.frame.size.height))
        }, completion: {
            finished in
            if let delegate = self.gameDelegate {
                delegate.reset()
            }
        })
    }
    
    func leaderboardPressed() {
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        self.presentViewController(gc, animated: true, completion: nil)
    }
    
    func upgradePressed() {
        UIView.animateWithDuration(0.8, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.buttonHolder.transform = CGAffineTransformMakeTranslation(0, (160+20))
            self.textHolder.transform = CGAffineTransformMakeTranslation(0, -1*(self.view.frame.size.height))
        }, completion: {
            finished in
            if let delegate = self.gameDelegate {
                delegate.goToCoachsCorner()
            }
        })
    }
    
    func calculatePoints(distance:Int) -> Int {
        let base = Int(distance/50) * 3
        let safety = ((distance%50) > 0) ? 2 : 0
        return base + safety
    }
    
    func handlePoints() {
        countingLabelStart = game.points
        let thisThrowPoints = calculatePoints(distance)
        game.points += thisThrowPoints
        
        let goalDifference = game.points - countingLabelStart
        timeIntervalStep = countingTotalTime/NSTimeInterval(goalDifference)
        
        increasePoints()
    }
    
    func increasePoints() {
        if countingLabelStart > game.points {
            return
        }
        pointsLabel.text = "Money: $\(countingLabelStart++)"
        NSTimer.scheduledTimerWithTimeInterval(timeIntervalStep, target: self, selector: "increasePoints", userInfo: nil, repeats: false)
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
