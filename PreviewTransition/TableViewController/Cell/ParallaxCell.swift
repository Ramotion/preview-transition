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

/// UITableViewCell with parallax background
open class ParallaxCell: UITableViewCell {
  
  /// Custom separator view
  open var separatorView: UIView?
  
  var topSeparator: UIView? // only for animation
  
  enum Direction {
    case up
    case down
  }
  
  var bgImageY: NSLayoutConstraint?
  
  var parallaxTitleY: NSLayoutConstraint?
  
  /// parallax offset
  @IBInspectable open var difference: CGFloat = 100 // image parallax
  
  var bgImage: UIImageView?
  var parallaxTitle: UILabel?
  
  /// The foreground view’s background color.
  @IBInspectable open var foregroundColor = UIColor.black
  
  /// The foreground view’s alpha.
  @IBInspectable open var foregroundAlpha: CGFloat = 0.5
  
  var foregroundView: UIView?
  var isMovedHidden: Bool = false
  
  fileprivate var closedBgImageYConstant: CGFloat = 0
  fileprivate var closedYPosition: CGFloat = 0
  
  fileprivate var damping: CGFloat = 0.78
  
  /**
   Initializes a view from data in a given unarchiver.
   
   - parameter aDecoder: An unarchiver object.
   
   - returns: An initialized UITableViewCell object.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  
  /**
   Initializes a table cell with a style and a reuse identifier and returns it to the caller.

   - parameter style:           A constant indicating a cell style. See UITableViewCellStyle for descriptions of these constants.
   - parameter reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view. Pass nil if the cell object is not to be reused. You should use the same reuse identifier for all cells of the same form.
   
   - returns: an initialized UITableViewCell object or nil if the object could not be created.
   */
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }
}

// MARK: life cicle

extension ParallaxCell {
  
  func commonInit() {
    
    layer.masksToBounds = false
    selectionStyle = .none
    
    // create background image view
    let backgroundImageView = createBckgroundImage()
    
    // add constraints 
    if let bgSuperView = backgroundImageView.superview {
      for attribute: NSLayoutAttribute in [.leading, .trailing] {
        (bgSuperView, backgroundImageView) >>>- {
          $0.attribute = attribute
          return
        }
      }
      bgImageY = (bgSuperView, backgroundImageView) >>>- {
        $0.attribute = .centerY
        return
      }
      backgroundImageView >>>- {
        $0.attribute = .height
        $0.constant = bounds.height + difference
        return
      }
    }
    bgImage = backgroundImageView
    
    foregroundView = createForegroundView(foregroundColor)
    contentView.backgroundColor = UIColor.black
    
    // create title label
    let titleLabel = createTitleLable()
    for attribute: NSLayoutAttribute in [.left, .right] {
        (contentView, titleLabel) >>>- {
          $0.attribute = attribute
          return
      }
      }
      parallaxTitleY = (contentView, titleLabel) >>>- {
        $0.attribute = .centerY
        return
    }
      titleLabel >>>- {
        $0.attribute = .height
        $0.constant = bounds.height + difference
        return
      }
    parallaxTitle = titleLabel
    
    separatorView = createSeparator(.black, height: 2.0, verticalAttribure: .bottom, verticalConstant: 0.0)
  }
  
  open override func prepareForReuse() {
    if topSeparator?.superview != nil {
      topSeparator?.removeFromSuperview()
      topSeparator = nil
    }
  }
}

// MARK: Methods

public extension ParallaxCell {

  /**
   Sets the contents of the background image and title label
   
   - parameter image: The image object which set to the backgroundImageView
   - parameter title: The text to be displayed in the Cell
   */
  public func setImage(_ image: UIImage, title: String) {
    bgImage?.image = image
    parallaxTitle?.text = title
  }
}

// MARK: internal

extension ParallaxCell {
  
  func parallaxOffset(_ tableView: UITableView) {
    
    guard let bgImageY = self.bgImageY , isMovedHidden == false else {
      return
    }
  
    var deltaY = (frame.origin.y + frame.height/2) - tableView.contentOffset.y
    deltaY = min(tableView.bounds.height, max(deltaY, 0)) // range
    
    var move : CGFloat = (deltaY / tableView.bounds.height)  * difference
    move = move / 2.0  - move

    bgImageY.constant = move
  }
  
  func openCell(_ tableView: UITableView, duration: Double) {
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
    superview.sendSubview(toBack: self)
    
    // animation
    moveToCenter(duration , offset: offsetY)
    parallaxTitle?.isHidden = true
    foregroundHidden(true, duration: duration)
  }
  
