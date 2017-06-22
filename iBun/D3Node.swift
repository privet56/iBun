//
//  D3Node.swift
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

class D3Node : SCNNode
{
    override init()
    {
        super.init()
    }

    init(scnNode:SCNNode)
    {
        super.init()
        
        geometry = scnNode.geometry;
        position = scnNode.position;
        physicsBody = scnNode.physicsBody;
        name = scnNode.name;
        
        scnNode.childNodes.forEach
        {
            addChildNode($0)
        }
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    public func onCollided(other:SCNNode?)->Void
    {
        
    }
    internal func getZForward(m:Float, p:SCNVector3) -> SCNVector3
    {
        var v:SCNVector3 = SCNVector3(self.worldTransform.m31*m, self.worldTransform.m32*m, self.worldTransform.m33*m)
        v.x = p.x - v.x;
        //v.y = p.y - v.y;
        v.y = self.presentation.position.y;     //don't change my height over the floor!
        v.z = p.z - v.z;
        return v;
    }
    class func createBody(sType:String, type:SCNPhysicsBodyType,geo:SCNGeometry) -> SCNPhysicsBody
    {
        //.static = no gravity effect, no forces
        let type:SCNPhysicsBodyType = (sType == D3LandNode.NAME) ? .static : .dynamic;
        
        let pb : SCNPhysicsBody = SCNPhysicsBody(type: type, shape: SCNPhysicsShape(geometry:geo, options: nil));
        
        pb.restitution              = 0.0;              //A restitution of 1.0 means that the body loses no energy in a collision, eg. a ball
                                                        //object won't bounce
        pb.angularVelocityFactor    = SCNVector3Zero    //=SCNVector3(0,0,0)    = avoid rotation
        
        switch sType
        {
            case D3LandNode.NAME:
                pb.isAffectedByGravity  = false
                break;
            case D3TreeNode.NAME:
                pb.isAffectedByGravity  = true
                pb.mass                 = 999
                pb.friction             = 999
                pb.angularDamping       = 1.0
                break;
            case D3MeNode.NAME:
                pb.isAffectedByGravity  = true
                pb.mass                 = 0.9
                pb.friction             = 0.9
                pb.angularDamping       = 1.0
                break;
            case D3ShotNode.NAME:
                pb.isAffectedByGravity  = false
                pb.mass                 = 0.0
                pb.friction             = 0.0
                pb.angularDamping       = 0.0
                break;
            default:
                print("D3Node.createBody: ERR: unknown type");
        }
        
        return pb;
    }
}
