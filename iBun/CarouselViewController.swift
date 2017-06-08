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
    var topics:[String:Int] = ["autumn":3, "home":12, "spring":4,"summer":4,"winter":7];
    @IBOutlet var carousel: iCarousel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        carousel.type = .coverFlow
        carousel.dataSource = self
        carousel.delegate = self
        
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
                var image:UIImage? = nil
                var stretch:Bool = true
                if(!stretch)
                {
                    let url : URL = URL.init(fileURLWithPath: path)
                    image = UIImage.animatedImage(withAnimatedGIFURL:url)
                }
                else
                {
                    UIGraphicsBeginImageContext(self.view.frame.size)
                    image = UIImage(named:path)
                    image!.draw(in:self.view.bounds)
                    image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                }
                self.view.backgroundColor = UIColor(patternImage:image!)
            }
            else
            {
                print("ERR: no water");
            }
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int
    {
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
        let topic:(key: String, val: Int) = getTopicAndIndex(index:index)
        let indexWithLeadingZero = topic.val > 9 ? String(topic.val) : String(format: "%02d", topic.val)
        let path = "buns/"+topic.key+indexWithLeadingZero+".png";
        
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
