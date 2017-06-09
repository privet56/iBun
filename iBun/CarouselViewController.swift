//
//  CarouselViewController.swift
//  iBun
//
//  Created by h on 08.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation

//typealias topic = (String, Int)

class CarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate
{
    let LINEARIZEIMGPATHS = true;
    
    var topics:[String:Int] = ["autumn":3, "home":12, "spring":4,"summer":4,"winter":7];
    var imgpaths:[String] = [];
    var bkgImage:UIImage? = nil
    var bkgImageView:UIImageView? = nil
    
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        for topic in self.topics
        {
            let indexWithLeadingZero = topic.value > 9 ? String(topic.value) : String(format: "%02d", topic.value)
            let path = "buns/"+topic.key+indexWithLeadingZero+".png";
            imgpaths.append(path)
        }
        
        do
        {
            let gradient = CAGradientLayer()
            let greater = (view.bounds.width > view.bounds.height) ? view.bounds.width : view.bounds.height
            let fr:CGRect = CGRect(x:0,y:0,width:greater,height:greater)
            gradient.frame = fr
            gradient.colors = [UIColor.blue.cgColor, UIColor.black.cgColor]
            //self.view.layer.insertSublayer(gradient, at: 0)
        }
        do
        {
            if let path = Bundle.main.path(forResource:"water", ofType:"gif")
            {
                let url : URL = URL.init(fileURLWithPath: path)
                self.bkgImage = UIImage.animatedImage(withAnimatedGIFURL:url)
                UIGraphicsBeginImageContext(self.view.frame.size)
                self.bkgImage!.draw(in:self.view.bounds)
                let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.view.backgroundColor = UIColor(patternImage:image!)
                
                //self.view.backgroundColor = UIColor.clear //result is black
                //aniBackground(gifimage:image!)
                
                self.bkgImageView = UIImageView(image: self.bkgImage!)
                self.bkgImageView!.frame.size = self.view.frame.size
                //self.view.addSubview(self.bkgImageView!)
                //self.bkgImageView!.isHidden = true

                /*var timer = Timer.scheduledTimer(timeInterval:0.4, target: self,
                                                     selector: #selector(CarouselViewController.update), userInfo: nil, repeats: true)*/
                
            }
            else
            {
                print("ERR: no water");
            }
        }
        
        carousel.type = .coverFlow
        carousel.dataSource = self
        carousel.delegate = self
    }
    func update()
    {
        UIGraphicsBeginImageContext(self.bkgImageView!.frame.size)
        self.bkgImageView!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if(image != nil)
        {
            self.view.backgroundColor = UIColor(patternImage:image!)
        }
    }
    func aniBackground(gifimage:UIImage) -> Void
    {
        //self.view.backgroundColor = UIColor(patternImage:gifimage)
        
        let anAnimation:CABasicAnimation = CABasicAnimation(keyPath:"backgroundColor");
        anAnimation.duration = 1.00;
        anAnimation.repeatCount = 999;
        anAnimation.autoreverses = false;
        anAnimation.duration = 3.3
        anAnimation.repeatDuration = 1.3
        anAnimation.beginTime = CACurrentMediaTime()
        anAnimation.fillMode = kCAFillModeBackwards
        anAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)

        anAnimation.fromValue = UIColor.red.cgColor//UIColor(patternImage:gifimage).cgColor
        anAnimation.toValue = UIColor.green.cgColor//UIColor(patternImage:gifimage)
        self.view.layer.add(anAnimation, forKey: nil)
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        #if LINEARIZEIMGPATHS
            return self.imgpaths.count
        #endif
        
        var len:Int = 0
        for topic in self.topics
        {
            len += topic.value
        }
        return len;
    }
    
    func getTopicAndIndex(index:Int) ->  (key: String, val: Int)
    {
        var len:Int = 0
        for topic in self.topics
        {
            if((topic.value + len) > index)
            {
                return (topic.key, index - len)
            }
            len += topic.value
        }
        print("error!")
        return (self.topics.first!.key, 0)
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        #if LINEARIZEIMGPATHS
            let path = self.imgpaths[index]
        #else
            let topic:(key: String, val: Int) = getTopicAndIndex(index:index)
            let indexWithLeadingZero = topic.val > 9 ? String(topic.val) : String(format: "%02d", topic.val)
            let path = "buns/"+topic.key+indexWithLeadingZero+".png";
        #endif
        
        let itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: (self.view.bounds.width / 3) * 2, height: (self.view.bounds.height / 3) * 2))
        itemView.image = UIImage(named: path)
        itemView.contentMode = UIViewContentMode.scaleAspectFit;    //itemView.contentMode = .center
        itemView.layer.anchorPoint.y = 0.0

        return itemView
    }
    
    @objc func carousel(_ carousel:iCarousel, didSelectItemAt index:Int)
    {
        //TODO: grow!
        print("selected:"+String(index))
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat
    {
        if (option == .spacing)
        {
            return value * 1.1
        }
        return value
    }
}
