//
//  Arrow.swift
//  iBun
//
//  Created by h on 08.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import UIKit

class Arrow: UIImageView
{
    var _isLeft:Bool = true
    var isLeft:Bool {
        
        get {
            return _isLeft
        }
        set {               //set this in the storyboard "user defined runtime attributes"
            if(self._isLeft == newValue)
            {
                return;
            }
            
            self._isLeft = newValue
            self.transform = CGAffineTransform(scaleX:-1, y:1)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func viewWillAppear(_ animated: Bool, isLeft:Bool, currentIndex:Int, maxIndex:Int)
    {
        if((currentIndex < 1) && self.isLeft)
        {
            self.removeFromSuperview()
            return;
        }
        if((currentIndex >= maxIndex) && !self.isLeft)
        {
            self.removeFromSuperview()
            return;
        }

        //self.activatePosConstraints(activate: false)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(
        {
            //self.activatePosConstraints(activate: true)
            self.remove()
        })

        let aniPosX = CASpringAnimation(keyPath: "position.x")
        aniPosX.fromValue = self.superview!.bounds.width / 2
        aniPosX.toValue = self.isLeft ? 0 : self.superview!.bounds.width
        aniPosX.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        aniPosX.damping = 2.0
        aniPosX.mass = 1.0
        aniPosX.stiffness = 11
        aniPosX.initialVelocity = 0.1

        let sizeAni = CASpringAnimation(keyPath: "transform.scale")
        sizeAni.fromValue = self.isLeft ? 0.001 : -0.001
        sizeAni.toValue = self.isLeft ? 1.3 : -1.3

        let aniPosY = CAKeyframeAnimation(keyPath: "position.y")
        aniPosY.values = [0.0, 0.0,
                          (self.superview!.bounds.height / 3)*2     , (self.superview!.bounds.height / 3)*2,
                          (self.superview!.bounds.height / 2)+33    , (self.superview!.bounds.height / 2)+33]
        if(self.isLeft)
        {
            aniPosY.keyTimes = [0.0, 0.2, 0.4, 0.5, 0.6, 1.0]
        }
        else
        {
            aniPosY.keyTimes = [0.0, 0.5, 0.7, 0.8, 0.9, 1.0]
        }

        let buttonAniGroup = CAAnimationGroup()
        buttonAniGroup.duration = 3.3
        buttonAniGroup.beginTime = CACurrentMediaTime() + (self.isLeft ? 0.1 : 0.9)
        buttonAniGroup.fillMode = kCAFillModeBoth
        
        buttonAniGroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        buttonAniGroup.animations = [aniPosX, sizeAni, aniPosY];
        
        self.layer.add(buttonAniGroup, forKey: nil)
        
        //self.layer.position.x = self.isLeft ? 0 : self.superview!.bounds.width
        //self.layer.position.y = self.superview!.bounds.height / 2
        
        CATransaction.commit()
    }
    func activatePosConstraints(activate:Bool)
    {
        for constraint in self.superview!.constraints
        {
            if(constraint.firstItem as? NSObject != self)
            {
                continue
            }
            
            if( (constraint.firstAttribute == .centerY) ||
                (constraint.firstAttribute == .leading) ||
                (constraint.firstAttribute == .trailing))
                
            {
                constraint.isActive = activate
            }
        }
    }
    
    func remove()
    {
        CATransaction.begin()
        CATransaction.setCompletionBlock(
        {
           self.removeFromSuperview()
        })
        if(self.isLeft)
        {
            let sizeAni = CASpringAnimation(keyPath: "transform.scale")
            sizeAni.fromValue   = self.isLeft ? 1.1 : -1.1
            sizeAni.toValue     = self.isLeft ? 0.03 : -0.03

            let rotAni = CASpringAnimation(keyPath: "transform.rotation")
            rotAni.fromValue = 0.0
            rotAni.toValue = 3.14
            rotAni.repeatCount = 3

            let buttonAniGroup = CAAnimationGroup()
            buttonAniGroup.duration = 3.3
            buttonAniGroup.beginTime = CACurrentMediaTime() + (self.isLeft ? 0.1 : 0.02)
            buttonAniGroup.fillMode = kCAFillModeBoth
        
            buttonAniGroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            buttonAniGroup.animations = [sizeAni, rotAni];
        
            self.layer.add(buttonAniGroup, forKey: nil)
        }
        else
        {
            var identity = CATransform3DIdentity
            identity.m34 = -1.0/1000
            //TODO: rotate only half!
            let rotationTransform = CATransform3DMakeRotation(CGFloat(1.0 * Double.pi), 1.0, 1.0, 0.0);
            let translationTransform = CATransform3DMakeTranslation(self.frame.width * 2, 0, 0)
            let transform3D:CATransform3D = CATransform3DConcat(rotationTransform, translationTransform)
            
            let rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath:"transform");
            
            rotationAnimation.toValue       = transform3D;
            rotationAnimation.duration      = 3.3;
            rotationAnimation.isCumulative  = false;
            rotationAnimation.repeatCount   = 1;
            
            self.layer.add(rotationAnimation, forKey: nil)
        }
        
        CATransaction.commit()
    }
}
