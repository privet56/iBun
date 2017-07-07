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
    var d2Controller:D2Controller? = nil
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    init(size: CGSize, d2Controller:D2Controller)
    {
        super.init(size: size)
        
        self.d2Controller = d2Controller
        
        self.isUserInteractionEnabled = true
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0);
        physicsWorld.contactDelegate = self
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        
        do
        {
            let backLabel = D2Back(scene:self, viewController:self.d2Controller!, onPressed:nil)
            addChild(backLabel)

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
        
        if(Globals.DEVELOPERMODE)
        {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 1,
                execute:
                {_ in
                    self.enemiesDestroyed();
                }
            );
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
    
    func enemiesDestroyed()
    {
        let transition = SKTransition.fade(withDuration: 2.0)
        let sceneTwo = D2SceneFinish(size: size, d2Controller:self.d2Controller!)
        view?.presentScene(sceneTwo, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //print("on scene")
    }
}
