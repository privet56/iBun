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
    class func create() -> D3MeNode
    {
        //let meNode = D3MeNode()   //if !gemoetry, no gravitation effects
        let meNode = D3MeNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        meNode.name = "me"
        
        meNode.camera = SCNCamera()

        meNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        meNode.physicsBody?.isAffectedByGravity = true
        meNode.position = SCNVector3Make(0, 5, 10)
        meNode.physicsBody?.mass = 999
        //meNode.physicsBody?.friction =
        
        //meNode.isHidden = true    //if hidden, no gravitation effects
        
        return meNode;
    }
}
