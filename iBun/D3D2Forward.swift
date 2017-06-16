//
//  D3D2Forward.swift
//  iBun
//
//  Created by h on 16.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D3D2Forward : SKSpriteNode
{
    var d3Scene:D3Scene? = nil

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene, d3Scene:D3Scene)    //constructor needs the scene to be able to scale & position the object in the scene
    {
        self.d3Scene = d3Scene
        
        let texture = SKTexture(imageNamed: "left-arrow")
        let size:CGSize = CGSize(width:(scene.frame.size.width / 10),height:(scene.frame.size.height / 10))
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = CGPoint(x: 9, y: (0 + (self.frame.size.width / 2)))
        self.isUserInteractionEnabled = true
        
        do
        {
            let rot = SKAction.rotate(byAngle: -96, duration: 0.5)
            self.run(rot)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.d3Scene?.move(forward: true);
    }
}
