//
//  D3MsgNode.swift
//  iBun
//
//  Created by h on 22.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import QuartzCore
import SceneKit

class D3MsgNode : D3Node
{
    override init()
    {
        super.init()
    }
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    init(string:String, extrusionDepth: CGFloat, inFrontOf:D3Node)
    {
        super.init();
        
        let text = SCNText(string: string, extrusionDepth: 0.15)
        text.font = UIFont.systemFont(ofSize: 0.33);
        self.geometry = text;
        do
        {
            let material:SCNMaterial = SCNMaterial();
            material.diffuse.contents = UIImage(named:"water.gif");
            self.geometry?.firstMaterial = material;
        }
        self.pivot = SCNMatrix4MakeTranslation(0.5, 0.5, 0.5);
        var forward = inFrontOf.getZForward(m: 2, p: inFrontOf.position);
        let initHeight:Float = 2.2;
        forward.y = initHeight;
        self.position = forward;
        let moveDown = SCNAction.moveBy(x: -CGFloat(string.characters.count / 10), y: -CGFloat(initHeight * 1.1), z: 0, duration:3.3);
        self.runAction(moveDown, completionHandler:
        {
            if(self.parent != nil)
            {
                self.removeFromParentNode();
            }
        });
    }
}
