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
    static let colliderName : String = "shot"
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene, spaceship:D2SpaceShip) //constructor needs the scene to be able to scale & position the object in the scene
    {
        let texture = SKTexture(imageNamed: "spaceship/spaceship6")
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
        
        do
        {   //TODO: edit the sks file in the xcode editor when it's not crashing anymore!
            let pathToEmitter = Bundle.main.path(forResource: "FireParticle", ofType: "sks")
            let emitter = NSKeyedUnarchiver.unarchiveObject(withFile: pathToEmitter!) as? SKEmitterNode
            emitter!.zRotation = CGFloat(Double.pi/2.0);
            emitter!.particlePositionRange = CGVector(dx: emitter!.particlePositionRange.dx / 32, dy: emitter!.particlePositionRange.dy / 16)
            emitter!.particleScale = 0.3;
            emitter!.particleScaleRange = 0.2;
            emitter!.particleScaleSpeed = -0.1;
            
            self.addChild(emitter!)
            emitter!.position = CGPoint(x: -19, y: 0)
        }
        do
        {
            self.name = D2Shot.colliderName
            physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
            physicsBody?.isDynamic          = true
            physicsBody?.linearDamping      = 1.0
            physicsBody?.allowsRotation     = true
            physicsBody?.categoryBitMask    = Globals.CollisionCategoryShot
            physicsBody?.contactTestBitMask = Globals.CollisionCategoryEnemy// | Globals.CollisionCategoryPlayer
            physicsBody?.collisionBitMask   = 0
            self.physicsBody = physicsBody
        }
    }
}
