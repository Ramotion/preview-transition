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
  
  public var separatorView: UIView?
  
  var topSeparator: UIView? // only for animation
  
  enum Direction {
    case Up
    case Down
  }
  
  var bgImageY: NSLayoutConstraint?
  
  var parallaxTitleY: NSLayoutConstraint?
  
  @IBInspectable public var difference: CGFloat = 100 // image parallax
  
  var bgImage: UIImageView?
  var parallaxTitle: UILabel?
  
  @IBInspectable public var foregroundColor = UIColor.blackColor()
  @IBInspectable public var foregroundAlpha: CGFloat = 0.5
  
  var foregroundView: UIView?
  var isMovedHidden: Bool = false
  
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
  
  func commonInit() {
    
    layer.masksToBounds = false
    selectionStyle = .None
    
    // create background image view
    let backgroundImageView = createBckgroundImage()
    
    // add constraints 
    if let bgSuperView = backgroundImageView.superview {
      for attribute: NSLayoutAttribute in [.Leading, .Trailing] {
        (bgSuperView, backgroundImageView) >>>- { $0.attribute = attribute }
      }
      bgImageY = (bgSuperView, backgroundImageView) >>>- { $0.attribute = .CenterY }
      backgroundImageView >>>- {
        $0.attribute = .Height
        $0.constant = bounds.height + difference
      }
    }
    bgImage = backgroundImageView
    
    foregroundView = createForegroundView(foregroundColor)
    contentView.backgroundColor = UIColor.blackColor()
    
    // create title label
    let titleLabel = createTitleLable()
    for attribute: NSLayoutAttribute in [.Left, .Right] {
        (contentView, titleLabel) >>>- { $0.attribute = attribute }
      }
      parallaxTitleY = (contentView, titleLabel) >>>- { $0.attribute = .CenterY }
      titleLabel >>>- {
        $0.attribute = .Height
        $0.constant = bounds.height + difference
      }
    parallaxTitle = titleLabel
    
    separatorView = createSeparator(.blackColor(), height: 2.0, verticalAttribure: .Bottom, verticalConstant: 0.0)
  }
  
  public override func prepareForReuse() {
    if topSeparator?.superview != nil {
      topSeparator?.removeFromSuperview()
      topSeparator = nil
    }
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

extension ParallaxCell {
  
  func parallaxOffset(tableView: UITableView) {
    
    guard let bgImageY = self.bgImageY where isMovedHidden == false else {
      return
    }
  
    var deltaY = (frame.origin.y + frame.height/2) - tableView.contentOffset.y
    deltaY = min(tableView.bounds.height, max(deltaY, 0)) // range
    
    var move : CGFloat = (deltaY / tableView.bounds.height)  * difference
    move = move / 2.0  - move

    bgImageY.constant = move
  }
  
  func openCell(tableView: UITableView, duration: Double) {
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
    foregroundHidden(true, duration: duration)
  }
  
  func closeCell(duration: Double, tableView: UITableView, completion: () -> Void) {
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

  func animationMoveCell(direction: Direction, duration: Double, tableView: UITableView, selectedIndexPaht: NSIndexPath, close: Bool) {
    
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
  
  func showTopSeparator() {
    topSeparator = createSeparator(.blackColor(), height: 2, verticalAttribure: .Top, verticalConstant: -2)
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
    guard let foregroundView = self.foregroundView else {
      return
    }
    
    if hidden == true {
      let currentConstrant = contentView.constraints.filter{return $0.identifier == "Bottom" ? true : false}
      contentView.removeConstraints(currentConstrant)
      
      foregroundView >>>- {
        $0.attribute = .Height
        $0.constant = 64
        $0.identifier = "Height"
      }
    } else {
      let currentConstrant = foregroundView.constraints.filter{return $0.identifier == "Height" ? true : false}
      foregroundView.removeConstraints(currentConstrant)
      
      (contentView, foregroundView) >>>- {
        $0.attribute = .Bottom
        $0.identifier = "Bottom"
      }
    }
    
    UIView.animateWithDuration(duration,
                               delay: 0,
                               usingSpringWithDamping: damping,
                               initialSpringVelocity: 0,
                               options: .CurveEaseInOut,
                               animations: { () -> Void in
      self.layoutIfNeeded()
    }, completion: nil)
  }
}

// MARK: create 

extension ParallaxCell {
  
  private func createBckgroundImage() -> UIImageView {
    
    let container = createImageContainer()
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .Center
    container.addSubview(imageView)
    return imageView
  }
  
  private func createImageContainer() -> UIView {
    let view = UIView(frame: CGRect.zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.masksToBounds = true
    contentView.addSubview(view)
    
    // added constraints
    for attribute: NSLayoutAttribute in [.Left, .Right, .Top, .Bottom] {
      (contentView, view) >>>- { $0.attribute = attribute }
    }
    
    return view
  }

  
  private func createTitleLable() -> UILabel {
    
    let label = UILabel()
    label.backgroundColor = .clearColor()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .Center
    if case let font as UIFont = UINavigationBar.appearance().titleTextAttributes?[NSFontAttributeName] {
      label.font = font
    }
    
    if case let textColor as UIColor = UINavigationBar.appearance().titleTextAttributes?[NSForegroundColorAttributeName] {
      label.textColor = textColor
    }
    contentView.addSubview(label)
    return label
  }
}

// MARK: cofigure

extension ParallaxCell {
  
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
    for attribute: NSLayoutAttribute in [.Left, .Right, .Top] {
      (contentView, foregroundView) >>>- { $0.attribute = attribute }
    }
    (contentView, foregroundView) >>>- {
      $0.attribute = .Bottom
      $0.identifier = "Bottom"
    }
    
    return foregroundView
  }
  
  // return bottom constraint
  private func createSeparator(color: UIColor, height: CGFloat, verticalAttribure: NSLayoutAttribute, verticalConstant: CGFloat) -> UIView {
    let separator = UIView(frame: CGRect.zero)
    separator.backgroundColor = color
    separator.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(separator)
    
    for attribute: NSLayoutAttribute in [.Leading, .Trailing] {
      (contentView, separator) >>>- { $0.attribute = attribute }
    }
    
    (contentView, separator) >>>- {
      $0.attribute = verticalAttribure
      $0.constant = verticalConstant
    }
    // height constraint
    separator >>>- {
      $0.attribute = .Height
      $0.constant = height
    }
    return separator
  }
}