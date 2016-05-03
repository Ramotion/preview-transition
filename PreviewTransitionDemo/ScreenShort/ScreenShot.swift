//
//  ScreenShot.swift
//  PreviewTransitionDemo
//
//  Created by Alex K. on 03/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

extension UIView {
  
  func makeScreenShotFromFrame(frame: CGRect) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
    
    let context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, frame.origin.x * -1, frame.origin.y * -1)
    
    guard let currentContext = UIGraphicsGetCurrentContext() else {
      return nil
    }
    
    self.layer.renderInContext(currentContext)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
}


extension UIImageView {
  
  func blurViewValue(value: CGFloat) {
    guard let image = self.image,
      let blurfilter = CIFilter(name: "CIGaussianBlur"),
      let imageToBlur = CIImage(image: image)
      else {
        return
    }
    
    blurfilter.setValue(value, forKey: kCIInputRadiusKey)
    blurfilter.setValue(imageToBlur, forKey: "inputImage")
    let resultImage = blurfilter.valueForKey("outputImage") as! CIImage
    var blurredImage = UIImage(CIImage: resultImage)
    let cropped:CIImage=resultImage.imageByCroppingToRect(CGRectMake(0, 0,imageToBlur.extent.size.width, imageToBlur.extent.size.height))
    blurredImage = UIImage(CIImage: cropped)
    self.image = blurredImage
  }

}