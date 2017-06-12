//
//  D2ScoreLabel.swift
//  iBun
//
//  Created by h on 12.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2ScoreLabel: SKLabelNode
{
    override init()
    {
        super.init()
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(fontNamed:String?, scene:SKScene) //constructor needs the scene to be able to scale & position the object in the scene
    {
        super.init(fontNamed: (fontNamed == nil ? "Copperplate" : fontNamed))
        
        self.text = "Score : 0";
        self.fontSize = 40;
        self.horizontalAlignmentMode = .left
        
        self.position = CGPoint(x: 0, y: scene.size.height - self.frame.size.height)
    }
}
