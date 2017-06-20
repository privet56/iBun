//
//  D2SceneFinish.swift
//  iBun
//
//  Created by h on 13.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2SceneFinish : SKScene
{
    var d2Controller:D2Controller? = nil
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    init(size: CGSize, d2Controller:D2Controller)
    {
        super.init(size: size)
        
        self.d2Controller = d2Controller
        
        self.isUserInteractionEnabled = true
        self.scaleMode = SKSceneScaleMode.aspectFill
        backgroundColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        do
        {
            let backgroundNode = SKSpriteNode(imageNamed: "spaceship4")
            backgroundNode.size         = CGSize(width:frame.size.width * 0.75, height:frame.size.height * 0.75);
            backgroundNode.anchorPoint  = CGPoint(x: 0.5, y: 0.5);
            backgroundNode.position     = CGPoint(x: size.width / 2.0, y: size.height / 2.0);
            addChild(backgroundNode);
        }
        do
        {
            let simpleLabel = SKLabelNode(fontNamed: "Copperplate")
            simpleLabel.text = "YOU WON";
            simpleLabel.fontSize = 40;
            simpleLabel.position = CGPoint(x: size.width / 2.0, y: 0)
            addChild(simpleLabel)
        }
        do
        {
            let simpleLabel = SKLabelNode(fontNamed: "Copperplate")
            simpleLabel.text = "Tap to restart";
            simpleLabel.fontSize = 20;
            simpleLabel.position = CGPoint(x: size.width / 2.0, y: size.height - simpleLabel.frame.size.height)
            addChild(simpleLabel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let transition = SKTransition.fade(withDuration: 2.0)
        let scene = D2Scene(size: size, d2Controller:self.d2Controller!)
        view?.presentScene(scene, transition: transition)
    }
}
