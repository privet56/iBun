//
//  D3Shot.swift
//  iBun
//
//  Created by h on 21.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import QuartzCore
import SceneKit

class D3ShotNode : D3Node
{
    static let NAME = "shot";
    
    override init()
    {
        super.init()
    }
    
    override init(scnNode:SCNNode)
    {
        super.init(scnNode:scnNode)
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    func onCollided()->Void
    {
        print("TODO: explode!");
    }
    func fire()
    {
        let height:Float = 0.75;
        self.position.y = height;
        
        var forward:SCNVector3 = self.getZForward(m:6,p:self.position);
        forward.y = self.position.y;
        //print("shoty-start:"+String(self.position.y)+" = "+String(self.presentation.position.y));
        self.runAction(SCNAction.move(to: forward, duration: 3), completionHandler:
        {
            //print("shoty-end:::"+String(self.position.y)+" = "+String(self.presentation.position.y));
            self.removeFromParentNode();
        });
    }
    
    class func create(pos:SCNVector3, rot:SCNVector4) -> D3ShotNode
    {
        let sphereGeometry = SCNSphere(radius: 0.03);
        let scnNode:SCNNode = SCNNode(geometry: sphereGeometry);
        scnNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        scnNode.geometry?.firstMaterial?.shininess = 91.0

        let n = D3ShotNode(scnNode:scnNode);
        n.name = D3ShotNode.NAME;
        
        let shape:SCNPhysicsShape = SCNPhysicsShape(geometry: n.geometry!, options: nil);
        
        n.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape);

        n.physicsBody?.isAffectedByGravity  = false
        n.physicsBody?.mass                 = 0.0
        n.physicsBody?.restitution          = 0.0
        n.physicsBody?.friction             = 0.0
        n.physicsBody?.angularDamping       = 0.0
        n.physicsBody?.angularVelocityFactor = SCNVector3(0,0,0)
        //which categories this physics body belongs to
        n.physicsBody?.categoryBitMask    = Int(Globals.CollisionCategoryShot)
        //which categories of bodies cause intersection notifications with this physics body
        n.physicsBody?.contactTestBitMask = Int(Globals.CollisionCategoryTree)
        //if you set 0 on this, you fall through the floor!
        //which categories of physics bodies can collide with this physics body.
        //n.physicsBody?.collisionBitMask   = 0;
        
        n.position = pos;
        n.rotation = rot;

        return n;
    }
}
