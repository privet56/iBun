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
    static let NAME = "tree";
    var m_hit:Int = 0;
    
    override init()
    {
        super.init()
    }

    override init(scnNode:SCNNode)
    {
        super.init(scnNode:scnNode)
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    override func onCollided(d3Scene:D3Scene, other:SCNNode?, contactPoint:SCNVector3)->Void
    {
        super.onCollided(d3Scene: d3Scene, other: other, contactPoint: contactPoint);
        
        if((other != nil) && (other is D3ShotNode))
        {
            //let pos = self.convertPosition(contactPoint, to: d3Scene.rootNode);
            self.explode(d3Scene: d3Scene, pos: contactPoint);
            m_hit += 1;
            if(m_hit > 3)
            {
                self.removeFromParentNode();
                Globals.Log(message: "tree destroyed! other:"+(other?.name)!);
                return;
            }
        }
        
        if(self.physicsBody!.isAffectedByGravity == false) {return;}
        self.physicsBody!.isAffectedByGravity  = false;
        self.physicsBody!.type = .static;
        self.position = self.presentation.position;
    }
    
    //Global constants and variables are always computed lazily
    static let TREE1 = Globals.node(name: "d3.scnassets/tree" , ext: "dae", id: "Cylinder");
    static let TREE2 = Globals.node(name: "d3.scnassets/tree2", ext: "dae", id: "Tree", flattenGeometry: true);
    
    static let MAT1:[SCNMaterial] = Globals.matsFromPic(pathFN: "meadow/meadow3", ext: "gif");
    static let MAT2:[SCNMaterial] = Globals.matsFromPic(pathFN: "meadow/meadow5", ext: "gif")
    
    class func create(p:SCNVector3) -> D3TreeNode
    {
        let tree2:Bool      = (Globals.rand(min: 0, max: 100) < 50) ? true : false;
        let scnNode:SCNNode = tree2 ? TREE2 : TREE1;  //use once loaded models == speedup!
        
        if(tree2)//tree2.dae has no mat(colors)
        {
            let threeOrFive:Bool            = (Globals.rand(min: 0, max: 100) < 50) ? true : false;
            let materials : [SCNMaterial]   = threeOrFive ? MAT1 : MAT2;  //use once loaded mats == speedup!
            if(scnNode.geometry == nil)
            {
                scnNode.childNodes.forEach
                {
                    $0.geometry?.materials = materials
                }
            }
            else
            {
                scnNode.geometry!.materials = materials
            }
        }
        
        let n = D3TreeNode(scnNode:scnNode)
        n.name = D3TreeNode.NAME;
        
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
        
        //var geometry = n.geometry!;
        if(tree2)
        {
            /*
            let boudingBoxes = n.geometry!.boundingBox;
            let w = CGFloat(boudingBoxes.max.x - boudingBoxes.min.x);
            let h = CGFloat(boudingBoxes.max.y - boudingBoxes.min.y);
            let l = CGFloat(boudingBoxes.max.z - boudingBoxes.min.z);
            print("MIN.... w:"+String(describing: boudingBoxes.min.x)+" h:"+String(describing: boudingBoxes.min.y)+" l:"+String(describing: boudingBoxes.min.z));
            print("MAX.... w:"+String(describing: boudingBoxes.max.x)+" h:"+String(describing: boudingBoxes.max.y)+" l:"+String(describing: boudingBoxes.max.z));
            print("RESULT: w:"+String(describing: w)+" h:"+String(describing: h)+" l:"+String(describing: l));
            //geometry = SCNBox(width: w , height: h , length: l, chamferRadius: 0.0);
            */
        }
        
        n.physicsBody = D3Node.createBody(sType: D3LandNode.NAME, type:.dynamic, geo: n.geometry!, scale:n.scale);
        
        return n;
    }
    
    static let TREEDISTANCE:Int = 6;
    
    class func createForest(d3Scene:D3Scene, x:Int) -> Void
    {
        var i:Int = -(TREEDISTANCE * 6);
        while(i <=   (TREEDISTANCE * 6))
        {
            i += TREEDISTANCE;
            let distanceFromMe = TREEDISTANCE;
            if(i >= -distanceFromMe) && (i <= distanceFromMe)
            {
                if(x >= -distanceFromMe) && (x <= distanceFromMe)
                {
                    continue;
                }
            }
            
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

        var i:Int = -(TREEDISTANCE * 6);
        while(i <=   (TREEDISTANCE * 6))
        {
            i += TREEDISTANCE;
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
