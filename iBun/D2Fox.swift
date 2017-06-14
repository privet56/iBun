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
    static let colliderName : String = "fox"
    
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
        do
        {
            self.name = D2Fox.colliderName
            physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2)
            physicsBody?.isDynamic          = false
            physicsBody?.linearDamping      = 1.0
            physicsBody?.allowsRotation     = true
            physicsBody?.categoryBitMask    = Globals.CollisionCategoryEnemy
            physicsBody?.contactTestBitMask = Globals.CollisionCategoryShot
            physicsBody?.collisionBitMask   = 0
            self.physicsBody = physicsBody
        }
    }
    func explode()
    {
        let pathToEmitter = Bundle.main.path(forResource: "FireParticle", ofType: "sks")
        let emitter = NSKeyedUnarchiver.unarchiveObject(withFile: pathToEmitter!) as? SKEmitterNode
        
        //emitter!.zRotation = CGFloat(Double.pi/2.0);
        //emitter!.particlePositionRange = CGVector(dx: emitter!.particlePositionRange.dx / 32, dy: emitter!.particlePositionRange.dy / 16)
        //emitter!.particleScale = 0.3;
        //emitter!.particleScaleRange = 0.2;
        //emitter!.particleScaleSpeed = -0.1;
        emitter!.emissionAngle = 1.0
        emitter!.particleBirthRate = emitter!.particleBirthRate / 9
        
        self.addChild(emitter!)
        emitter!.position = CGPoint(x: 0, y: 0)
        
        do
        {
            let rot = SKAction.rotate(byAngle: 360, duration: 0.5)
            let rotForever = SKAction.repeatForever(rot)
            self.run(rotForever)
        }
        
        /*var timer = */Timer.scheduledTimer(timeInterval: 2.99, target: self, selector: #selector(D2Fox.explodeFinish), userInfo: nil, repeats: false)
    }
    func explodeFinish()
    {
        self.scene?.enumerateChildNodes(withName: D2ScoreLabel.colliderName, using:
        {
            node, stop in
            
            (node as? D2ScoreLabel)?.enemyDestroyed()
        })
        
        do
        {
            var iFoxes:Int = 0;
            self.scene?.enumerateChildNodes(withName: D2Fox.colliderName, using:
            {
                node, stop in
                iFoxes += 1
            })
            if(iFoxes < 2)
            {
                (self.scene as? D2Scene)?.enemiesDestroyed()
            }
        }

        self.removeFromParent()
    }
}
