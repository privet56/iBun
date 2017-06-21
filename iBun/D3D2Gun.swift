//
//  D3D2Gun.swift
//  iBun
//
//  Created by h on 21.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D3D2Gun : SKSpriteNode
{
    var d3Scene:D3Scene? = nil;
    let FIREDURATION = 0.555
    let RESTINGSIZE = 66
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene, d3Scene:D3Scene)    //constructor needs the scene to be able to scale & position the object in the scene
    {
        self.d3Scene = d3Scene
        
        let texture = SKTexture(imageNamed: "gun2");
        let size:CGSize = CGSize(width:RESTINGSIZE,height:RESTINGSIZE)
        super.init(texture: texture, color: UIColor.clear, size: size);
        
        let x = (((scene.size.width) / 2) - (size.width / 2));
        let y = (0 + (self.frame.size.width / 2));
        self.position = CGPoint(x: x, y: y);
        
        self.isUserInteractionEnabled = true;
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        fireExplosion();
        fireResizeGun();
        fireBullet();
    }
    func fireExplosion()
    {
            let pathToEmitter = Bundle.main.path(forResource: "FireParticle", ofType: "sks")
            let emitter = NSKeyedUnarchiver.unarchiveObject(withFile: pathToEmitter!) as? SKEmitterNode
            
            //emitter!.zRotation = CGFloat(Double.pi/2.0);
            //emitter!.particlePositionRange = CGVector(dx: emitter!.particlePositionRange.dx / 32, dy: emitter!.particlePositionRange.dy / 16)
            //emitter!.particleScale = 0.3;
            //emitter!.particleScaleRange = 0.2;
            //emitter!.particleScaleSpeed = -0.1;
            emitter!.emissionAngle = 1.0
            emitter!.particleBirthRate = emitter!.particleBirthRate / 9
            
            self.addChild(emitter!)
            emitter!.position = CGPoint(x: 0, y: self.size.height)
            
            Timer.scheduledTimer(withTimeInterval: FIREDURATION, repeats: false, block:
            {_ in 
                emitter?.removeFromParent();
            });
    }
    func fireResizeGun()
    {
        let resizeAction:SKAction = SKAction.resize(byWidth: 0, height: (self.size.height / 3), duration: FIREDURATION);
        self.run(resizeAction, completion:
        {
            self.run(resizeAction.reversed());
        });
    }
    func fireChangePic()
    {
        let textureGunShooting:SKTexture = SKTexture(imageNamed:"gun2shooting");
        let changeFace:SKAction = SKAction.setTexture(textureGunShooting); //this action cannot animate!
        let wait:SKAction = SKAction.wait(forDuration: FIREDURATION);
        let sequence:SKAction = SKAction.sequence([changeFace, wait]);
        self.run(sequence, completion:
        {
            let textureGun:SKTexture = SKTexture(imageNamed:"gun2");
            let changeFace2:SKAction = SKAction.setTexture(textureGun);
            self.run(changeFace2);
        });
    }
    func fireBullet()
    {
        self.d3Scene?.fire();
    }
}
