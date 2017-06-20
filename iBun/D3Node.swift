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
}
