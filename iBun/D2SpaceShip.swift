//
//  D2SpaseShip.swift
//  iBun
//
//  Created by h on 12.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2SpaceShip: SKSpriteNode
{
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene) //constructor needs the scene to be able to scale & position the object in the scene
    {
        let texture = SKTexture(imageNamed: "spaceship/spaceship1")
        let size:CGSize = CGSize(width:scene.frame.size.width / 10, height:scene.frame.size.height / 10)
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = CGPoint(x: self.size.width, y: scene.frame.size.height / 2)
    }
}
