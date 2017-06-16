//
//  D3TreeNode.swift
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

class D3TreeNode : D3Node
{
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
    class func create(p:SCNVector3) -> D3TreeNode
    {
        let tree2:Bool = (Globals.rand(min: 0, max: 100) < 50) ? true : false;
        
        
        let scnNode = tree2 ?   Globals.node(name: "d3.scnassets/tree2", ext: "dae", id: "Tree") :
                                Globals.node(name: "d3.scnassets/tree", ext: "dae", id: "Cylinder");
        
        do//if(tree2)//tree2.dae has no mat(colors)
        {
            let threeOrFive:Bool = (Globals.rand(min: 0, max: 100) < 50) ? true : false;
            
            let path = Bundle.main.path(forResource:"meadow/meadow"+String(threeOrFive ? "3" : "5"), ofType:"gif")
            let url : URL = URL.init(fileURLWithPath: path!)
            let i:UIImage = UIImage.animatedImage(withAnimatedGIFURL:url)!
            var materials = [SCNMaterial]()
            let material = SCNMaterial()
            material.diffuse.contents = i
            materials.append(material)
            do//if(scnNode.geometry == nil)
            {
                scnNode.childNodes.forEach
                {
                    $0.geometry?.materials = materials
                }
            }
            do//else
            {
                //scnNode.geometry!.materials = materials
            }
        }
        
        let n = D3TreeNode(scnNode:scnNode)
        n.name = "tree";

        n.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        n.physicsBody?.isAffectedByGravity  = false
        n.physicsBody?.mass                 = 9
        n.physicsBody?.restitution          = 1.0
        n.physicsBody?.friction             = 991.0
        n.physicsBody?.angularDamping       = 1.0
        n.physicsBody?.angularVelocityFactor = SCNVector3(0,0,0)
        n.physicsBody?.categoryBitMask    = 8//Int(Globals.CollisionCategoryShot)
        n.physicsBody?.contactTestBitMask = 4//Int(Globals.CollisionCategoryEnemy)
        n.physicsBody?.collisionBitMask   = 0
        
        do
        {
            let x:Float = Float(Globals.rand(min: 50, max: 150)) / 100.0
            let y:Float = Float(Globals.rand(min: 50, max: 100)) / 100.0
            let z:Float = Float(Globals.rand(min: 50, max: 100)) / 100.0
            n.scale = SCNVector3(x: x, y: y, z: z);
        }

        do
        {
            let dx:Float = Float(Globals.rand(min: 0, max: 150)) / 100.0
            let dy:Float = Float(Globals.rand(min: 0, max: 150)) / 100.0
            let dz:Float = tree2 ? 0 : 2    //tree1 has too large bounds
            
            let p2 = SCNVector3(x:p.x + dx, y:p.y + dy, z:p.z + dz);
            n.position = p2;
        }
        
        return n;
    }
    
    class func createForest(d3Scene:D3Scene, x:Int) -> Void
    {
        var i:Int = -36;
        while(i <= 33)
        {
            i += 6
            if(i >= -3) && (i <= 3){continue}
            
            do
            {
                let p:SCNVector3 = SCNVector3Make(Float(x), 0, Float(i));
                let d3TreeNode:D3TreeNode = D3TreeNode.create(p: p)
                d3Scene.rootNode.addChildNode(d3TreeNode);
            }
        }
    }
    
    class func createForest(d3Scene:D3Scene) -> Void
    {
        let start = DispatchTime.now()

        var i:Int = -36;
        while(i <= 33)
        {
            i += 6
            if(i >= -3) && (i <= 3){continue}
            D3TreeNode.createForest(d3Scene: d3Scene, x: i)
        }
        do
        {
            let end = DispatchTime.now();
            let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
            let milliSecondsTime    = Int32(Double(nanoTime) / 1_000_000)
            let secondsTime         = Int32(Double(nanoTime) / 1_000_000_000)
            print("forest created in \(milliSecondsTime) ms = \(secondsTime) sec");
        }
    }
}
