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
    static let NAME = "player";
    
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
    func onLanded()->Void
    {
        if(self.physicsBody!.isAffectedByGravity == false)
        {
            return;
        }
            
        //print("y1:"+String(self.position.y)+" ? "+String(self.presentation.position.y));
        self.physicsBody!.isAffectedByGravity  = false;
        //self.physicsBody!.type = .static;
        let pos = SCNVector3Make(self.presentation.position.x, self.presentation.position.y+1, self.presentation.position.z);
        self.position = pos;
    }

    public func rotateMe(right:Bool)
    {
        //let y:Float = (right ? -0.333 : 0.333);
        //self.runAction(SCNAction.rotateBy(x:0,y:y,z:0,duration:1.0));
        
        let y4:Float = (right ? -3.333 : 3.333);
        let v4:SCNVector4 = SCNVector4Make(0, y4, 0, 1);
//TODO: rotate by applying force!
        self.physicsBody?.applyTorque(v4, asImpulse: true);
    }
    func getZForward(m:Float, p:SCNVector3) -> SCNVector3
    {
        var v:SCNVector3 = SCNVector3(self.worldTransform.m31*m, self.worldTransform.m32*m, self.worldTransform.m33*m)
        v.x = p.x - v.x;
        //v.y = p.y - v.y;  //don't change my height over the floor!
        v.z = p.z - v.z;
        return v;
    }
    public func move(forward:Bool)
    {
        let forward:SCNVector3 = getZForward(m:(forward ? 1.333 : -1.333),p:self.position);
        //self.runAction(SCNAction.move(to: forward, duration: 1.0));
        self.physicsBody?.applyForce(forward, asImpulse: true);
    }
    public func onCollidedWithTree(tree:D3TreeNode)
    {
        self.removeAllActions();
        self.physicsBody?.clearAllForces();
        self.move(forward: false);
    }
    class func create() -> D3MeNode
    {
        //let meNode = D3MeNode()   //if !gemoetry, no gravitation effects
        let meNode = D3MeNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        meNode.name = D3MeNode.NAME;
        
        meNode.camera = SCNCamera();
        let shape:SCNPhysicsShape = SCNPhysicsShape(geometry: meNode.geometry!, options: nil);
        meNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape);
        meNode.physicsBody?.isAffectedByGravity  = true
        meNode.physicsBody?.mass                 = 0.9
        meNode.physicsBody?.restitution          = 0.0
        meNode.physicsBody?.friction             = 999
        meNode.physicsBody?.angularDamping       = 1.0
        meNode.physicsBody?.angularVelocityFactor = SCNVector3(0,0,0)
        
        //which categories this physics body belongs to
        meNode.physicsBody?.categoryBitMask    = Int(Globals.CollisionCategoryPlayer)
        //which categories of bodies cause intersection notifications with this physics body
        meNode.physicsBody?.contactTestBitMask = Int(Globals.CollisionCategoryTree | Globals.CollisionCategoryFloor)
        //if you set 0 on this, you fall through the floor!
        //which categories of physics bodies can collide with this physics body.
        //n.physicsBody?.collisionBitMask   = 0;
        
        //meNode.isHidden = true    //if hidden, no gravitation effects
        
        /*  TODO: fly at the beginning into the scene
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        meNode.position = position
        SCNTransaction.commit()
        */
        
        let pos = SCNVector3Make(0, 33, 0);
        meNode.position = pos;
        
        return meNode;
    }
}
