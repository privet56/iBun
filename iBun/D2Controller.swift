//
//  D2Controller.swift
//  iBun
//
//  Created by h on 12.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit

class D2Controller : UIViewController
{
    var backgroundImageView:UIImageView? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        let iView:UIImageView = UIImageView(frame:self.view.bounds)
        iView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(iView)
        self.backgroundImageView = iView
        iView.isUserInteractionEnabled = true
    
        let sView:SKView = SKView(frame:iView.bounds)
        sView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        iView.addSubview(sView)
        
        let sScene:D2Scene = D2Scene(size:sView.bounds.size);
        sScene.scaleMode = .aspectFill;
        sView.allowsTransparency = true;
        sView.isUserInteractionEnabled = true
        sView.presentScene(sScene);
        
        /*var timer = */Timer.scheduledTimer(timeInterval: 9.99, target: self, selector: #selector(D2Controller.changeBkg), userInfo: nil, repeats: true)
        self.changeBkg()
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    @IBAction func onBack(sender:UIButton)
    {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    //do not allow another orientation!
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.landscape;
    }
    func shouldAutorotateToInterfaceOrientation(interfaceOrientation:UIInterfaceOrientation) -> Bool
    {
        return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    }
    func changeBkg()
    {
        let min:UInt32 = 1
        let max:UInt32 = 11
        let val = Int(arc4random_uniform(max) + min)
        let indexWithLeadingZero = val > 9 ? String(val) : String(format: "%02d", val)
        let path = Bundle.main.path(forResource:"sky/sky"+indexWithLeadingZero, ofType:"gif")
        let url : URL = URL.init(fileURLWithPath: path!)
        
        self.backgroundImageView?.image = UIImage.animatedImage(withAnimatedGIFURL:url)
        
        let tr:CATransition = CATransition()
        tr.duration = 1.1
        tr.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        tr.type = kCATransitionMoveIn
        self.backgroundImageView?.layer.add(tr, forKey: nil)
    }
}