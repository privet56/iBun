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

class D3MeNode : D3Node
{
    static let NAME = "player";
    
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
        super.init(coder: aDecoder)
    }
    private var m_bOnLandedDone:Bool = false;
    override func onCollided(other:SCNNode?)->Void
    {
        super.onCollided(other: other);
        
        self.stop();

        if(m_bOnLandedDone)
        {
            return;
        }
        m_bOnLandedDone = true;
        self.fromPresentation();
        //print("y1:"+String(self.position.y)+" ? "+String(self.presentation.position.y));
        //self.physicsBody!.isAffectedByGravity  = false;
        //self.physicsBody!.type = .static;
        //let pos = SCNVector3Make(self.presentation.position.x, self.presentation.position.y+1, self.presentation.position.z);
        //self.presentation.position = pos;     //Error: can't set a property on the presentation instance 'player'  | no child> - ignoring
        //self.position = pos;
    }
    public func jump()
    {
        self.stop();
        self.ensureForcePossible();
        self.physicsBody?.applyForce(SCNVector3Make(0, 1111, 0), asImpulse: true);
    }
    
    public func fromPresentation()
    {
        if(self.presentation.position.y >= 0)
        {
            self.position = self.presentation.position;
        }
        else
        {
            self.position = SCNVector3Make(self.presentation.position.x, 1, self.presentation.position.z);
        }
        
        self.rotation = self.presentation.rotation;
    }
    private func ensureForcePossible()
    {
        if(self.physicsBody!.type != .dynamic)
        {
            print("INF: making player dynamic");
            self.physicsBody!.type = .dynamic;
        }
    }/*
    private func getZForward(m:Float, p:SCNVector3) -> SCNVector3
    {
        var v:SCNVector3 = SCNVector3(self.worldTransform.m31*m, self.worldTransform.m32*m, self.worldTransform.m33*m)
        v.x = p.x - v.x;
        //v.y = p.y - v.y;
        v.y = self.presentation.position.y;     //don't change my height over the floor!
        v.z = p.z - v.z;
        return v;
    }*/
    private func stop()
    {
        self.removeAllActions();
        self.physicsBody?.clearAllForces();
        self.physicsBody?.velocity = SCNVector3Make(0, 0, 0);
        self.physicsBody?.angularVelocity = SCNVector4Make(0, 0, 0, 0);
    }
    private func rotateMeByAction(right:Bool) -> Void
    {
        self.stop();
        //self.fromPresentation();
        let y:CGFloat = (right ? -0.333 : 0.333);
        //print("rotByAction right:"+String(describing: right)+" curRot: x:"+String(self.rotation.x)+" y:"+String(self.rotation.y)+" z:"+String(self.rotation.z)+" w:"+String(self.rotation.w));
        self.runAction(SCNAction.rotateBy(x:0,y:y,z:0,duration:1.0));
    }
    private func rotateMeByForce(right:Bool) -> Void
    {
        //fromPresentation();
        self.stop();
        self.ensureForcePossible();
        let y4:Float = (right ? -3.333 : 3.333);
        let v4:SCNVector4 = SCNVector4Make(0, y4, 0, 0.0);
        self.physicsBody?.applyTorque(v4, asImpulse: true);     //TODO: make it working!
        //print("rotByForce right:"+String(describing: right));
    }
    public func rotateMe(right:Bool) -> Void
    {
        let bUseTheForce:Bool = false;
        if(!bUseTheForce){  self.rotateMeByAction(right: right);}
        else{               self.rotateMeByForce( right: right);}
    }
    private func moveByAction(forward:Bool)
    {   //works!
        let forward:SCNVector3 = self.getZForward(m:(forward ? 1.333 : -1.333),p:self.position);
        self.runAction(SCNAction.move(to: forward, duration: 1.0));
        //print("moveByAction forward:"+String(describing: forward));
    }
    private func moveByForce(forward:Bool)
    {   //works!
        self.ensureForcePossible();
        let factor:Float = 133.3;
        let forward:SCNVector3 = getZForward(m:(forward ? factor : -factor),p:self.position);
        self.physicsBody?.applyForce(forward, asImpulse: false);
        //print("moveByForce forward:"+String(describing: forward));
    }
    public func move(forward:Bool)
    {
        let bUseTheForce:Bool = true;
        if(!bUseTheForce){  self.moveByAction(forward: forward); }
        else             {  self.moveByForce( forward: forward); }
    }
    public func onCollidedWithTree(tree:D3TreeNode)
    {
        self.stop();
        self.move(forward: false);
    }
    class func create() -> D3MeNode
    {
        //let meNode = D3MeNode()   //if !gemoetry, no gravitation effects
        let meNode = D3MeNode(geometry: SCNBox(width: 1, height: 3, length: 1, chamferRadius: 0))
        meNode.name = D3MeNode.NAME;
        
        meNode.camera = SCNCamera();
        meNode.physicsBody = D3Node.createBody(sType: D3MeNode.NAME, type:.dynamic, geo: meNode.geometry!);
        
        //which categories this physics body belongs to
        meNode.physicsBody?.categoryBitMask    = Int(Globals.CollisionCategoryPlayer)
        //which categories of bodies cause intersection notifications with this physics body
        meNode.physicsBody?.contactTestBitMask = Int(Globals.CollisionCategoryTree | Globals.CollisionCategoryFloor)
        //if you set 0 on this, you fall through the floor!
        //which categories of physics bodies can collide with this physics body.
        //n.physicsBody?.collisionBitMask   = 0;
        
        //meNode.isHidden = true    //if hidden, no gravitation effects
        
        /*  TODO: fly at the beginning into the scene
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        meNode.position = position
        SCNTransaction.commit()
        */
        
        let pos = SCNVector3Make(0, 9, 0);
        meNode.position = pos;
        
        return meNode;
    }
    public func fire(d3Scene:D3Scene)
    {
        //self.fromPresentation();
        let d3ShotNode:D3ShotNode = D3ShotNode.create(pos:self.position, rot:self.rotation);
        d3Scene.rootNode.addChildNode(d3ShotNode);
        d3ShotNode.fire();
    }
}
