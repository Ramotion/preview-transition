//
//  DemoDetailViewController.swift
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

public class DemoDetailViewController: PTDetailViewController {
  
  @IBOutlet weak var controlHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var controlBottomConstrant: NSLayoutConstraint!
  
  // control icons
  
  @IBOutlet weak var controlView: UIView!
  @IBOutlet weak var plusImageView: UIImageView!
  @IBOutlet weak var controlTextLabel: UILabel!
  @IBOutlet weak var controlTextLableLending: NSLayoutConstraint!
  @IBOutlet weak var shareImageView: UIImageView!
  @IBOutlet weak var hertIconView: UIImageView!
  
  var backButton: UIButton?
}

// MARK: life cicle

extension DemoDetailViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    backButton = createBackButton()
    createNavigationBarBackItem(backButton)
    
    // animations
    showBackButtonDuration(0.3)
    showControlViewDuration(0.3)
    
    createBlurView()
  }
}

// MARK: helpers

extension DemoDetailViewController {
  
  private func createBackButton() -> UIButton {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 44))
    button.setImage(UIImage.Asset.Back.image, forState: .Normal)
    button.addTarget(self, action: #selector(DemoDetailViewController.backButtonHandler) , forControlEvents: .TouchUpInside)
    return button
  }
  
  private func createNavigationBarBackItem(button: UIButton?) -> UIBarButtonItem? {
    guard let button = button else {
      return nil
    }
    
    let buttonItem = UIBarButtonItem(customView: button)
    navigationItem.leftBarButtonItem = buttonItem
    return buttonItem
  }
  
  private func createBlurView() -> UIView {
    let imageFrame = CGRect(x: 0, y: view.frame.size.height - controlHeightConstraint.constant, width: view.frame.width, height: controlHeightConstraint.constant)
    let image = view.makeScreenShotFromFrame(imageFrame)
    let screnShotImageView = UIImageView(image: image)
    screnShotImageView.translatesAutoresizingMaskIntoConstraints = false
    screnShotImageView.blurViewValue(5)
    controlView.insertSubview(screnShotImageView, atIndex: 0)
    // added constraints
    [NSLayoutAttribute.Left, .Right, .Bottom, .Top].forEach { attribute in
      (self.controlView, screnShotImageView) >>>- {
        $0.attribute = attribute
      }
    }
    
    createMaskView(screnShotImageView)
    
    return screnShotImageView
  }

  private func createMaskView(onView: UIView) {
    let blueView = UIView(frame: CGRect.zero)
    blueView.backgroundColor = .blackColor()
    blueView.translatesAutoresizingMaskIntoConstraints = false
    blueView.alpha = 0.4
    onView.addSubview(blueView)
    
    // add constraints
    [NSLayoutAttribute.Left, .Right, .Bottom, .Top].forEach { attribute in
      (onView, blueView) >>>- {
        $0.attribute = attribute
      }
    }
  }
}

// MARK: animations

extension DemoDetailViewController {
  
  private func showBackButtonDuration(duration: Double) {
    backButton?.rotateDuration(duration, from: CGFloat(-M_PI_4), to: 0)
    backButton?.scaleDuration(duration, from: 0.5, to: 1)
    backButton?.opacityDuration(duration, from: 0, to: 1)
  }
  
  private func showControlViewDuration(duration: Double) {
    moveUpControllerDuration(duration)
    showControlButtonsDuration(duration)
    showControlLabelDuration(duration)
  }
  
  private func moveUpControllerDuration(duration: Double) {
    controlBottomConstrant.constant = -controlHeightConstraint.constant
    view.layoutIfNeeded()
    
    controlBottomConstrant.constant = 0
    UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { 
      self.view.layoutIfNeeded()
    }, completion: nil)
  }

  private func showControlButtonsDuration(duration: Double) {
    [plusImageView, shareImageView, hertIconView].forEach {
      $0.rotateDuration(duration, from: CGFloat(-M_PI_4), to: 0, delay: duration)
      $0.scaleDuration(duration, from: 0.5, to: 1, delay: duration)
      
      $0.alpha = 0
      $0.opacityDuration(duration, from: 0, to: 1, delay: duration, remove: false)
    }
  }

  private func showControlLabelDuration(duration: Double) {
    controlTextLabel.alpha = 0
    controlTextLabel.opacityDuration(duration, from: 0, to: 1, delay: duration, remove: false)
    
    // move rigth
    let offSet: CGFloat = 20
    controlTextLableLending.constant -= offSet
    view.layoutIfNeeded()
    
    controlTextLableLending.constant += offSet
    UIView.animateWithDuration(duration * 2, delay: 0, options: .CurveEaseOut, animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

// MARK: actions

extension DemoDetailViewController {
  
  func backButtonHandler() {
    popViewController()
  }
}