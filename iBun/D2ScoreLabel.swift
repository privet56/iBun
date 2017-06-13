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
    var score:UInt32 = 0
    static let colliderName : String = "score"
    
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
        self.horizontalAlignmentMode = .right
        
        self.position = CGPoint(x: scene.size.width, y: scene.size.height - self.frame.size.height)
        self.name = D2ScoreLabel.colliderName
    }
    
    func enemyDestroyed()
    {
        self.score += 1
        self.text = "Score : "+String(self.score);
    }
}
