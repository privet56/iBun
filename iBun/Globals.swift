//
//  Globals.swift
//  iBun
//
//  Created by h on 13.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit
import QuartzCore
import SceneKit

class Globals
{
    static let DEVELOPERMODE:Bool = true;
    
    static let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    static let CollisionCategoryShot   : UInt32 = 0x1 << 2
    static let CollisionCategoryEnemy  : UInt32 = 0x1 << 3
    static let CollisionCategoryTree   : UInt32 = 0x1 << 4
    static let CollisionCategoryFloor  : UInt32 = 0x1 << 5

    static let D3CollisionCategoryFloor  : Int = 1 << 0
    static let D3CollisionCategoryPlayer : Int = 1 << 1
    static let D3CollisionCategoryShot   : Int = 1 << 2
    static let D3CollisionCategoryEnemy  : Int = 1 << 3
    static let D3CollisionCategoryTree   : Int = 1 << 4
    
    class func rand_bool() -> Bool
    {
        let f:UInt32 = arc4random_uniform(2) + 1;
        return f == 1;
    }
    class func rand(min:CGFloat, max:CGFloat) -> CGFloat
    {
        return CGFloat(arc4random_uniform(UInt32(max - min)) + UInt32(min));
    }
    class func node(name:String, ext:String, id:String, flattenGeometry:Bool=false) -> SCNNode
    {
        let path = Bundle.main.path(forResource:name/*"d3.scnassets/landscape"*/, ofType:ext/*"dae"*/)
        let url : URL = URL.init(fileURLWithPath: path!)
        //[SceneKit] Error: COLLADA files are not supported on this platform  ===>  put your dae files into scnassets!
        let sceneSource = SCNSceneSource.init(url: url, options: nil)
        //<geometry id="Grid-mesh" name="Grid">
        let scnNode = sceneSource?.entryWithIdentifier(id/*"Grid"*/, withClass:SCNNode.self);
        if(flattenGeometry)
        {
            scnNode!.geometry = scnNode!.flattenedClone().geometry;
        }
        return scnNode!;
    }
    
    class func matsFromPic(pathFN:String, ext:String) -> [SCNMaterial]
    {
        //let path = Bundle.main.path(forResource:"meadow/meadow"+String(threeOrFive ? "3" : "5"), ofType:"gif")
        let path = Bundle.main.path(forResource:pathFN, ofType:ext)
        let url : URL = URL.init(fileURLWithPath: path!)
        let i:UIImage = UIImage.animatedImage(withAnimatedGIFURL:url)!
        var materials = [SCNMaterial]()
        let material = SCNMaterial()
        material.diffuse.contents = i
        materials.append(material);
        return materials;
    }
    
    class func Log(message: String,
                   file: String = #file,
                   line : Int = #line,
                   function: String = #function)
    {
        let url:URL = URL.init(fileURLWithPath:file);
        //NSLog("\(function) (\(file.lastPathComponent):\(line)): \(message)")      //=swift 2
        NSLog("\(function) (\(url.lastPathComponent):\(line)): \(message)")
    }
    class func uiImage2CVPixelBuffer(from image: UIImage) -> CVPixelBuffer?
    {
        var pixelbuffer: CVPixelBuffer? = nil
    
         CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_OneComponent8, nil, &pixelbuffer)
         CVPixelBufferLockBaseAddress(pixelbuffer!, CVPixelBufferLockFlags(rawValue:0))
    
         let colorspace = CGColorSpaceCreateDeviceGray()
         let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelbuffer!), width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelbuffer!), space: colorspace, bitmapInfo: 0)!
    
        bitmapContext.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        return pixelbuffer;
    }
    
    class func uiImage2CVPixelBuffer1(from image: UIImage) -> CVPixelBuffer?
    {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}

extension UIImage
{
    func resize(to newSize: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newSize.width, height: newSize.height), true, 1.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func pixelBuffer() -> CVPixelBuffer?
    {
        let width = self.size.width
        let height = self.size.height
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs,
                                         &pixelBuffer)
        
        guard let resultPixelBuffer = pixelBuffer, status == kCVReturnSuccess else
        {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(resultPixelBuffer)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(resultPixelBuffer),
                                      space: rgbColorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else
        {
            return nil
        }
        
        context.translateBy(x: 0, y: height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return resultPixelBuffer
    }
}

