//
//  D3Lea.swift
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

class D3Lea : D3Destroyable
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
    
    //static let LEA_BLUEPRINT = Globals.node(name: "d3.scnassets/lea/lea" , ext: "obj", id: nil);
    
    class func create(scene:D3LScene) -> D3Lea
    {
        let scnScene = SCNScene(named:"d3.scnassets/lea/lea.dae");
        let scnNode  = scnScene?.rootNode;
        if( scnNode == nil)
        {
            print("!lea");
        }
        if(scnNode?.geometry == nil)
        {
            print("WRN: !lea.geometry");
            scnNode!.geometry = scnNode!.flattenedClone().geometry;
            if(scnNode?.geometry == nil)
            {
                print("ERR: !lea.geometry");
            }
        }/*
        if(scnNode!.geometry?.firstMaterial == nil)
        {
            print("WRN: !lea.geometry.!firstMaterial");
            let material:SCNMaterial = SCNMaterial();
            material.diffuse.contents = UIImage(named:"d3.scnassets/lea/lea_Texture_0.jpg");
            //scnNode!.geometry?.materials = [material];
            //scnNode!.geometry?.materials = Globals.matsFromPic(pathFN: "d3.scnassets/lea/lea_Texture_0", ext: "jpg");
        }
        if(scnNode!.geometry?.firstMaterial != nil)
        {
            scnNode!.geometry?.firstMaterial!.lightingModel = SCNMaterial.LightingModel.constant;
        }
        */
        
        //OBJ+MTL:
        //[SceneKit] Error: C3DLightingModelPhysicallyBased not supported by OpenGL renderer
        //The simulator only supports OpenGL, but spherical maps are only available when SceneKit runs on Metal.
        
        let n = D3Lea(scnNode:scnNode!);
        n.name = D3TreeNode.NAME;
        
        n.physicsBody = D3Node.createBody(sType: D3LandNode.NAME, type:.dynamic, geo: n.geometry!, scale:n.scale);
        
        return n;

    }
}
