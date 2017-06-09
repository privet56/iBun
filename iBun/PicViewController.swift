//
//  PicViewController.swift
//  iBun
//
//  Created by h on 09.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
class PicViewController : UIViewController
{
    var imagePath:String? = nil
    var imageView:UIImageView? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    func pinchedView(sender:UIPinchGestureRecognizer)
    {
        sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if(self.imagePath != nil)
        {
            if(self.view is UIImageView)
            {
                print("self.view is imageView")
                imageView = (self.view as! UIImageView)
                imageView!.image = UIImage(named: self.imagePath!)
            }
            else
            {
                print("self.view is "+(String(describing: type(of: self.view!))))
                imageView = UIImageView(image:UIImage(named: self.imagePath!))
                let scrollView:UIScrollView = UIScrollView(frame:self.view.bounds)
                scrollView.contentSize = imageView!.bounds.size
                scrollView.minimumZoomScale = 0.1
                scrollView.maximumZoomScale = 4.0
                scrollView.zoomScale = 1.0
                scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                scrollView.addSubview(imageView!)
                self.view.addSubview(scrollView)
            }

            imageView!.contentMode = .center
            do
            {
                let pinchRec = UIPinchGestureRecognizer()
                pinchRec.addTarget(self, action: #selector(pinchedView(sender:)))
                let pinchView = imageView!
                pinchView.addGestureRecognizer(pinchRec)
                pinchView.isUserInteractionEnabled = true
                pinchView.isMultipleTouchEnabled = true
            }
        }
        else
        {
            print("ERR: !imagePath")
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
