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

        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: frame.origin.x * -1, y: frame.origin.y * -1)

        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return nil
        }

        layer.render(in: currentContext)
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
        let resultImage = blurfilter.value(forKey: "outputImage") as! CIImage
        var blurredImage = UIImage(ciImage: resultImage)
        let cropped: CIImage = resultImage.cropped(to: CGRect(x: 0, y: 0, width: imageToBlur.extent.size.width, height: imageToBlur.extent.size.height))
        blurredImage = UIImage(ciImage: cropped)
        self.image = blurredImage
    }
}
