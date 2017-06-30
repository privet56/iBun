//
//  D3LScene.swift
//  iBun
//
//  Created by h on 29.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import QuartzCore
import SceneKit

class D3LScene : D3Scene//, SCNPhysicsContactDelegate
{
    override init()
    {
        super.init();
    }
    override func initWorld()
    {
        self.physicsWorld.gravity = SCNVector3Make(0.0, -99.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
        do  //LIGHTS
        {
            do
            {
                let ambientLight = SCNLight()
                ambientLight.type = SCNLight.LightType.ambient
                ambientLight.color = UIColor(white: 0.65, alpha: 1.0)
                let ambientLightNode = SCNNode()
                ambientLightNode.light = ambientLight
                self.rootNode.addChildNode(ambientLightNode)
            }
            let sunPos = SCNVector3Make(0, 7, 30);
            self.rootNode.addChildNode(self.sphereNode(pos:sunPos))
            
            let lightNode = SCNNode()
            lightNode.light = SCNLight()
            
            let bUseSpotLight:Bool = false;
            if( bUseSpotLight)
            {
                lightNode.light!.type = SCNLight.LightType.spot
                lightNode.rotation = SCNVector4Make(0, 0, 0, 0)
                lightNode.light!.spotInnerAngle = 0
                lightNode.light!.spotOuterAngle = 950
                lightNode.light!.zFar = 500
                lightNode.light!.zNear = 50
                self.rootNode.addChildNode(lightNode)
            }
            else
            {
                lightNode.light!.type = SCNLight.LightType.directional
                lightNode.rotation = SCNVector4Make(1, 0, 0, Float(-Double.pi/2.8))
            }
            
            lightNode.light!.color = UIColor(white: 0.8, alpha: 1.0)
            lightNode.light!.castsShadow = true
            lightNode.position = sunPos
            lightNode.light!.shadowColor = UIColor.green
            self.rootNode.addChildNode(lightNode)
        }
        do
        {
            self.fogStartDistance = 30
            self.fogEndDistance = 90
            self.fogColor = UIColor.white
        }
        do
        {
            self.d3MeNode = D3MeNode.create()
            self.rootNode.addChildNode(self.d3MeNode!)
            let floorNode = D3LandNode.create();
            self.rootNode.addChildNode(floorNode);
            D3LLandNode.create(scene:self);
            let leaNode = D3Lea.create(scene:self);
            let leaPos = SCNVector3Make(0, -1.5, -30/*in front of me*/);
            leaNode.position = leaPos;
            self.rootNode.addChildNode(leaNode);
        }
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    public override func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact)
    {
        let nodeA = contact.nodeA;
        let nodeB = contact.nodeB;
        
        if((nodeA is D3Node) && (nodeB is D3Node))
        {
            let contactPoint:SCNVector3 = contact.contactPoint;
            (nodeA as! D3Node).onCollided(d3Scene: self, other: nodeB, contactPoint:contactPoint);
            (nodeB as! D3Node).onCollided(d3Scene: self, other: nodeA, contactPoint:contactPoint);
        }
        
        //print("collided:"+contact.nodeA.name!+" & "+contact.nodeB.name!);
    }
}
