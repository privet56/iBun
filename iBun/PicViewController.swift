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
    let inceptionv3:Inceptionv3 = Inceptionv3();
    let resnet50:Resnet50 = Resnet50();
    var labelRecognitionResult:UILabel? = nil;
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        if(self.imagePath != nil)
        {
            let img:UIImage = UIImage(named: self.imagePath!)!;
            
            if(self.view is UIImageView)
            {
                print("self.view is imageView")                                             //loaded from the xib/storyboard
                imageView = (self.view as! UIImageView)
                imageView!.image = img;
            }
            else
            {
                print("self.view is "+(String(describing: type(of: self.view!))))           //instantiated without resource bundle
                imageView = UIImageView(image:img)
                let scrollView:UIScrollView = UIScrollView(frame:self.view.bounds)
                scrollView.contentSize = imageView!.bounds.size
                scrollView.minimumZoomScale = 0.1
                scrollView.maximumZoomScale = 4.0
                scrollView.zoomScale = 1.0
                scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                scrollView.addSubview(imageView!)
                self.view.addSubview(scrollView)
                do
                {
                    let lblHeight:CGFloat = 55;
                    let label = UILabel(frame:CGRect(x:0, y:self.view.frame.size.height - lblHeight, width:self.view.frame.size.width, height:lblHeight));
                    //label.center = CGPoint(x:9, y:9)
                    label.textAlignment = .left
                    label.numberOfLines = 0;
                    label.lineBreakMode = .byWordWrapping
                    label.font = UIFont.systemFont(ofSize:16.0);
                    let s:String = " ? \n ?"
                    let attrString:NSMutableAttributedString = NSMutableAttributedString(string:s);
                    label.attributedText = attrString;
                    label.backgroundColor = UIColor.white;
                    //label.text = s;
                    self.view.addSubview(label);
                    self.labelRecognitionResult = label;
                }
            }
            
            imageView!.contentMode = .center
            do
            {
                let pinchRec = UIPinchGestureRecognizer()
                pinchRec.addTarget(self, action: #selector(pinchedView(sender:)))
                let pinchView = imageView!
                pinchView.addGestureRecognizer(pinchRec)
                pinchView.isUserInteractionEnabled  = true
                pinchView.isMultipleTouchEnabled    = true
            }
            do
            {
                var recoResult1:String = "";
                var recoResult2:String = "";
                // Create a work queue to put tasks on
                let concurrentQueue = OperationQueue();
                concurrentQueue.maxConcurrentOperationCount = 2;
                concurrentQueue.qualityOfService = QualityOfService.background;
                let loadingComplete = BlockOperation { () -> Void in
                    DispatchQueue.main.async
                    {
                        self.labelRecognitionResult?.text = recoResult1 + "\n" + recoResult2;
                    }
                }
                var loadingOperations : [Operation] = [];
                let recognize1Operation = BlockOperation { () -> Void in
                    recoResult1 = self.recognize1(img:img);
                }
                let recognize2Operation = BlockOperation { () -> Void in
                    recoResult2 = self.recognize2(img:img);
                }
                loadingOperations.append(recognize1Operation);
                loadingOperations.append(recognize2Operation);
                loadingComplete.addDependency(recognize1Operation);
                loadingComplete.addDependency(recognize2Operation);
                concurrentQueue.addOperations(loadingOperations, waitUntilFinished: false);
                concurrentQueue.addOperation(loadingComplete);
            }
        }
        else
        {
            print("ERR: !imagePath")
        }
    }
    func recognize1(img:UIImage) -> String
    {
        let start = DispatchTime.now()
        do
        {
            defer
            {
                let end = DispatchTime.now();
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let milliSecondsTime    = Int32(Double(nanoTime) / 1_000_000)
                let secondsTime         = Int32(Double(nanoTime) / 1_000_000_000)
                print("recognize1 took \(milliSecondsTime) ms = \(secondsTime) sec");
            }
            
        //input: Image<RGB,299,299>
        //otherwise:
        //  "Input image feature image does not match model description"
        //  "Image is not valid width 299, instead is 1593"
        
        let sizeInception = 299;
        
        guard let cvPixelBuffer:CVPixelBuffer = img.resize(to: CGSize(width: sizeInception, height: sizeInception)).pixelBuffer() else
        {
            print("ERR:recognize1: !img.resize.cvPixelBuffer");
            fatalError()
        }
        if let prediction = try? inceptionv3.prediction(image: cvPixelBuffer)
        {
            let probs = prediction.classLabelProbs.sorted { $0.value > $1.value };
            
            /*for var prob in probs
            {
                let val:Int     = Int(prob.value * 100.00);
                print("\(prob.key) [probability: \(val)%]");
            }*//*
            var i:Int = -1;
            for featureName in prediction.outFeatures!.featureNames
            {
                i+=1;
                print("feature \(i):>\(featureName)<");
            }*/
            
            if let prob = probs.first
            {
                let val:Int     = Int(prob.value * 100.00);
                let name:String = prob.key.capitalized;
                return "\(name) [probability: \(val)%]";
            }
        }
        else
        {
            print("ERR:resize1: !prediction");
        }
        return "";
    }
    }
    func recognize2(img:UIImage) -> String
    {
        let start = DispatchTime.now()
        do
        {
            defer
            {
                let end = DispatchTime.now();
                let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
                let milliSecondsTime    = Int32(Double(nanoTime) / 1_000_000)
                let secondsTime         = Int32(Double(nanoTime) / 1_000_000_000)
                print("recognize2 took \(milliSecondsTime) ms = \(secondsTime) sec");
            }
        let sizeResnet50  = 224;
        
        guard let cvPixelBuffer:CVPixelBuffer = img.resize(to: CGSize(width: sizeResnet50, height: sizeResnet50)).pixelBuffer() else
        {
            print("ERR:recognize2: !img.resize.cvPixelBuffer");
            fatalError()
        }
        
        if let prediction = try? resnet50.prediction(image: cvPixelBuffer)
        {
            let probs = prediction.classLabelProbs.sorted { $0.value > $1.value };
            /*
            var i:Int = -1;
            for featureName in prediction.outFeatures!.featureNames
            {
                i+=1;
                print("recognize2:feature \(i):>\(featureName)<");
            }*/
            
            if let prob = probs.first
            {
                let val:Int     = Int(prob.value * 100.00);
                let name:String = prob.key.capitalized;
                return "\(name) [probability: \(val)%]";
            }
        }
        else
        {
            print("ERR:resize2: !prediction");
        }
        return "";
        }
    }
    
    func pinchedView(sender:UIPinchGestureRecognizer)
    {
        sender.view!.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
