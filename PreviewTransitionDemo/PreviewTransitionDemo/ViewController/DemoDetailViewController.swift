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
  
  @IBOutlet weak var controlBottomConstrant: NSLayoutConstraint!
  
  // bottom control icons
  @IBOutlet weak var controlsViewContainer: UIView!
  @IBOutlet weak var controlView: UIView!
  @IBOutlet weak var plusImageView: UIImageView!
  @IBOutlet weak var controlTextLabel: UILabel!
  @IBOutlet weak var controlTextLableLending: NSLayoutConstraint!
  @IBOutlet weak var shareImageView: UIImageView!
  @IBOutlet weak var hertIconView: UIImageView!
  
  var backButton: UIButton?
    
  var bottomSafeArea: CGFloat {
    var result: CGFloat = 0
    if #available(iOS 11.0, *) {
      result = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    }
    return result
  }
}

// MARK: life cicle

extension DemoDetailViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    backButton = createBackButton()
    let _ = createNavigationBarBackItem(button: backButton)
    
    // animations
    showBackButtonDuration(duration: 0.3)
    showControlViewDuration(duration: 0.3)
    
     let _ = createBlurView()
  }
}

// MARK: helpers

extension DemoDetailViewController {
  
  fileprivate func createBackButton() -> UIButton {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 44))
    button.setImage(UIImage.Asset.Back.image, for: .normal)
    button.addTarget(self, action: #selector(DemoDetailViewController.backButtonHandler) , for: .touchUpInside)
    return button
  }
  
  fileprivate func createNavigationBarBackItem(button: UIButton?) -> UIBarButtonItem? {
    guard let button = button else {
      return nil
    }
    
    let buttonItem = UIBarButtonItem(customView: button)
    navigationItem.leftBarButtonItem = buttonItem
    return buttonItem
  }
  
  fileprivate func createBlurView() -> UIView {
    let height = controlView.bounds.height + bottomSafeArea
    let imageFrame = CGRect(x: 0, y: view.frame.size.height - height, width: view.frame.width, height: height)
    let image = view.makeScreenShotFromFrame(frame: imageFrame)
    let screnShotImageView = UIImageView(image: image)
    screnShotImageView.blurViewValue(value: 5)
    screnShotImageView.frame = controlsViewContainer.bounds
    screnShotImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    controlsViewContainer.insertSubview(screnShotImageView, at: 0)
    addOverlay(toView: screnShotImageView)
    return screnShotImageView
  }

  fileprivate func addOverlay(toView view: UIView) {
    let overlayView = UIView(frame: view.bounds)
    overlayView.backgroundColor = .black
    overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    overlayView.alpha = 0.4
    view.addSubview(overlayView)
  }
}

// MARK: animations

extension DemoDetailViewController {
  
  fileprivate func showBackButtonDuration(duration: Double) {
    backButton?.rotateDuration(duration: duration, from: -CGFloat.pi / 4, to: 0)
    backButton?.scaleDuration(duration: duration, from: 0.5, to: 1)
    backButton?.opacityDuration(duration: duration, from: 0, to: 1)
  }
  
  fileprivate func showControlViewDuration(duration: Double) {
    moveUpControllerDuration(duration: duration)
    showControlButtonsDuration(duration: duration)
    showControlLabelDuration(duration: duration)
  }
  
  fileprivate func moveUpControllerDuration(duration: Double) {

    controlBottomConstrant.constant = -controlsViewContainer.bounds.height
    view.layoutIfNeeded()
    
    controlBottomConstrant.constant = 0
    UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { 
      self.view.layoutIfNeeded()
    }, completion: nil)
  }

  fileprivate func showControlButtonsDuration(duration: Double) {
    [plusImageView, shareImageView, hertIconView].forEach {
      $0?.rotateDuration(duration: duration, from: CGFloat.pi / 4, to: 0, delay: duration)
      $0?.scaleDuration(duration: duration, from: 0.5, to: 1, delay: duration)
      $0?.alpha = 0
      $0?.opacityDuration(duration: duration, from: 0, to: 1, delay: duration, remove: false)
    }
  }

  fileprivate func showControlLabelDuration(duration: Double) {
    controlTextLabel.alpha = 0
    controlTextLabel.opacityDuration(duration: duration, from: 0, to: 1, delay: duration, remove: false)
    
    // move rigth
    let offSet: CGFloat = 20
    controlTextLableLending.constant -= offSet
    view.layoutIfNeeded()
    
    controlTextLableLending.constant += offSet
    UIView.animate(withDuration: duration * 2, delay: 0, options: .curveEaseOut, animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

// MARK: actions

extension DemoDetailViewController {
  
  @objc func backButtonHandler() {
    popViewController()
  }
}
