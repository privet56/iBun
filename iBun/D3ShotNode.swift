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
    override func onCollided(d3Scene:D3Scene, other:SCNNode?, contactPoint:SCNVector3)->Void
    {
        super.onCollided(d3Scene:d3Scene, other: other, contactPoint: contactPoint);
        //self.stop();
        //self.explode(d3Scene: d3Scene, pos:contactPoint);
        if(self.parent != nil)
        {
            self.removeFromParentNode();
        }
    }
    func fire()
    {
        let height:Float = 0.75;
        self.position.y = height;
        
        var forward:SCNVector3 = self.getZForward(m:33,p:self.position);
        forward.y = self.position.y;
        self.runAction(SCNAction.move(to: forward, duration: 9), completionHandler:
        {
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

    //is lazy initialized!
    static let SHOTBLUEPRINT:SCNNode = D3ShotNode.createBlueprint();
    
    class func create(pos:SCNVector3, rot:SCNVector4) -> D3ShotNode
    {
        let n = D3ShotNode(scnNode:D3ShotNode.SHOTBLUEPRINT);
        n.physicsBody = D3Node.createBody(sType: D3ShotNode.NAME, type:.dynamic, geo: n.geometry!);
        
        n.position = pos;
        n.rotation = rot;

        return n;
    }
}
