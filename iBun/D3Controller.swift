//
//  D3Controller.swift
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

class D3Controller : UIViewController
{
    var backgroundImageView:UIImageView? = nil;
    var scnView:SCNView? = nil;

    override func viewDidLoad()
    {
        super.viewDidLoad();
        let iView:UIImageView = UIImageView(frame:self.view.bounds)
        iView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(iView)
        self.backgroundImageView = iView
        iView.isUserInteractionEnabled = true
        
        let sView:SCNView = SCNView(frame:iView.bounds);
        self.scnView = sView;
        sView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        iView.addSubview(sView)
        self.switchScene();
        
        if(Globals.DEVELOPERMODE)
        {
            //sView.debugOptions = [.showBoundingBoxes/*, .showPhysicsShapes*/];
        }
        //sView.showsStatistics = true
        //sView.allowsCameraControl = true
        sView.isUserInteractionEnabled = true
        sView.backgroundColor = UIColor.clear;
        
        /*var timer = */Timer.scheduledTimer(timeInterval: 9.99, target: self, selector: #selector(D3Controller.changeBkg), userInfo: nil, repeats: true)
        self.changeBkg()
    }
    func isD3LeaScene() -> Bool
    {
        let bIsLea = (self.scnView?.scene is D3LScene);
        return bIsLea;
    }
    func switchScene()
    {
        let sScene = Globals.DEVELOPERMODE ? D3LScene(/*named:"d3.scnassets/l1.dae"*/) : ((self.scnView?.scene == nil) || isD3LeaScene()) ? D3Scene() : D3LScene(/*named:"d3.scnassets/l1.dae"*/);
        
        self.scnView?.scene = sScene;
        do
        {
            var size:CGSize = backgroundImageView!.bounds.size;
            if( size.width < size.height)
            {   //pseudo landscape
                size = CGSize(width:size.height, height:size.width);
            }
            scnView?.overlaySKScene = D3D2Scene(size: size, d3Scene: sScene, viewController:self, canForward:!(sScene is D3LScene));
        }
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    @IBAction func onBack(sender:UIButton?)
    {
        if(isD3LeaScene())
        {
            self.switchScene();
            return;
        }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func onForward(sender:UIButton?)
    {
        self.switchScene();
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
    @objc func changeBkg()
    {
        let min:UInt32 = 1
        let max:UInt32 = 13
        let val = Int(arc4random_uniform(max) + min)
        let indexWithLeadingZero = val > 9 ? String(val) : String(format: "%02d", val)
        let path = Bundle.main.path(forResource:"sunnyday/sunnyday"+indexWithLeadingZero, ofType:"gif")
        let url : URL = URL.init(fileURLWithPath: path!)
        
        self.backgroundImageView?.image = UIImage.animatedImage(withAnimatedGIFURL:url)
        
        let tr:CATransition = CATransition()
        tr.duration = 1.1
        tr.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        tr.type = kCATransitionFade
        self.backgroundImageView?.layer.add(tr, forKey: nil)
    }
}
