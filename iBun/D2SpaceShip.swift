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
        
        let texture = SKTexture(imageNamed: "spaceship1")
        let size:CGSize = CGSize(width:scene.frame.size.width / 5, height:scene.frame.size.height / 5)
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = CGPoint(x: self.size.width / 2, y: scene.frame.size.height / 2)
        
        /*var timer = */Timer.scheduledTimer(timeInterval: 9.00, target: self, selector: #selector(D2SpaceShip.changeBkg), userInfo: nil, repeats: true)
        self.changeBkg()
        
        do
        {
            let moveUp          = SKAction.moveTo(y: 0, duration: 3.0)
            let moveDown        = SKAction.moveTo(y: scene.frame.size.height, duration: 2.0)
            let actionSequence  = SKAction.sequence([moveUp, moveDown])
            let moveAction      = SKAction.repeatForever(actionSequence)
            self.run(moveAction)
        }
        
        self.isUserInteractionEnabled = true
    }
    @objc func changeBkg()
    {
        let min:UInt32 = 1
        let max:UInt32 = 6
        let val = Int(arc4random_uniform(max) + min)

        let texture:SKTexture = SKTexture(imageNamed:"spaceship"+String(val));
        let changeFace:SKAction = SKAction.setTexture(texture); //this action cannot animate!
        self.run(changeFace);
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let shot:D2Shot = D2Shot(scene:self.scene!, spaceship:self)
        scene!.addChild(shot)
    }
}
