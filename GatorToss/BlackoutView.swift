//
//  BlackoutView.swift
//  GatorToss
//
//  Created by Eric Smith on 4/15/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import UIKit

class BlackoutView: UIView {
    
    let circleFrame:CGRect!
    let bgColor:UIColor!
    
    init(frame: CGRect, backgroundColor: UIColor, circleFrame:CGRect) {
        super.init(frame: frame)
        self.circleFrame = circleFrame
        self.bgColor = backgroundColor
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        let maskLayer = CAShapeLayer()
        maskLayer.opaque = false
        maskLayer.fillColor = bgColor.CGColor
        maskLayer.fillRule = kCAFillRuleEvenOdd
        self.layer.addSublayer(maskLayer)
        maskLayer.frame = self.layer.bounds
        let path = UIBezierPath(rect: self.layer.frame)
        path.appendPath(UIBezierPath(ovalInRect: circleFrame))
        path.closePath()
        maskLayer.path = path.CGPath
    }

}
