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

/// Base UIViewController for preview transition
open class PTDetailViewController: UIViewController {

    var bgImage: UIImage?
    var titleText: String?

    fileprivate var backgroundImageView: UIImageView?
}

// MARK: life cicle

extension PTDetailViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView = createBackgroundImage(bgImage)
        view.backgroundColor = .black

        if let titleText = self.titleText {
            title = titleText
        }

        // hack
        if let navigationController = self.navigationController {
            for case let label as UILabel in navigationController.view.subviews {
                label.isHidden = true
            }
        }

        _ = createNavBar(UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
    }
}

// MARK: public

extension PTDetailViewController {

    /**
     Pops the top view controller from the navigation stack and updates the display with custom animation.
     */
    public func popViewController() {

        if let navigationController = self.navigationController {
            for case let label as UILabel in navigationController.view.subviews {
                label.isHidden = false
            }
        }
        _ = navigationController?.popViewController(animated: false)
    }
}

// MARK: create

extension PTDetailViewController {

    fileprivate func createBackgroundImage(_ image: UIImage?) -> UIImageView {

        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = image
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        view.insertSubview(imageView, at: 0)

        return imageView
    }

    fileprivate func createNavBar(_ color: UIColor) -> UIView {
        let navBar = UIView(frame: CGRect.zero)
        navBar.backgroundColor = color
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        for attributes: NSLayoutConstraint.Attribute in [.left, .right, .top] {
            (view, navBar) >>>- {
                $0.attribute = attributes
                return
            }
        }
        navBar >>>- {
            $0.attribute = .height
            var constant: CGFloat = 64
            if #available(iOS 11.0, *) {
                if let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top {
                    constant += topPadding
                }
            }
            $0.constant = constant
            return
        }

        return navBar
    }
}
