//
//  ParallaxCell.swift
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

public class ParallaxCell: UITableViewCell {
  
  internal enum Direction {
    case Up
    case Down
  }
  
  internal var bgImageY: NSLayoutConstraint?
  internal var bgImageHeight: NSLayoutConstraint?
  
  internal var parallaxTitleY: NSLayoutConstraint?
  
  @IBInspectable public var difference: CGFloat = 100 // image parallax
  
  internal var bgImage: UIImageView?
  internal var parallaxTitle: UILabel?
  
  @IBInspectable public var foregroundColor = UIColor.blackColor()
  @IBInspectable public var foregroundAlpha: CGFloat = 0.5
  @IBInspectable public var titleLabelColor = UIColor.whiteColor()
  
  internal var foregroundView: UIView?
  internal var isMovedHidden: Bool = false
  
  private var closedBgImageYConstant: CGFloat = 0
  private var closedYPosition: CGFloat = 0
  
  private var damping: CGFloat = 0.78
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
}

// MARK: life cicle

extension ParallaxCell {
  
  internal func commonInit() {
    
    contentView.layer.masksToBounds = true
    
    // create background image view
    let backgroundImageView = createBckgroundImage()
    bgImageY = addConstraintsOnView(backgroundImageView)
    bgImage = backgroundImageView
    
    // create title label
    let titleLabel = createTitleLable()
    parallaxTitleY = addConstraintsOnView(titleLabel)
    parallaxTitle = titleLabel
    
    foregroundView = createForegroundView(foregroundColor)
    contentView.backgroundColor = UIColor.blackColor()
    
    createSeparator(.blackColor(), height: 2.0)
  }
}

// MARK: public

public extension ParallaxCell {

  public func setImage(image: UIImage, title: String) {
    bgImage?.image = image
    parallaxTitle?.text = title
  }
}

// MARK: internal

internal extension ParallaxCell {
  
  internal func parallaxOffset(tableView: UITableView) {
    
    guard let bgImageY = self.bgImageY where isMovedHidden == false else {
      return
    }
  
    var deltaY = (frame.origin.y + frame.height/2) - tableView.contentOffset.y
    deltaY = min(tableView.bounds.height, max(deltaY, 0)) // range
    
    var move : CGFloat = (deltaY / tableView.bounds.height)  * difference
    move = move / 2.0  - move

    bgImageY.constant = move
  }
  
  internal func openCell(tableView: UITableView, duration: Double) {
    guard let superview = self.superview,
          let bgImageY = self.bgImageY else {
      return
    }
    
    closedBgImageYConstant = bgImageY.constant
    closedYPosition = center.y
    
    let offsetY = tableView.contentOffset.y
    let cellY = frame.origin.y - offsetY + frame.size.height / 2.0 + offsetY - tableView.frame.size.height / 2.0
    let cellFrame = CGRect(x: 0, y: cellY, width: tableView.frame.size.width, height: tableView.frame.size.height)
    frame = cellFrame
    superview.sendSubviewToBack(self)
    
    // animation
    moveToCenter(duration , offset: offsetY)
    parallaxTitle?.hidden = true
    foregroundHidden(true, duration: duration / 2.0)
  }
  
  internal func closeCell(duration: Double, tableView: UITableView, completion: () -> Void) {
    bgImageY?.constant = closedBgImageYConstant
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
      self.layoutIfNeeded()
      self.center = CGPoint(x: self.center.x, y: self.closedYPosition)
      }, completion: {finished in
        
      self.parallaxTitle?.hidden = false
        completion()
    })
    
    foregroundHidden(false, duration: duration / 2.0)
  }

  internal func animationMoveCell(direction: Direction, duration: Double, tableView: UITableView, selectedIndexPaht: NSIndexPath, close: Bool) {
    
    let selfYPosition = close == false ? frame.origin.y : closedYPosition
    let selectedCellFrame = tableView.rectForRowAtIndexPath(selectedIndexPaht)
    var dy: CGFloat = 0
    if selfYPosition < selectedCellFrame.origin.y {
      dy = selectedCellFrame.origin.y - tableView.contentOffset.y
    } else {
      dy = tableView.frame.size.height - (selectedCellFrame.origin.y - tableView.contentOffset.y + selectedCellFrame.size.height)
    }
    dy = direction == .Down ? dy * -1 : dy
    if close == false {
      closedYPosition = center.y
    } else {
      center.y = closedYPosition - dy
    }
    
    superview?.bringSubviewToFront(self)
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
      self.center.y = self.center.y + dy
    }, completion: nil)
  }
}

