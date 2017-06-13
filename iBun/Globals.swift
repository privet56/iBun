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
    class func rand(min:CGFloat, max:CGFloat) -> CGFloat
    {
        return CGFloat(arc4random_uniform(UInt32(max - min)) + UInt32(min));
    }
}
