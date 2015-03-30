//
//  Ground.swift
//  GatorToss
//
//  Created by Eric Smith on 3/29/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import UIKit

class Ground: UIView {
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        var startingY:CGFloat = 0
        let lightGrassH:CGFloat = 30
        let darkGrassH:CGFloat = 15
        let rockH:CGFloat = self.frame.size.height - lightGrassH - darkGrassH
        
        let lightGrass = UIView(frame: CGRectMake(0, startingY, self.frame.width, lightGrassH))
        lightGrass.backgroundColor = UIColor(hex: 0x1FCF33)
        self.addSubview(lightGrass)
        
        startingY += lightGrassH
        let darkGrass = UIView(frame: CGRectMake(0, startingY, self.frame.width, darkGrassH))
        darkGrass.backgroundColor = UIColor(hex: 0x0FA320)
        self.addSubview(lightGrass)
        
        startingY += darkGrassH
        let rock = UIView(frame: CGRectMake(0, startingY, self.frame.width, rockH))
        rock.backgroundColor = UIColor(hex: 0xC78316)
        self.addSubview(rock)
        
    }

}
