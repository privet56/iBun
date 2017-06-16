//
//  D3TreeNode.swift
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

class D3TreeNode : D3Node
{
    override init(scnNode:SCNNode)
    {
        super.init(scnNode:scnNode)
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    func buildBoundary()
    {
        
    }
    class func create(p:SCNVector3) -> D3TreeNode
    {
        let scnNode = Globals.node(name: "d3.scnassets/tree", ext: "dae", id: "Cylinder")
        let n = D3TreeNode(scnNode:scnNode)
        n.name = "tree";

        n.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        n.physicsBody?.isAffectedByGravity  = true
        n.physicsBody?.mass                 = 9
        n.physicsBody?.restitution          = 1.0
        n.physicsBody?.friction             = 991.0
        n.physicsBody?.angularDamping = 1.0
        n.physicsBody?.angularVelocityFactor = SCNVector3(0,0,0)
        
        let s:Float = 0.75
        n.scale = SCNVector3(x: s, y: s, z: s);
        
        n.position = p;
        
        return n;
    }
    
    class func createForest(d3Scene:D3Scene, x:Int) -> Void
    {
        var i:Int = -36;
        while(i <= 33)
        {
            i += 6
            if(i >= -3) && (i <= 3){continue}
            
            do
            {
                let p:SCNVector3 = SCNVector3Make(Float(x), 5, Float(i));
                let d3TreeNode:D3TreeNode = D3TreeNode.create(p: p)
                d3Scene.rootNode.addChildNode(d3TreeNode);
            }
        }
    }
    
    class func createForest(d3Scene:D3Scene) -> Void
    {
        var i:Int = -36;
        while(i <= 33)
        {
            i += 6
            if(i >= -3) && (i <= 3){continue}
            D3TreeNode.createForest(d3Scene: d3Scene, x: i)
            
            do
            {
                let p:SCNVector3 = SCNVector3Make(Float(i), 5, 0);
                let d3TreeNode:D3TreeNode = D3TreeNode.create(p: p)
                d3Scene.rootNode.addChildNode(d3TreeNode);
            }
        }
    }
}
