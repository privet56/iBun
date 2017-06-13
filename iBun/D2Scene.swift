//
//  D2Scene.swift
//  iBun
//
//  Created by h on 12.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2Scene: SKScene, SKPhysicsContactDelegate
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    override init(size: CGSize)
    {
        super.init(size: size)
        
        self.isUserInteractionEnabled = true
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0);
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        do
        {
            let scoreLabel = D2ScoreLabel(fontNamed:nil, scene:self)
            addChild(scoreLabel)

            let spaceship:D2SpaceShip = D2SpaceShip(scene:self)
            addChild(spaceship)
            
            for _ in 0 ... 2
            {
                let fox:D2Fox = D2Fox(scene:self)
                scene!.addChild(fox)
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        let nodeA = contact.bodyA.node!
        let nodeB = contact.bodyB.node!
        
        var fox:D2Fox? = nil
        var shot:D2Shot? = nil
        
        if(nodeA.name == D2Fox.colliderName)
        {
            fox = nodeA as? D2Fox
        }
        else if(nodeB.name == D2Fox.colliderName)
        {
            fox = nodeB as? D2Fox
        }
        if(nodeA.name == D2Shot.colliderName)
        {
            shot = nodeA as? D2Shot
        }
        else if(nodeB.name == D2Shot.colliderName)
        {
            shot = nodeB as? D2Shot
        }
        if(fox == nil) {return}
        if(shot == nil) {return}
        
        shot?.removeFromParent()
        fox?.explode()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //print("on scene")
    }
}
