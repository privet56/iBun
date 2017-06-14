//
//  D3LandNode.swift
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

class D3LandNode : D3Node
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
    class func create() -> D3LandNode
    {
        let scnNode = Globals.node(name: "d3.scnassets/landscape", ext: "dae", id: "Grid")
        let n = D3LandNode(scnNode:scnNode)
        n.name = "floor";
        
        do
        {
            var materials = [SCNMaterial]()
            let material = SCNMaterial()
            material.diffuse.contents = UIImage.init(named:"d3.scnassets/hamburger/texture0.jpg")
            materials.append(material)
            n.geometry?.materials = materials
        }
        
        //let shape = SCNPhysicsShape(geometry: n.geometry!, options: nil)
        n.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        
        n.buildBoundary()
        
        return n;
    }
}