  func closeCell(_ duration: Double, tableView: UITableView, completion: @escaping () -> Void) {
    bgImageY?.constant = closedBgImageYConstant
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
      self.layoutIfNeeded()
      self.center = CGPoint(x: self.center.x, y: self.closedYPosition)
      }, completion: {finished in
        
      self.parallaxTitle?.isHidden = false
        completion()
    })
    
    foregroundHidden(false, duration: duration / 2.0)
  }

  func animationMoveCell(_ direction: Direction, duration: Double, tableView: UITableView, selectedIndexPaht: IndexPath, close: Bool) {
    
    let selfYPosition = close == false ? frame.origin.y : closedYPosition
    let selectedCellFrame = tableView.rectForRow(at: selectedIndexPaht)
    var dy: CGFloat = 0
    if selfYPosition < selectedCellFrame.origin.y {
      dy = selectedCellFrame.origin.y - tableView.contentOffset.y
    } else {
      dy = tableView.frame.size.height - (selectedCellFrame.origin.y - tableView.contentOffset.y + selectedCellFrame.size.height)
    }
    dy = direction == .down ? dy * -1 : dy
    if close == false {
      closedYPosition = center.y
    } else {
      center.y = closedYPosition - dy
    }
    
    superview?.bringSubview(toFront: self)
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
      self.center.y = self.center.y + dy
    }, completion: nil)
  }
  
  func showTopSeparator() {
    topSeparator = createSeparator(.black, height: 2, verticalAttribure: .top, verticalConstant: -2)
  }
}

// MARK: animation

extension ParallaxCell {
  
  fileprivate func moveToCenter(_ duration: Double, offset: CGFloat) {
    bgImageY?.constant = 0
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.78, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
      self.frame = CGRect(x: 0, y: offset, width: self.frame.size.width, height: self.frame.size.height)
      self.layoutIfNeeded()
    }, completion: nil)
  }
  
  fileprivate func foregroundHidden(_ hidden: Bool, duration: Double) {
    guard let foregroundView = self.foregroundView else {
      return
    }
    
    if hidden == true {
      let currentConstrant = contentView.constraints.filter{return $0.identifier == "Bottom" ? true : false}
      contentView.removeConstraints(currentConstrant)
      
      foregroundView >>>- {
        $0.attribute = .height
        $0.constant = 64
        $0.identifier = "Height"
        return
      }
    } else {
      let currentConstrant = foregroundView.constraints.filter{return $0.identifier == "Height" ? true : false}
      foregroundView.removeConstraints(currentConstrant)
      
      (contentView, foregroundView) >>>- {
        $0.attribute = .bottom
        $0.identifier = "Bottom"
        return
      }
    }
    
    UIView.animate(withDuration: duration,
                               delay: 0,
                               usingSpringWithDamping: damping * 2.0,
                               initialSpringVelocity: 0,
                               options: UIViewAnimationOptions(),
                               animations: { () -> Void in
      self.layoutIfNeeded()
    }, completion: nil)
  }
}

// MARK: create 

extension ParallaxCell {
  
  fileprivate func createBckgroundImage() -> UIImageView {
    
    let container = createImageContainer()
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .center
    container.addSubview(imageView)
    return imageView
  }
  
  fileprivate func createImageContainer() -> UIView {
    let view = UIView(frame: CGRect.zero)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.masksToBounds = true
    contentView.addSubview(view)
    
    // added constraints
    for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
      (contentView, view) >>>- {
        $0.attribute = attribute
        return
      }
    }
    
    return view
  }

  
  fileprivate func createTitleLable() -> UILabel {
    
    let label = UILabel()
    label.backgroundColor = .clear
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
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
  
  fileprivate func createForegroundView(_ color: UIColor) -> UIView {
    guard let bgImage = self.bgImage else {
      fatalError("set bgImage")
    }
    
    let foregroundView = UIView()
    foregroundView.alpha = foregroundAlpha
    foregroundView.backgroundColor = color
    foregroundView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.insertSubview(foregroundView, aboveSubview: bgImage)
    
    // add constraints 
    for attribute: NSLayoutAttribute in [.left, .right, .top] {
      (contentView, foregroundView) >>>- {
        $0.attribute = attribute
        return
      }
    }
    (contentView, foregroundView) >>>- {
      $0.attribute = .bottom
      $0.identifier = "Bottom"
      return
    }
    
    return foregroundView
  }
  
  // return bottom constraint
  fileprivate func createSeparator(_ color: UIColor, height: CGFloat, verticalAttribure: NSLayoutAttribute, verticalConstant: CGFloat) -> UIView {
    let separator = UIView(frame: CGRect.zero)
    separator.backgroundColor = color
    separator.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(separator)
    
    for attribute: NSLayoutAttribute in [.leading, .trailing] {
      (contentView, separator) >>>- {
        $0.attribute = attribute
        return
      }
    }
    
    (contentView, separator) >>>- {
      $0.attribute = verticalAttribure
      $0.constant = verticalConstant
      return
    }
    // height constraint
    separator >>>- {
      $0.attribute = .height
      $0.constant = height
      return
    }
    return separator
  }
}
