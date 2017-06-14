//
//  D3Scene.swift
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

class D3Scene : SCNScene
{
    override init()
    {
        super.init()
        
        do
        {   //not needed, as background transparent
            //TODO: use sky with clouds, animate clouds
            //self.background.contents = UIImage(named: "water.gif")
            
            //animated gifs are not supported
            //let path = Bundle.main.path(forResource:"water", ofType:"gif")
            //let url : URL = URL.init(fileURLWithPath: path!)
            //self.background.contents = UIImage.animatedImage(withAnimatedGIFURL:url)
        }

        do
        {
            let floorNode = SCNNode()
            floorNode.geometry = SCNFloor()
            floorNode.geometry?.firstMaterial?.diffuse.contents = "d3.scnassets/hamburger/texture0.jpg"
            floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            self.rootNode.addChildNode(floorNode)
        }
        do
        {
            let environment = UIImage(named: "falling_leaves.1.gif")
            self.lightingEnvironment.contents = environment
            self.lightingEnvironment.intensity = 29.0
        }
        
        physicsWorld.gravity = SCNVector3Make(0.0, -9.0, 0.0);

        do
        {
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            lightNode.light!.type = SCNLight.LightType.spot
            lightNode.light!.castsShadow = true
            lightNode.light!.color = UIColor(white: 0.8, alpha: 1.0)
            lightNode.position = SCNVector3Make(0, 80, 30)
            lightNode.rotation = SCNVector4Make(1, 0, 0, Float(-Double.pi/2.8))
            lightNode.light!.spotInnerAngle = 0
            lightNode.light!.spotOuterAngle = 50
            lightNode.light!.shadowColor = UIColor.black
            lightNode.light!.zFar = 500
            lightNode.light!.zNear = 50
            self.rootNode.addChildNode(lightNode)
        }
        do
        {
            let meNode = D3MeNode.create()
            self.rootNode.addChildNode(meNode)
        }
        
        do
        {
            //let land:D3LandNode = D3LandNode.create()
            //self.rootNode.addChildNode(land)
            let tree:D3TreeNode = D3TreeNode.create()
            self.rootNode.addChildNode(tree)
        }
        
        //rootNode.childNode(withName: "hero", recursively: true)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
}
