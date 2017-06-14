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
    class func create() -> D3TreeNode
    {
        let scnNode = Globals.node(name: "d3.scnassets/tree", ext: "dae", id: "Cylinder")
        let n = D3TreeNode(scnNode:scnNode)
        n.name = "tree";
        
        //let shape = SCNPhysicsShape(geometry: n.geometry!, options: nil)
        n.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        n.physicsBody?.isAffectedByGravity = true
        n.position = SCNVector3Make(0, 5, 0)
        n.physicsBody?.mass = 9
        
        return n;
    }
}
