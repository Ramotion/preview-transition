//
//  PTDetailViewController.swift
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

public class PTDetailViewController: UIViewController {
  
  public var bgImage: UIImage?
  public var titleText: String?
  
  private var backgroundImageView: UIImageView?
}

// MARK: life cicle

extension  PTDetailViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    backgroundImageView = createBackgroundImage(bgImage)
    view.backgroundColor = .blackColor()
    
    if let titleText = self.titleText {
      title = titleText
    }
    
    // hack 
    if let navigationController = self.navigationController {
      for case let label as UILabel in navigationController.view.subviews {
        label.hidden = true
      }
    }
  }
}

// MARK: public

extension PTDetailViewController {
  
  public func popViewController() {
    
    if let navigationController = self.navigationController {
      for case let label as UILabel in navigationController.view.subviews {
        label.hidden = false
      }
    }
    navigationController?.popViewControllerAnimated(false)
  }
}

// MARK: create

extension PTDetailViewController {
  
  private func createBackgroundImage(image: UIImage?) -> UIImageView {
    // add constraint closures
    let addConstraint: (imageView: UIImageView, toView: UIView, attribute: NSLayoutAttribute) -> () = {
      (imageView, toView, attribute) in
      let constraint = NSLayoutConstraint(item: imageView,
        attribute: attribute,
        relatedBy: .Equal,
        toItem: toView,
        attribute: attribute,
        multiplier: 1,
        constant: 0)
      toView.addConstraint(constraint)
    }
    
    // crate imageView
    let imageView = UIImageView(frame: CGRect.zero)
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .Center
    view.addSubview(imageView)
    
    // added constraints
    for attribute in [NSLayoutAttribute.Leading, NSLayoutAttribute.Trailing, NSLayoutAttribute.Top, NSLayoutAttribute.Bottom] {
      addConstraint(imageView: imageView, toView: view, attribute: attribute)
    }
    
    return imageView
  }
}