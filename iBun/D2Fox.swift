//
//  D2Fox.swift
//  iBun
//
//  Created by h on 12.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2Fox: SKSpriteNode
{
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene) //constructor needs the scene to be able to scale & position the object in the scene
    {
        let texture = SKTexture(imageNamed: "fox")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        var x = scene.size.width - self.frame.width
        do
        {
            let min:UInt32 = UInt32((x / 10) * 8)
            let max:UInt32 = UInt32((x))
            x = CGFloat(arc4random_uniform(max - min) + min)
        }
        var y:CGFloat = 0
        do
        {
            let min:UInt32 = UInt32(y)
            let max:UInt32 = UInt32(scene.frame.size.height - texture.size().height)
            y = CGFloat(arc4random_uniform(max - min) + min)
        }

        self.position = CGPoint(x: x, y: y)

        do
        {
            let moveUp          = SKAction.moveTo(y: 0, duration: TimeInterval(Globals.rand(min:2.0, max:6.0)))
            let moveDown        = SKAction.moveTo(y: scene.frame.size.height, duration: TimeInterval(Globals.rand(min:2.0, max:6.0)))
            let actionSequence  = SKAction.sequence([moveUp, moveDown])
            let moveAction      = SKAction.repeatForever(actionSequence)
            self.run(moveAction)
        }
    }
}
