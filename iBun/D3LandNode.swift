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
    static let NAME = "floor";
    
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
        let floor = SCNFloor()
        floor.reflectivity = 1.0
        floor.reflectionFalloffEnd = 1
        let fn = "buns/autumn01.png"//"meadow/meadow3.gif";
        let floorNode = SCNNode();
        floorNode.geometry = floor;
        floorNode.name = D3LandNode.NAME;
        floorNode.geometry?.firstMaterial?.diffuse.contents = fn;
        floorNode.geometry?.firstMaterial!.diffuse.wrapS            = SCNWrapMode.repeat
        floorNode.geometry?.firstMaterial!.diffuse.wrapT            = SCNWrapMode.repeat
        floorNode.geometry?.firstMaterial!.diffuse.mipFilter        = SCNFilterMode.linear
        
        let noiseTexture = SKTexture(noiseWithSmoothness: 0.0, size: CGSize(width: 200, height: 200), grayscale: false);
        let noiseNormalMapTexture = noiseTexture.generatingNormalMap(withSmoothness: 0.1, contrast: 1.0);
        
        floorNode.geometry?.firstMaterial?.normal.contents         = noiseNormalMapTexture;
        floorNode.geometry?.firstMaterial!.normal.wrapS            = SCNWrapMode.repeat
        floorNode.geometry?.firstMaterial!.normal.wrapT            = SCNWrapMode.repeat
        floorNode.geometry?.firstMaterial!.normal.mipFilter        = SCNFilterMode.linear
        
        floorNode.geometry?.firstMaterial!.shininess = 0.0
        floorNode.geometry?.firstMaterial!.locksAmbientWithDiffuse  = true
        
        let n = D3LandNode(scnNode:floorNode);
        n.name = D3LandNode.NAME;
        
        n.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry:floor, options: nil))
        n.physicsBody?.restitution = 0.0;   //A restitution of 1.0 means that the body loses no energy in a collision, eg. a ball
        
        //which categories this physics body belongs to
        n.physicsBody?.categoryBitMask    = Int(Globals.CollisionCategoryFloor)
        //which categories of bodies cause intersection notifications with this physics body
        //n.physicsBody?.contactTestBitMask =
        //which categories of physics bodies can collide with this physics body.
        n.physicsBody?.collisionBitMask = Int(Globals.CollisionCategoryPlayer | Globals.CollisionCategoryTree)
        
        return n;
    }
}
