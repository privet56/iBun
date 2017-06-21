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

class D3Scene : SCNScene, SCNPhysicsContactDelegate
{
    var d3MeNode:D3MeNode? = nil
    
    override init()
    {
        super.init()
                
        do
        {   //not needed, as background transparent
            //TODO: use sky with clouds, animate clouds
            //self.background.contents = UIImage(named: "water.gif")
        }

        do
        {
            let environment = UIImage(named: "falling_leaves.1.gif")
            self.lightingEnvironment.contents = environment
            self.lightingEnvironment.intensity = 29.0
        }
        
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
            self.d3MeNode = D3MeNode.create()
            self.rootNode.addChildNode(self.d3MeNode!)

            let floorNode = D3LandNode.create();
            self.rootNode.addChildNode(floorNode);

            D3TreeNode.createForest(d3Scene: self);
        }
        
        //rootNode.childNode(withName: "hero", recursively: true)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    public func rotateMe(right:Bool)
    {
        self.d3MeNode?.rotateMe(right:right);
    }
    public func move(forward:Bool)
    {
        self.d3MeNode?.move(forward:forward);
    }
    public func fire()
    {
        self.d3MeNode?.fire(d3Scene:self);
    }
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact)
    {
        let nodeA = contact.nodeA;
        let nodeB = contact.nodeB;
        
        var floor:D3LandNode?   = nil;
        var me:D3MeNode?        = nil;
        var tree:D3TreeNode?    = nil;
        var shot:D3ShotNode?    = nil;
        
        if(nodeA.name == D3LandNode.NAME)           //floor
        {
            floor = nodeA as? D3LandNode;
        }
        else if(nodeB.name == D3LandNode.NAME)
        {
            floor = nodeB as? D3LandNode
        }
        if(nodeA.name == D3MeNode.NAME)             //player
        {
            me = nodeA as? D3MeNode
        }
        else if(nodeB.name == D3MeNode.NAME)
        {
            me = nodeB as? D3MeNode
        }
        if(nodeA.name == D3TreeNode.NAME)           //tree
        {
            tree = nodeA as? D3TreeNode;
        }
        else if(nodeB.name == D3TreeNode.NAME)
        {
            tree = nodeB as? D3TreeNode;
        }
        if(nodeA.name == D3ShotNode.NAME)           //shot
        {
            shot = nodeA as? D3ShotNode;
        }
        else if(nodeB.name == D3ShotNode.NAME)
        {
            shot = nodeB as? D3ShotNode;
        }
        
        if(tree != nil){ tree!.onLanded(); }
        if(shot != nil){ shot!.onCollided()}
        if(me   != nil){ me!.onLanded();   }
        
        if((tree != nil) && (floor != nil))
        {
            return;
        }
        
        if((me != nil) && (tree != nil))
        {
            me!.onCollidedWithTree(tree:tree!);
        }

        print("collided:"+contact.nodeA.name!+" & "+contact.nodeB.name!);
    }
    
    private func sphereNode(pos:SCNVector3) -> SCNNode
    {
        let sphere = SCNSphere(radius: 3.0)
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = pos;
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        sphereNode.geometry?.firstMaterial?.shininess = 91.0
        /*
        sphereNode.position = SCNVector3Make(0, 7, 0);
        do
        {
            sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: sphereNode.geometry!, options: nil));
            sphereNode.physicsBody?.isAffectedByGravity  = true
            sphereNode.physicsBody?.mass                 = 999;
            sphereNode.physicsBody?.restitution          = 0.0;
            sphereNode.physicsBody?.friction             = 999;
            sphereNode.physicsBody?.angularDamping       = 1.0;
            sphereNode.physicsBody?.angularVelocityFactor = SCNVector3(0,0,0)
            sphereNode.physicsBody?.categoryBitMask    = Int(Globals.CollisionCategoryShot)
            sphereNode.physicsBody?.contactTestBitMask = Int(Globals.CollisionCategoryEnemy)
            //sphereNode.physicsBody?.collisionBitMask   = 0    //if you activate this, you fall through the floor!
        }*/
        return sphereNode
    }
}
