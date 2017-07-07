//
//  D2Certificate.swift
//  iBun
//
//  Created by h on 07.07.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit
import PDFKit
import SafariServices

class D2Certificate : SKSpriteNode, UIDocumentInteractionControllerDelegate
{
    var viewController:D2Controller? = nil;
    var onPressed:(()->())? = nil;
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    init(scene:SKScene, viewController:D2Controller, onPressed:(()->())?) //constructor needs the scene to be able to scale & position the object in the scene
    {
        self.viewController = viewController;
        self.onPressed = onPressed;
        let texture = SKTexture(imageNamed: "div/pdf");
        let r = (scene.frame.size.width / 5) > (scene.frame.size.height / 5) ? (scene.frame.size.width / 5) : (scene.frame.size.height / 5)
        let size:CGSize = CGSize(width:r, height:r)
        super.init(texture: texture, color: UIColor.clear, size: size)
        self.position = CGPoint(x: (scene.size.width - (size.width / 2)), y: scene.size.height - (self.frame.size.height/2))
        self.isUserInteractionEnabled = true
        
        do
        {
            let rot = SKAction.rotate(byAngle: Math.degree2radian(degree: 360.0*2.0), duration: 0.9)
            self.run(rot)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if((self.onPressed) != nil)
        {
            self.onPressed!();
            return;
        }
        
        let path:String = (URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("certificate.pdf") as NSURL).path!;
        do
        {
            try FileManager.default.removeItem (atPath:path)
        }
        catch let error as NSError
        {
            
        }
        do
        {
            var i:UIImage           = UIImage(named:"div/certificate.png")!;
            var ii:UIImage          = UIImage.init(cgImage: i.cgImage!, scale: 1.0, orientation: .downMirrored);    //rotate!
            var i2:UIImage          = getScreenshot(cert:ii);
            var pdfpage:PDFPage     = PDFPage(image:i2)!;
            var pdfdoc:PDFDocument  = PDFDocument();
            pdfdoc.insert(pdfpage, at: 0);
            pdfdoc.write(toFile:path);
        }
        do
        {
            //Because of sandboxing, other apps could not access any files within your application's Documents folder
            //UIApplication.shared.open(URL(string:path)!, options: [:], completionHandler: nil)
        
            //safaricontroller can only http(s)
            //let svc = SFSafariViewController(url: url)
            //viewController?.present(svc, animated: true, completion: nil)
        
            let url:URL = URL(string:"file://"+path)!
        
            let docController = UIDocumentInteractionController(url:url)
            docController.delegate = self
            docController.presentPreview(animated: true)
            docController.presentOpenInMenu(from: CGRect.zero, in: (viewController?.view)!, animated: true)
        }
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        return self.viewController!;
    }
    func getScreenshot(cert:UIImage) -> UIImage
    {
        let view = (self.viewController?.view)!;
        UIGraphicsBeginImageContext(view.frame.size);
        //UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
        //view.layer.render(in:UIGraphicsGetCurrentContext()!);
        view.drawHierarchy(in: CGRect(x:0,y:0,width:view.frame.size.width, height:view.frame.size.height), afterScreenUpdates:false);
        var image = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        image = UIImage.init(cgImage: image.cgImage!, scale: 1.0, orientation: .downMirrored);    //rotate!
        
        let resizedImage = self.resize(imageToResize: image, certSize:cert.size);
        let rect = CGRect(x: cert.size.width / 4, y: cert.size.height / 5, width: resizedImage.size.width, height: resizedImage.size.height);
        let result = self.imageOntoCert(cert:cert, byDrawingImage: resizedImage, inRect:rect);
        return result;
    }
    private func resize(imageToResize: UIImage, certSize: CGSize) -> UIImage
    {
        let width  = imageToResize.size.width;
        let height = imageToResize.size.height;
        
        var scaleFactor: CGFloat
        
        if(width > height)
        {
            scaleFactor = certSize.height / height;
        }
        else
        {
            scaleFactor = certSize.width / width;
        }
        
        scaleFactor /= 2.5;
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width:width * scaleFactor, height:height * scaleFactor), false, 0.0)
        imageToResize.draw(in: CGRect(x:0, y:0, width:width * scaleFactor, height:height * scaleFactor))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage;
    }
    
    func imageOntoCert(cert:UIImage, byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage
    {
        UIGraphicsBeginImageContext(cert.size)
        cert.draw(in: CGRect(x: 0, y: 0, width: cert.size.width, height: cert.size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result;
    }
}
