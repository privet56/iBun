//
//  D3LLandNode.swift
//  iBun
//
//  Created by h on 30.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import QuartzCore
import SceneKit

class D3LLandNode : D3Destroyable
{
    static let NAME = "landscape";
    var NAME_OF_MODEL_NODE:String = "";
    
    override init(scnNode:SCNNode)
    {
        super.init(scnNode:scnNode)
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    override func getName() -> String
    {
        return super.getName() + ":" + NAME_OF_MODEL_NODE;
    }

    class func create(scene:D3LScene) -> Void//D3LLandNode
    {
        let landscapeScene = SCNScene(named:"d3.scnassets/l1.dae")!;
        let landscapeRoot:SCNNode = landscapeScene.rootNode;
        //node = node.flattenedClone();
        for landscpeNode in landscapeRoot.childNodes
        {
            if(landscpeNode.name?.lowercased().range(of: "Tree_Leaf_00".lowercased()) != nil)
            {
                continue;
            }
            
            let n           = D3LLandNode(scnNode:landscpeNode);
            n.name          = D3LLandNode.NAME;
            n.NAME_OF_MODEL_NODE = landscpeNode.name!;
            n.physicsBody   = D3Node.createBody(sType: D3LLandNode.NAME, type:.static, geo: n.geometry!);
            scene.rootNode.addChildNode(n);
            do
            {
                let pos:SCNVector3 = SCNVector3Make(landscpeNode.position.x, -0.1, landscpeNode.position.z);
                //let pos:SCNVector3 = landscpeNode.position;
                if(landscpeNode.name?.lowercased().range(of: "Tree_Leaf_001".lowercased()) != nil)
                {
                    //pos = SCNVector3Make(landscpeNode.position.x, -0.0, landscpeNode.position.z);
                    n.runAction(SCNAction.rotateBy(x:0,y:180,z:0,duration:0.01));
                    print("found");
                }
                n.position = pos;
            }
        }
        //n.physicsBody   = D3Node.createBody(sType: D3LLandNode.NAME, type:.static, geo: n.geometry!);
        //return n;
    }
}
