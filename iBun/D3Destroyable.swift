//
//  D3Destroyable.swift
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

class D3Destroyable : D3Node
{
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
                if(other is D3Node)
                {
                    Globals.Log(message: "i am("+self.getName()+") destroyed! other:"+(other as! D3Node).getName());
                }
                else
                {
                    Globals.Log(message: "i am("+self.getName()+") destroyed! other:"+(other?.name)!);
                }
                return;
            }
        }
        
        if(self.physicsBody!.isAffectedByGravity == false) {return;}
        self.physicsBody!.isAffectedByGravity  = false;
        self.physicsBody!.type = .static;
        self.position = self.presentation.position;
    }
}
