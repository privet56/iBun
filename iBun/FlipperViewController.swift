//
//  Flipper.swift
//  iBun
//
//  Created by h on 08.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class FlipperViewController : UIViewController
{
    var images:[UIImageView] = [];
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        //self.view.backgroundColor = UIColor.blue;
        do
        {
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor.blue.cgColor, UIColor.black.cgColor]
            self.view.layer.insertSublayer(gradient, at: 0)
        }
        
        for index in 1...4 {
        
            let path = "buns/spring0"+String(index)+".png";
            let image = UIImage(named: path)
            let imageView = UIImageView(image: image!)
            imageView.layer.anchorPoint.y = 0.0
            imageView.frame = self.view.bounds
            
            self.view.addSubview(imageView)
            
            //imageView.contentMode = UIViewContentMode.scaleAspectFit;
            self.images.append(imageView);
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0/250.0
        self.view.layer.sublayerTransform = perspective
        
        var imageYOffset: CGFloat = 50.0
        
        for subview in view.subviews
        {
            if let image = subview as? UIImageView
            {
                var imageTransform = CATransform3DIdentity
                
                //TODO
                imageTransform = CATransform3DTranslate(imageTransform, 0.0, imageYOffset, 0.0)
                imageTransform = CATransform3DScale(imageTransform, 0.95, 0.6, 1.0)
                imageTransform = CATransform3DRotate(imageTransform, CGFloat((Double.pi / 4)/2), -1.0, 0.0, 0.0)
                image.layer.transform = imageTransform
                imageYOffset += self.view.frame.height / CGFloat(self.images.count)
            }
        }
    }
    
    //do not allow another orientation!
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask
    {
        return UIInterfaceOrientationMask.portrait;
    }
    func shouldAutorotateToInterfaceOrientation(interfaceOrientation:UIInterfaceOrientation) -> Bool
    {
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    }
}
