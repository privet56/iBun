//
//  DataViewController.swift
//  iBun
//
//  Created by h on 02.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import UIKit
import QuartzCore

class DataViewController: UIViewController
{
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button2d: UIButton!
    @IBOutlet weak var button3d: UIButton!
    @IBOutlet weak var button25d: UIButton!
    @IBOutlet weak var button2dHoriConstraint: NSLayoutConstraint!
    @IBOutlet weak var button3dHoriConstraint: NSLayoutConstraint!
    @IBOutlet weak var button25dHoriConstraint: NSLayoutConstraint!
    var dataObject: Int = 0
    var maxIndex:   Int = 0
    
    @IBOutlet weak var arrowLeft:  Arrow!
    @IBOutlet weak var arrowRight: Arrow!

    override func viewDidLoad()
    {
        super.viewDidLoad();

        do
        {
            if let path = Bundle.main.path(forResource:"water", ofType:"gif")
            {
                let url : URL = URL.init(fileURLWithPath: path)
                backgroundImageView.image = UIImage.animatedImage(withAnimatedGIFURL:url)
            }
            else
            {
                print("ERR: no falling_leaves.1");
            }
        }
        do
        {
            do
            {
                do
                {
                    self.ani(b:self.button2d, layoutConstraint:self.button2dHoriConstraint, delay:0.1)
                    self.ani(b:self.button3d, layoutConstraint:self.button2dHoriConstraint, delay:0.3)
                    self.ani(b:self.button25d,layoutConstraint:self.button25dHoriConstraint,delay:0.5)
                }
                do
                {
                    /*self.button2dHoriConstraint.constant = -222
                    //self.button2d.layoutIfNeeded()
                    //self.button2dHoriConstraint.constant = 0
                    
                    /*UIView.animate(withDuration:3.0, delay: 0.5,
                                               usingSpringWithDamping: 0, initialSpringVelocity: 0.0,
                                               options: .curveEaseIn, animations:
                        {
                            self.button2dHoriConstraint.constant = 0
                            self.button2dHoriConstraint.isActive = true
                            //self.button2d.layoutIfNeeded()
                            
                        }, completion:{ (finished: Bool) in
                            
                            print("ani finished: "+String(finished));
                        })*/

                    UIView.animate(withDuration:3.0, animations:
                        {
                            self.button2dHoriConstraint.constant = 0
                            //self.button2dHoriConstraint.isActive = true
                            self.button2d.layoutIfNeeded()

                    }, completion:{ (finished: Bool) in
                        
                        print("ani finished: "+String(finished));
                    })
                    
                    //self.button2dHoriConstraint.constant = 0
                    //self.button2dHoriConstraint.constant = -222
                    */
                }
            }
        }
     }
    
    override func viewWillDisappear(_ animated:Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    func ani(b:UIButton!, layoutConstraint:NSLayoutConstraint!, delay:Double)
    {
        b.contentMode = UIViewContentMode.scaleAspectFit;
        b.imageView?.contentMode = UIViewContentMode.scaleAspectFit;
        b.setValue(1, forKey: "contentMode")
        
        b.layer.borderColor = UIColor.green.cgColor;
        layoutConstraint.isActive = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(
        {
            if (self.isViewLoaded && (layoutConstraint != nil))
            {
                layoutConstraint.isActive = true
            }
            //self.view.layoutIfNeeded()
        })
        let aniRound = CABasicAnimation(keyPath: "cornerRadius")    //this attribute wouldn't animate with "UIView.animate"!
        aniRound.fromValue = b.frame.width / 2
        aniRound.toValue = 0  /*don't set these if in aniGroup
         aniRound.duration = 1.3
         aniRound.beginTime = CACurrentMediaTime() + 0.1
         aniRound.fillMode = kCAFillModeBackwards*/
        aniRound.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        let aniBorder = CABasicAnimation(keyPath: "borderWidth")
        aniBorder.fromValue = 9.9
        aniBorder.toValue = 3.3
        aniBorder.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        let aniPos = CASpringAnimation(keyPath: "position.x")
        aniPos.fromValue = 0
        aniPos.toValue = view.bounds.width / 2
        aniPos.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        aniPos.damping = 2.0
        aniPos.mass = 1.0
        aniPos.stiffness = 11
        aniPos.initialVelocity = 0.1
        
        let flashAni = CABasicAnimation(keyPath: "borderColor")
        flashAni.fromValue = UIColor.clear.cgColor
        flashAni.toValue = UIColor.green.cgColor
        
        let scaleAni = CABasicAnimation(keyPath: "transform")
        let angle = CGFloat(Double.pi)
        let x:CGFloat = 0.0
        let y:CGFloat = -1.0
        let z:CGFloat = 0.0
        scaleAni.fromValue = NSValue(caTransform3D:CATransform3DMakeRotation(angle, x, y, z))
        scaleAni.toValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAni.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        //b.layer.anchorPoint.y = 0
        
        let buttonAniGroup = CAAnimationGroup()
        buttonAniGroup.duration = 3.3
        //buttonAniGroup.repeatDuration = 1.3
        buttonAniGroup.beginTime = CACurrentMediaTime() + delay
        buttonAniGroup.fillMode = kCAFillModeBackwards
        buttonAniGroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        buttonAniGroup.animations = [aniRound, aniBorder, aniPos, flashAni, scaleAni];
        
        b.layer.add(buttonAniGroup, forKey: nil)
        
        b.layer.cornerRadius = 0
        b.layer.borderWidth = 3.3;
        b.layer.position.x = view.bounds.width / 2;
        
        CATransaction.commit()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.arrowLeft.viewWillAppear(animated , isLeft: true , currentIndex: self.dataObject, maxIndex: self.maxIndex)
        self.arrowRight.viewWillAppear(animated, isLeft: false, currentIndex: self.dataObject, maxIndex: self.maxIndex)
        
        self.dataLabel!.text = String(dataObject)
        
        do
        {
            if let path = Bundle.main.path(forResource:"meadow/meadow"+self.dataLabel!.text!, ofType:"gif")
            {
                let url : URL = URL.init(fileURLWithPath: path)
                imageView.image = UIImage.animatedImage(withAnimatedGIFURL:url)
            }
            else
            {
                print("ERR: no meadow");
            }
        }
    }
}
