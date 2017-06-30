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
    var canDestroy:Bool = false;
    
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
    override func onCollided(d3Scene:D3Scene, other:SCNNode?, contactPoint:SCNVector3)->Void
    {
        if(canDestroy)
        {
            super.onCollided(d3Scene: d3Scene, other: other, contactPoint: contactPoint);
        }
    }
    
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
            //print("WRN: !lea.geometry");  //normal case in case of DAE & OBJ+MTL
            scnNode!.geometry = scnNode!.flattenedClone().geometry;
            if(scnNode?.geometry == nil)
            {
                print("ERR: !lea.geometry");
            }
        }

        /*  //case OBJ+MTL
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
        }*/
        
        //OBJ+MTL:
        //[SceneKit] Error: C3DLightingModelPhysicallyBased not supported by OpenGL renderer
        //The simulator only supports OpenGL, but spherical maps are only available when SceneKit runs on Metal.
        
        let n = D3Lea(scnNode:scnNode!);
        n.name = D3TreeNode.NAME;
        
        n.physicsBody = D3Node.createBody(sType: D3LandNode.NAME, type:.dynamic, geo: n.geometry!, scale:n.scale);
        n.rotation = SCNVector4Make(1, 0, 0, Float(Math.degree2radian(degree: -90.0)));//Float(-Double.pi/2.8));
        
        return n;

    }
}
