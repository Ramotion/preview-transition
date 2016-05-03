//
//  LayerAnimationHalper.swift
//  PreviewTransitionDemo
//
//  Created by Alex K. on 03/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

extension UIView {
  
  private func createAnimationFromKey(key: String, duration: Double, from: CGFloat, to: CGFloat, delay: Double = 0, remove: Bool = true) -> CABasicAnimation {
    let animation                 = CABasicAnimation(keyPath: key)
    animation.duration            = duration
    animation.toValue             = to
    animation.fromValue           = from
    animation.timingFunction      = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
    animation.beginTime           = CACurrentMediaTime() + delay
    if remove == false {
      animation.removedOnCompletion = remove
      animation.fillMode            = kCAFillModeForwards
    }
    return animation
  }

  
  func rotateDuration(duration: Double, from: CGFloat, to: CGFloat, delay: Double = 0, remove: Bool = true) {
    let animation = createAnimationFromKey("transform.rotation.z",
                                           duration: duration,
                                           from: from,
                                           to: to,
                                           delay: delay,
                                           remove: remove)
    layer.addAnimation(animation, forKey: nil)
  }
  
  
  func scaleDuration(duration: Double, from: CGFloat, to: CGFloat, delay: Double = 0, remove: Bool = true) {
    let animation = createAnimationFromKey("transform.scale",
                                           duration: duration,
                                           from: from,
                                           to: to,
                                           delay: delay,
                                           remove: remove)
    
    layer.addAnimation(animation, forKey: nil)
  }
  
  
  func opacityDuration(duration: Double, from: CGFloat, to: CGFloat, delay: Double = 0, remove: Bool = true) {
    let animation = createAnimationFromKey("opacity",
                                           duration: duration,
                                           from: from,
                                           to: to,
                                           delay: delay,
                                           remove: remove)
    
    layer.addAnimation(animation, forKey: nil)
  }
}
