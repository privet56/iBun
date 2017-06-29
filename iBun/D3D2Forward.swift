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
    var d3Scene:D3Scene? = nil;
    var viewController:UIViewController? = nil

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene, d3Scene:D3Scene, viewController:UIViewController)
    {
        self.d3Scene = d3Scene;
        self.viewController = viewController;
        
        let texture = SKTexture(imageNamed: "left-arrow")
        let size:CGSize = CGSize(width:(scene.frame.size.width / 10),height:(scene.frame.size.height / 10))
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = CGPoint(x: (scene.size.width - (size.width / 2)), y: scene.size.height - (self.frame.size.height/2))
        self.isUserInteractionEnabled = true
        
        do
        {
            let rot = SKAction.rotate(byAngle: Math.degree2radian(degree: 180.0), duration: 3.3)
            self.run(rot)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        (self.viewController as! D3Controller).onForward(sender: nil);
    }
}
