//
//  D3D2Scene.swift
//  iBun
//
//  Created by h on 16.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D3D2Scene : SKScene
{
    var d3Scene:D3Scene? = nil;
    var viewController:UIViewController? = nil;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    init(size: CGSize, d3Scene:D3Scene, viewController:UIViewController)
    {
        super.init(size: size)
        
        self.d3Scene = d3Scene;
        self.viewController = viewController;
        
        self.isUserInteractionEnabled = true
        self.scaleMode = SKSceneScaleMode.aspectFill
        //backgroundColor = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        do
        {
            //let d3d2Forward:D3D2Forward = D3D2Forward(scene:self, d3Scene:self.d3Scene!)
            //self.addChild(d3d2Forward)
            let backLabel = D2Back(scene:self, viewController:self.viewController!)
            self.addChild(backLabel)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if(touches.count != 1) {return;}
        let p:CGPoint?       = touches.first?.location(in: self);
        if( p == nil){return;}
        let x:CGFloat       = p!.x;
        let third:CGFloat   = self.frame.size.width / 3
        if(x < third)
        {
            self.d3Scene?.rotateMe(right: false);
            return;
        }
        else if(x > (third*2))
        {
            self.d3Scene?.rotateMe(right: true);
            return;
        }
        else
        {
            self.d3Scene?.move(forward: true);
        }
        
        //print("D3D2Scene: width:"+(String.init(describing:self.frame.size.width)) +
        //    " third:"+String.init(describing:third) +
        //    " x:"+String.init(describing:x));
    }
}