// MARK: animation

extension ParallaxCell {
  
  private func moveToCenter(duration: Double, offset: CGFloat) {
    bgImageY?.constant = 0
    UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.78, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { () -> Void in
      self.frame = CGRect(x: 0, y: offset, width: self.frame.size.width, height: self.frame.size.height)
      self.layoutIfNeeded()
    }, completion: nil)
  }
  
  private func foregroundHidden(hidden: Bool, duration: Double) {
    UIView.animateWithDuration(duration) { () -> Void in
      self.foregroundView?.alpha = hidden ? 0 : self.foregroundAlpha
    }
  }
}

// MARK: create 

extension ParallaxCell {
  
  private func createBckgroundImage() -> UIImageView {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .Center
    contentView.addSubview(imageView)
    return imageView
  }
  
  private func createTitleLable() -> UILabel {
    let label = UILabel()
    label.backgroundColor = .clearColor()
    label.textColor = titleLabelColor
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .Center
    if case let font as UIFont = UINavigationBar.appearance().titleTextAttributes?[NSFontAttributeName] {
      label.font = font
    }
    contentView.addSubview(label)
    return label
  }
}

// MARK: cofigure

extension ParallaxCell {
  
  // return center constratins
  private func addConstraintsOnView(aView: UIView) -> NSLayoutConstraint? {
    
    var centerConstraint: NSLayoutConstraint?
    var constraints = [NSLayoutConstraint]()
    for attribute in [NSLayoutAttribute.CenterY, NSLayoutAttribute.Leading, NSLayoutAttribute.Trailing] {
      let constraint = NSLayoutConstraint(item: aView,
        attribute: attribute,
        relatedBy: .Equal,
        toItem: aView.superview,
        attribute: attribute,
        multiplier: 1,
        constant: 0)
      constraints.append(constraint)
      
      if attribute == .CenterY {
        centerConstraint = constraint
      }
    }
    aView.superview?.addConstraints(constraints)
    
    let height = NSLayoutConstraint(item: aView,
                               attribute: .Height,
                               relatedBy: .Equal,
                                  toItem: nil,
                               attribute: .Height,
                              multiplier: 1,
                                constant: bounds.height + difference)
    aView.addConstraint(height)
    bgImageHeight = height
    return centerConstraint
  }
  
  private func createForegroundView(color: UIColor) -> UIView {
    guard let bgImage = self.bgImage else {
      fatalError("set bgImage")
    }
    
    let foregroundView = UIView()
    foregroundView.alpha = foregroundAlpha
    foregroundView.backgroundColor = color
    foregroundView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.insertSubview(foregroundView, aboveSubview: bgImage)
    
    // add constraints 
    var constraints = [NSLayoutConstraint]()
    for attribute in [NSLayoutAttribute.Left, NSLayoutAttribute.Right, NSLayoutAttribute.Top, NSLayoutAttribute.Bottom] {
      let constraint = NSLayoutConstraint(item: foregroundView,
                                     attribute: attribute,
                                     relatedBy: .Equal,
                                        toItem: contentView,
                                     attribute: attribute,
                                    multiplier: 1,
                                      constant: 0)
      constraints.append(constraint)
    }
    contentView.addConstraints(constraints)
    
    return foregroundView
  }
  
  // return bottom constraint
  private func createSeparator(color: UIColor, height: CGFloat) {
    let separator = UIView(frame: CGRect.zero)
    separator.backgroundColor = .blackColor()
    separator.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(separator)
    
    for attribute in [NSLayoutAttribute.Bottom, NSLayoutAttribute.Leading, NSLayoutAttribute.Trailing] {
      let constraint = NSLayoutConstraint(item: separator,
        attribute: attribute,
        relatedBy: .Equal,
        toItem: contentView,
        attribute: attribute,
        multiplier: 1,
        constant: 0)
     
      contentView.addConstraint(constraint)
    }
    
    // height constraint 
    separator.addConstraint(
      NSLayoutConstraint(item: separator,
                    attribute: .Height,
                    relatedBy: .Equal,
                    toItem: nil,
                    attribute: .Height,
                    multiplier: 1,
                    constant: height)
    )
  }
}