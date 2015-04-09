//
//  PNGAnimationView.swift
//  GatorToss
//
//  Created by Eric Smith on 4/6/15.
//  Copyright (c) 2015 SeniorDesign. All rights reserved.
//

import SpriteKit


class PNGAnimation {
    
    class func getTextures(fileNamePattern:String, startFrame:Int, totalFrame:Int) -> [SKTexture] {
        var spriteSheetImage:[SKTexture] = [SKTexture]()
        var imageName:String!
        for (var i = startFrame; i <= totalFrame; i++) {
            if i < 10 {
                imageName = NSString(format: "000%d", i)
            } else if i < 100 {
                imageName = NSString(format: "00%d", i)
            } else if i < 1000 {
                imageName = NSString(format: "0%d", i)
            } else {
                imageName = NSString(format: "%d", i)
            }
            imageName = "\(fileNamePattern)\(imageName).png"
            var texture = SKTexture(imageNamed: imageName)
            spriteSheetImage.append(texture)
        }
        return spriteSheetImage
    }

}
