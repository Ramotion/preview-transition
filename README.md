![header](./header.png)
# Preview-transition [![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/preview-transition.svg)](https://travis-ci.org/Ramotion/preview-transition.svg?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/preview-transition)
[![CocoaPods](https://img.shields.io/cocoapods/p/PreviewTransition.svg)](https://cocoapods.org/pods/PreviewTransition)
[![CocoaPods](https://img.shields.io/cocoapods/v/PreviewTransition.svg)](http://cocoapods.org/pods/PreviewTransition)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/PreviewTransition.svg)](https://cdn.rawgit.com/Ramotion/preview-transition/master/docs/index.html)
[![codebeat badge](https://codebeat.co/badges/b99f71fe-b7e7-4a08-94bd-d98307d176ea)](https://codebeat.co/projects/github-com-ramotion-preview-transition)

[shot on dribbble](https://dribbble.com/shots/2724735-iOS-Preview-Transition-Open-Source):
<p align="center">
<a href="https://dribbble.com/shots/2694049-iOS-Pagination-Controller-Open-Source"><img src="preview.gif" width="890" height="668" alt="StackViewController Example App" /></a>
</p>

The [iPhone mockup](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition) available [here](https://store.ramotion.com/product/iphone-6-mockups?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition).


## Requirements

- iOS 8.0+
- Xcode 7.3

## Licence

Preview-transition is released under the MIT license.
See [LICENSE](./LICENSE) for details.

Just add the Source folder to your project or use [CocoaPods](https://cocoapods.org) like this:
``` ruby
pod 'PreviewTransition'
```

or [Carthage](https://github.com/Carthage/Carthage) users can simply add to their `Cartfile`:
```
github "Ramotion/preview-transition"
```

## Usage

1) ``` import PreviewTransition ```

2) Create UITableViewController inherit, inheriting from ```PTTableViewController```

3) Add UITableViewDelegate methods

```swift
public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return <RowsCount>
}

public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier(<CellIdentifier>, forIndexPath: indexPath)
}
```

4) add a ParallaxCell

storyboards:
create a cell and inherit from ```ParallaxCell```; don't forget set the identifier ```<CellIdentifier>```

or programmatically:
register a cell in viewDidLoad ```tableView.registerClass(ParallaxCell, forCellReuseIdentifier:<CellIdentifier>)```

5) set cell height

6) create image names (image sizes must be equal to screen size or bigger)

```swift
let images = [image_name, image_name, image_name, image_name, image_name] // image names
```

7) set image and text for ParallaxCell

```swift
public override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

    guard let cell = cell as? ParallaxCell else {
      return
    }

    let imageName = images[indexPath.row]

    if let image = UIImage(named: imageName) {
      cell.setImage(image, title: <SetText>)
    }
}
```
your tableViewController should look like [DemoTableViewController](https://github.com/Ramotion/preview-transition/blob/master/PreviewTransitionDemo/PreviewTransitionDemo/ViewController/DemoTableViewController.swift)

Method ```public override func tableView(tableView: didSelectRowAtIndexPath indexPath:)``` we will add later. (step 10)

8) Create UIViewController, inheriting from ```PTDetailViewController```

9) Add action for backButton and call ```popViewController()```

```swift
func backButtonHandler() {
    popViewController()
}
```

10) Push this UIViewController in UITableViewController. Add method

```swift
public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

  // create viewController
  let <YourViewController> = storyboard?.instantiateViewControllerWithIdentifier(<identifier>)
  if case let viewController as <YourViewController> = viewController {
     pushViewController(viewController)
  }
}
```

11) Configure UINavigationBar

```swift
// transparent background
UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
UINavigationBar.appearance().shadowImage = UIImage()
UINavigationBar.appearance().translucent = true
UINavigationBar.appearance().tintColor = .whiteColor()

// set font
if let font = UIFont(name: <Font name> , size: 18) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : font
      ]
}
```

## About
The project maintained by [app development agency](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition) [Ramotion Inc.](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition)
See our other [open-source projects](https://github.com/ramotion) or [hire](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition) us to design, develop, and grow your product.

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/preview-transition)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)
