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
            let path = Bundle.main.path(forResource:"d3.scnassets/landscape", ofType:"dae")
            let url : URL = URL.init(fileURLWithPath: path!)
            //[SceneKit] Error: COLLADA files are not supported on this platform  ===>  put your dae files into scnassets!
            let sceneSource = SCNSceneSource.init(url: url, options: nil)
            let node = sceneSource?.entryWithIdentifier("Grid", withClass:SCNNode.self);    //<geometry id="Grid-mesh" name="Grid">
            node?.name = "floor"
            do
            {
                //this node has no materials yet
                node?.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                node?.geometry?.firstMaterial?.shininess = 1.0
            }
            do
            {
                var materials = [SCNMaterial]()
                let material = SCNMaterial()
                material.diffuse.contents = UIImage.init(named:"meadow/meadow2.gif")
                materials.append(material)
                node?.geometry?.materials = materials
            }
            node?.physicsBody = SCNPhysicsBody(type: .static, shape: nil/*SCNPhysicsShape*/)
            self.rootNode.addChildNode(node!)
        }
        
        //rootNode.childNode(withName: "hero", recursively: true)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
}
