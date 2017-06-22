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
    override func onCollided(other:SCNNode?)->Void
    {
        super.onCollided(other: other);
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
    
    class func createBlueprint() -> SCNNode
    {
        let sphereGeometry  = SCNSphere(radius: 0.03);
        let scnNode:SCNNode = SCNNode(geometry: sphereGeometry);
        scnNode.name        = D3ShotNode.NAME;
        scnNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        scnNode.geometry?.firstMaterial?.shininess = 91.0;
        //TODO: make more realistic
        return scnNode;
    }
    
    static let SHOTBLUEPRINT:SCNNode = D3ShotNode.createBlueprint();
    
    class func create(pos:SCNVector3, rot:SCNVector4) -> D3ShotNode
    {
        let n = D3ShotNode(scnNode:D3ShotNode.SHOTBLUEPRINT);
        
        n.physicsBody = D3Node.createBody(sType: D3ShotNode.NAME, type:.dynamic, geo: n.geometry!);
        
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
