//
//  MovingLabel.swift
//
// Copyright (c)  21/12/15. Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

internal enum MovingDirection {
    case Up
    case Down
}

internal protocol Moving {
  
  var defaultYPosition: CGFloat {get set}
  
  mutating func move(duration: Double, direction: MovingDirection, completion: ((Bool) -> Void)?)
}

extension Moving where Self: UIView {
  
  mutating func move(duration: Double, direction: MovingDirection, completion: ((Bool) -> Void)?) {
    UIView.animateWithDuration(duration,
                               delay: 0,
                               usingSpringWithDamping: 0.78,
                               initialSpringVelocity: 0,
                               options: .CurveEaseInOut,
                               animations: { () -> Void in
      var toYPosition = self.defaultYPosition
      if direction == .Up {
        self.defaultYPosition = self.frame.origin.y
        toYPosition = 20
      }
      self.frame = CGRect(x: 0, y: toYPosition, width: self.frame.size.width, height: self.frame.size.height)
    }, completion: completion)
  }
}

internal class MovingLabel: UILabel, Moving {
  var defaultYPosition: CGFloat = 0
}

internal class MovingView: UIView {
  var defaultYPosition: CGFloat = 0
  
  internal func move(duration: Double, direction: MovingDirection, distance: CGFloat, completion: ((Bool) -> Void)? = nil) {
    var yPosition = defaultYPosition - 2
    if direction == .Down {
      defaultYPosition = frame.origin.y
      yPosition = distance
    }
    UIView.animateWithDuration(duration,
                               delay: 0,
                               usingSpringWithDamping: 0.78,
                               initialSpringVelocity: 0,
                               options: .CurveEaseInOut,
                               animations: { () -> Void in
                                self.frame.origin.y = yPosition
    }, completion: completion)
  }

}
