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
    func explode(d3Scene:D3Scene, pos:SCNVector3)
    {
        let pathToEmitter = Bundle.main.path(forResource: "D3Fire", ofType: "scnp")
        let exp = NSKeyedUnarchiver.unarchiveObject(withFile: pathToEmitter!) as? SCNParticleSystem
        /*
        exp?.loops = false
        exp?.birthRate = 5000
        exp?.emissionDuration = 0.01
        exp?.spreadingAngle = 180
        exp?.particleDiesOnCollision = true
        exp?.particleLifeSpan = 0.5
        exp?.particleLifeSpanVariation = 0.3
        exp?.particleVelocity = 500
        exp?.particleVelocityVariation = 3
        exp?.particleSize = 0.05
        exp?.stretchFactor = 0.05
        exp?.particleColor = UIColor.blueColor()
        */
        
        exp?.birthRate /= 10;
        exp?.particleLifeSpan = 0.25;
        exp?.stretchFactor = 0.05;
        //let sphereGeometry  = SCNSphere(radius: 0.01);
        exp?.emitterShape = self.geometry!;//sphereGeometry;
        exp?.birthLocation = .volume;
        exp?.birthLocation = .vertex;

        let particlesNode = SCNNode();
        particlesNode.addParticleSystem(exp!);
        d3Scene.rootNode.addChildNode(particlesNode);
        particlesNode.position = pos;
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 5,
            execute:
            {_ in
                particlesNode.removeFromParentNode();
            }
        );
        /* does not work here!
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block:
        {_ in
            print("removePS-1");
            particlesNode.removeFromParentNode();
            print("removePS");
        });*/
    }
    internal func stop()
    {
        self.removeAllActions();
        self.physicsBody?.clearAllForces();
        
        self.physicsBody?.velocity                  = SCNVector3Zero
        self.physicsBody?.angularVelocity           = SCNVector4Zero
        self.physicsBody?.angularVelocityFactor     = SCNVector3Zero
    }
    public func onCollided(d3Scene:D3Scene, other:SCNNode?, contactPoint:SCNVector3)->Void
    {
        //nothing to do here... override this func!
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
    class func createBody(sType:String, type:SCNPhysicsBodyType,geo:SCNGeometry,scale:SCNVector3=SCNVector3Make(1.0, 1.0, 1.0)) -> SCNPhysicsBody
    {
        //.static = no gravity effect, no forces
        let type:SCNPhysicsBodyType = (sType == D3LandNode.NAME) ? .static : .dynamic;
        let opt = [SCNPhysicsShape.Option.scale:scale];
        let shape:SCNPhysicsShape = SCNPhysicsShape(geometry:geo, options: opt);
        let pb : SCNPhysicsBody = SCNPhysicsBody(type: type, shape: shape);
        
        pb.angularVelocityFactor    = SCNVector3Zero    //= avoid rotation
        pb.angularDamping           = 1.0               //a damping factor of 1.0 prevents the body from rotating
        pb.restitution              = 0.0;              //= object won't bounce
                                                        //A restitution of 1.0 means that the body loses no energy in a collision, eg. a ball
        
        switch sType
        {
            case D3LandNode.NAME:
                pb.isAffectedByGravity  = false
                break;
            case D3TreeNode.NAME:
                pb.isAffectedByGravity  = true
                pb.mass                 = 999
                pb.friction             = 999
                break;
            case D3MeNode.NAME:
                pb.isAffectedByGravity  = true
                pb.mass                 = 0.9
                pb.friction             = 0.9
                break;
            case D3ShotNode.NAME:
                pb.isAffectedByGravity  = false
                pb.mass                 = 0.9           //mass & friction are needed the collisionTesting to work!
                pb.friction             = 0.9
                break;
            default:
                print("D3Node.createBody: ERR: unknown type");
        }

        return D3Node.setupCollider(sType:sType,pb:pb);
    }
    class func setupCollider(sType:String, pb:SCNPhysicsBody) -> SCNPhysicsBody
    {
        //pb.categoryBitMask        //which categories this physics body belongs to
        //pb.contactTestBitMask     //which categories of bodies cause intersection notifications with this physics body
        //pb.collisionBitMask   = 0;//which categories of physics bodies can collide with this physics body.
                                    //if you set 0 on this, you fall through the floor!

        switch sType
        {
        case D3LandNode.NAME:
            pb.categoryBitMask      = Globals.D3CollisionCategoryFloor
            pb.collisionBitMask     = Globals.D3CollisionCategoryPlayer | Globals.D3CollisionCategoryTree | Globals.D3CollisionCategoryShot
            break;
        case D3TreeNode.NAME:
            pb.categoryBitMask      = Globals.D3CollisionCategoryTree
            pb.contactTestBitMask   = Globals.D3CollisionCategoryPlayer | Globals.D3CollisionCategoryFloor | Globals.D3CollisionCategoryShot
            break;
        case D3MeNode.NAME:
            pb.categoryBitMask      = Globals.D3CollisionCategoryPlayer
            pb.contactTestBitMask   = Globals.D3CollisionCategoryTree | Globals.D3CollisionCategoryFloor
            break;
        case D3ShotNode.NAME:
            pb.categoryBitMask      = Globals.D3CollisionCategoryShot
            pb.contactTestBitMask   = Globals.D3CollisionCategoryTree | Globals.D3CollisionCategoryFloor
            break;
        default:
            print("D3Node.setupCollider: ERR: unknown type");
        }
        
        return pb;
    }
}
