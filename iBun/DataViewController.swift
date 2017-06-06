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
    var dataObject: String = ""

    override func viewDidLoad()
    {
        super.viewDidLoad();

        do
        {
            if let path = Bundle.main.path(forResource:"falling_leaves.2", ofType:"gif")
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
            
            button2d.layer.borderColor = UIColor.green.cgColor;
            
            do
            {
                do
                {
                    let aniRound = CABasicAnimation(keyPath: "cornerRadius")
                    aniRound.fromValue = button2d.frame.width / 2
                    /*aniRound.toValue = 0  //don't set these if in aniGroup
                    aniRound.duration = 1.3
                    aniRound.beginTime = CACurrentMediaTime() + 0.1
                    aniRound.fillMode = kCAFillModeBackwards*/
                    aniRound.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
                    
                    let aniBorder = CABasicAnimation(keyPath: "borderWidth")
                    aniBorder.fromValue = 99
                    aniBorder.toValue = 3.3
                    /*aniBorder.duration = 1.3  //don't set these if in aniGroup
                    aniBorder.beginTime = CACurrentMediaTime() + 0.1
                    aniBorder.fillMode = kCAFillModeBackwards*/
                    aniBorder.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
                    
                    let buttonAniGroup = CAAnimationGroup()
                    buttonAniGroup.duration = 1.3
                    //buttonAniGroup.repeatDuration = 1.3
                    buttonAniGroup.beginTime = CACurrentMediaTime() + 0.1
                    buttonAniGroup.fillMode = kCAFillModeBackwards
                    buttonAniGroup.animations = [aniRound, aniBorder];
                    
                    button2d.layer.add(buttonAniGroup, forKey: nil)
                    
                    button2d.layer.cornerRadius = 0;
                    button2d.layer.borderWidth = 3.3;
                }
                /*
                {
                    self.button2d.layoutIfNeeded()
                    
                    UIView.animate(withDuration: 1.3, delay: 0.0, usingSpringWithDamping: 0.33, initialSpringVelocity: 0.0,
                                   options: .curveEaseIn,
                     animations:
                     {
                        self.button2d.layer.cornerRadius = 0;   //ATTENTION: ani cornerRadius with layerAni!
                        self.button2d.layoutIfNeeded()
                       
                     }, completion: { (finished: Bool) in
                        
                        print("ani completion "+String(finished));
                     }
                    )
                }*/
                
                //TODO: slide in button from left
                //TODO: show arrow to turn the page
            }
        }
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
        
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
