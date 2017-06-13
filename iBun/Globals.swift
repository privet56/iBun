//
//  Globals.swift
//  iBun
//
//  Created by h on 13.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class Globals
{
    static let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    static let CollisionCategoryShot   : UInt32 = 0x1 << 2
    static let CollisionCategoryEnemy  : UInt32 = 0x1 << 3
    
    class func rand(min:CGFloat, max:CGFloat) -> CGFloat
    {
        return CGFloat(arc4random_uniform(UInt32(max - min)) + UInt32(min));
    }
}
