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

        /*do
        {   //not needed as we do the floor better!
            let floorNode = SCNNode()
            floorNode.geometry = SCNFloor()
            floorNode.geometry?.firstMaterial?.diffuse.contents = "fox"
            self.rootNode.addChildNode(floorNode)
        }*/
        do
        {
            let environment = UIImage(named: "falling_leaves.1.gif")
            self.lightingEnvironment.contents = environment
            self.lightingEnvironment.intensity = 29.0
        }
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
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x:0, y:0, z:5.5);
            self.rootNode.addChildNode(cameraNode)
        }
        
        do
        {
            let land:D3LandNode = D3LandNode.create()
            do
            {
                var materials = [SCNMaterial]()
                let material = SCNMaterial()
                //material.diffuse.contents = UIImage.init(named:"meadow/meadow2.gif")
                material.diffuse.contents = UIImage.init(named:"d3.scnassets/hamburger/texture0.jpg")
                materials.append(material)
                land.geometry?.materials = materials
            }
            land.physicsBody = SCNPhysicsBody(type: .static, shape: nil/*SCNPhysicsShape*/)
            self.rootNode.addChildNode(land)
            do
            {
                let path = Bundle.main.path(forResource:"d3.scnassets/tree", ofType:"dae")
                let url : URL = URL.init(fileURLWithPath: path!)
                let sceneSource = SCNSceneSource.init(url: url, options: nil)
                let tree = sceneSource?.entryWithIdentifier("Cylinder", withClass:SCNNode.self);
                tree?.name = "tree"
                tree?.physicsBody = SCNPhysicsBody(type: .static, shape: nil/*SCNPhysicsShape*/)
                self.rootNode.addChildNode(tree!)
            }
        }
        
        //rootNode.childNode(withName: "hero", recursively: true)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
}
