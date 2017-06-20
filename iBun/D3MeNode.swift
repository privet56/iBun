//
//  D3MeNode.swift
//  iBun
//
//  Created by h on 14.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import QuartzCore
import SceneKit

class D3MeNode : SCNNode
{
    override init()
    {
        super.init()
    }
    init(geometry:SCNGeometry?)
    {
        super.init()
        self.geometry = geometry
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    func buildBoundary()
    {
        
    }
    public func rotateMe(right:Bool)
    {
        self.runAction(SCNAction.rotateBy(x:0,y:(right ? -0.333 : 0.333),z:0,duration:1.0));
    }
    func getZForward(m:Float, p:SCNVector3) -> SCNVector3
    {
        var v:SCNVector3 = SCNVector3(self.worldTransform.m31*m, self.worldTransform.m32*m, self.worldTransform.m33*m)
        v.x = p.x - v.x;
        v.y = p.y - v.y;
        v.z = p.z - v.z;
        return v;
    }
    public func move(forward:Bool)
    {
        let forward:SCNVector3 = getZForward(m:1.333,p:self.position);
        self.runAction(SCNAction.move(to: forward, duration: 1.0));
        //self.physicsBody?.velocity = forward;
        //self.physicsBody?.applyForce(forward, asImpulse: false);
    }
    class func create() -> D3MeNode
    {
        //let meNode = D3MeNode()   //if !gemoetry, no gravitation effects
        let meNode = D3MeNode(geometry: SCNBox(width: 3, height: 3, length: 1, chamferRadius: 0))
        meNode.name = "me"
        
        meNode.camera = SCNCamera()

        meNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil) //.static would fall through the floor
        meNode.physicsBody?.isAffectedByGravity  = false
        meNode.position                          = SCNVector3Make(0, 2, 8)
        meNode.physicsBody?.mass                 = 9.9
        meNode.physicsBody?.restitution          = 0.0      //A restitution of 1.0 means that the body loses no energy in a collision, eg. a ball
        meNode.physicsBody?.friction             = 9.0
        //meNode.physicsBody?.categoryBitMask    = Int(Globals.CollisionCategoryEnemy)
        //meNode.physicsBody?.contactTestBitMask = Int(Globals.CollisionCategoryShot)
        //meNode.physicsBody?.collisionBitMask   = 0
        
        //meNode.isHidden = true    //if hidden, no gravitation effects
        
        /*  TODO: fly at the beginning into the scene
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        meNode.position = position
        SCNTransaction.commit()
        */
        
        return meNode;
    }
}
