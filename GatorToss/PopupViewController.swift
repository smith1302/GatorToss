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
    //var buttonPlay: UIButton

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        popUp = UIView(frame: CGRectMake(50, 50, screenWidth - 50*2, screenHeight - 50*2))
        //popUp.backgroundColor = UIColor(hex: <#Int#>)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
