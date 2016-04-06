//
//  PTTableViewController.swift
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

public class PTTableViewController: UITableViewController {
  
  internal var currentCell: ParallaxCell?
  
  internal var currentSeparatorView: MovingView? // separator witch move up to navigation bar
  
  private var duration: Double = 0.65
  private var currentTextLabel: MovingLabel?
}

// MARK: public

public extension PTTableViewController {
  
  public func pushViewController(viewController: PTDetailViewController) {
    
    guard let currentCell = currentCell,
    let navigationController = self.navigationController else {
      fatalError("current cell is empty or add navigationController")
    }
    
    self.currentTextLabel = createTitleLable(currentCell)
    currentTextLabel?.move(duration, direction: .Up, completion: nil)
    
    currentSeparatorView = createSeparator(currentCell.separatorView?.backgroundColor, height: 2, cell: currentCell)
    currentSeparatorView?.move(duration, direction: .Down, distance: tableView.bounds.size.height)
    
    currentCell.openCell(tableView, duration: duration)
    moveCells(tableView, currentCell: currentCell, duration: duration)
    if let bgImage = currentCell.bgImage?.image {
      viewController.bgImage   = bgImage
    }
    if let text = currentCell.parallaxTitle?.text {
      viewController.titleText = text
    }
    delay(duration) {
      navigationController.pushViewController(viewController, animated: false)
    }
  }
}

// MARK: life cicle

extension PTTableViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    tableView.separatorStyle = .None
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    moveCellsBackIfNeed(duration) {
      self.tableView.reloadData()
    }
    closeCurrentCellIfNeed(duration)
    moveDownCurrentLabelIfNeed()
    moveSeparatorIfNeed()
  }
}

// MARK: create

extension PTTableViewController {
  
  private func createTitleLable(cell: ParallaxCell) -> MovingLabel {
    
    let yPosition = cell.frame.origin.y + cell.frame.size.height / 2.0 - 22 - tableView.contentOffset.y
    let label = MovingLabel(frame: CGRect(x: 0, y: yPosition, width: UIScreen.mainScreen().bounds.size.width, height: 44))
    label.textAlignment = .Center
    label.backgroundColor = .clearColor()
    if let font = cell.parallaxTitle?.font,
      let text = cell.parallaxTitle?.text,
      let textColor = cell.parallaxTitle?.textColor {
      label.font = font
      label.text = text
      label.textColor = textColor
    }
    
    navigationController?.view.addSubview(label)
    return label
  }
  
  private func createSeparator(color: UIColor?, height: CGFloat, cell: UITableViewCell) -> MovingView {
    
    let yPosition = cell.frame.origin.y + cell.frame.size.height - tableView.contentOffset.y
    let separator = MovingView(frame: CGRect(x:0.0, y: yPosition, width: tableView.bounds.size.width, height: height))
    if let color = color {
      separator.backgroundColor = color
    }
    separator.translatesAutoresizingMaskIntoConstraints = false
    navigationController?.view.addSubview(separator)
    return separator
  }
}

// MARK: tableView dataSource

extension PTTableViewController {
  
  final public override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    
    guard let currentCell = tableView.cellForRowAtIndexPath(indexPath) as? ParallaxCell else {
      return indexPath
    }
    
    self.currentCell = currentCell
    return indexPath
  }
}

// MARK: helpers

extension PTTableViewController {
  
  private func parallaxOffsetDidChange(offset: CGFloat) {
    
    for case let cell as ParallaxCell in tableView.visibleCells where cell != currentCell {
      cell.parallaxOffset(tableView)
    }
  }
  
  private func moveCellsBackIfNeed(duration: Double, completion: () -> Void) {
    
    guard let currentCell = self.currentCell,
          let currentIndex = tableView.indexPathForCell(currentCell) else {
      return
    }
    
    for case let cell as ParallaxCell in tableView.visibleCells where cell != currentCell {
      
      if cell.isMovedHidden == false {continue}
      
      if let index = tableView.indexPathForCell(cell) {
        let direction = index.row < currentIndex.row ? ParallaxCell.Direction .Up : ParallaxCell.Direction.Down
        cell.animationMoveCell(direction, duration: duration, tableView: tableView, selectedIndexPaht: currentIndex, close: true)
        cell.isMovedHidden = false
      }
    }
    delay(duration, closure: completion)
  }
  
  private func closeCurrentCellIfNeed(duration: Double) {
    
    guard let currentCell = self.currentCell else {
      return
    }
    
    currentCell.closeCell(duration, tableView: tableView) { () -> Void in
      self.currentCell = nil
    }
  }
  
  private func moveDownCurrentLabelIfNeed() {
    
    guard var currentTextLabel = self.currentTextLabel else {
      return
    }
    currentTextLabel.move(duration, direction: .Down) { (finished) in
      currentTextLabel.removeFromSuperview()
      self.currentTextLabel = nil
    }
  }
  
  private func moveSeparatorIfNeed() {
    
    guard let currentSeparatorView = self.currentSeparatorView else {
      return
    }
    currentSeparatorView.move(duration + 0.01, direction: .Up, distance: 0) { (finished) in
      dispatch_async(dispatch_get_main_queue(), { 
        currentSeparatorView.removeFromSuperview()
        self.currentSeparatorView = nil
      })
    }
  }
  
//  animtaions
  private func moveCells(tableView: UITableView, currentCell: ParallaxCell, duration: Double) {
    
    guard let currentIndex = tableView.indexPathForCell(currentCell) else {
      return
    }
    
    for case let cell as ParallaxCell in tableView.visibleCells where cell != currentCell {
      cell.isMovedHidden = true
      let row = tableView.indexPathForCell(cell)?.row
      let direction = row < currentIndex.row ? ParallaxCell.Direction .Down : ParallaxCell.Direction.Up
      cell.animationMoveCell(direction, duration: duration, tableView: tableView, selectedIndexPaht: currentIndex, close: false)
    }
  }
}

// MARK: ScroolViewDelegate

extension PTTableViewController {
  
  override public func scrollViewDidScroll(scrollView: UIScrollView) {
    parallaxOffsetDidChange(scrollView.contentOffset.y)
  }
}