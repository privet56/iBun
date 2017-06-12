//
//  D2Shot.swift
//  iBun
//
//  Created by h on 12.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2Shot: SKSpriteNode
{
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene, spaceship:D2SpaceShip) //constructor needs the scene to be able to scale & position the object in the scene
    {
        let texture = SKTexture(imageNamed: "carrot")
        let size:CGSize = CGSize(width:scene.frame.size.width / 20, height:scene.frame.size.height / 30)
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = spaceship.position
        
        do
        {
            let moveRight = SKAction.moveTo(x: scene.frame.size.width + self.size.width, duration: 3.0)
            self.run(moveRight, completion:
            {
                self.removeFromParent()
            })
        }
    }
}
