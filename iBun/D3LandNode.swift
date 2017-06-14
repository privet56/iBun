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

class D3LandNode : SCNNode
{
    init(scnNode:SCNNode)
    {
        super.init()
        geometry = scnNode.geometry
        position = scnNode.position
        scnNode.childNodes.forEach {
            addChildNode($0)
        }
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    func buildBoundary()
    {
        
    }
    class func create() -> D3LandNode
    {
        let scnNode = Globals.node(name: "d3.scnassets/landscape", ext: "dae", id: "Grid")
        let n = D3LandNode(scnNode:scnNode)
        n.buildBoundary()
        n.name = "floor"
        return n;
    }
}
