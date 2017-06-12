//
//  D2Scene.swift
//  iBun
//
//  Created by h on 12.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2Scene: SKScene
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    override init(size: CGSize)
    {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        do
        {
            let scoreLabel = D2ScoreLabel(fontNamed:nil, scene:self)
            addChild(scoreLabel)
        }
        do
        {
            let spaceship:D2SpaceShip = D2SpaceShip(scene:self)
            addChild(spaceship)
        }
    }
}
