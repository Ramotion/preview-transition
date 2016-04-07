# Preview-transision
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/navigation-stack.svg)](https://travis-ci.org/Ramotion/preview-transision.svg?branch=master)
[![CocoaPods](https://img.shields.io/cocoapods/p/PreviewTransition.svg)](https://cocoapods.org/pods/PreviewTransition)
[![CocoaPods](https://img.shields.io/cocoapods/v/PreviewTransition.svg)](http://cocoapods.org/pods/PreviewTransition)
[![codebeat badge](https://codebeat.co/badges/b99f71fe-b7e7-4a08-94bd-d98307d176ea)](https://codebeat.co/projects/github-com-ramotion-preview-transision)

## Requirements

- iOS 8.0+
- Xcode 7.3

## Licence

Preview-transision is released under the MIT license.
See [LICENSE](./LICENSE) for details.

Just add the Source folder to your project.

or use [CocoaPods](https://cocoapods.org) with Podfile:
``` ruby
pod 'PreviewTransition', '~> 0.1.0'
```
## Usage

1) ``` import PreviewTransition ```

2) Create UITableViewController inherit, inheriting from ```PTTableViewController```

3) Add UITableVeiwDelegate methods

```swift
public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return <RowsCoutn>
}

public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return tableView.dequeueReusableCellWithIdentifier(<CellIdentifier>, forIndexPath: indexPath)
}
```
 
4) add ParallaxCell

strorybords: 
create cell and inheriting from ParallaxCell, don't forget set identifier <CellIdentifier>

or programmatically: 
register cell in viewDidLoad ```tableView.registerClass(ParallaxCell, forCellReuseIdentifier:<CellIdentifier>)```

5) set cell height for example 240

6) create image names (image size must be equal screen size or bigger)

let images = [image_name, image_name, image_name, image_name, image_name] // image names

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
your tableViewController must be look like [DemoTableViewController](https://github.com/Ramotion/preview-transision/blob/master/PreviewTransitionDemo/PreviewTransitionDemo/ViewController/DemoTableViewController.swift) 

(method ```public override func tableView(tableView: didSelectRowAtIndexPath indexPath:)``` we will add later)

8) Create UIViewController inherit, inheriting from ```PTDetailViewController```

9) Added action for backButton and call ```popViewController()```

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
if let font = UIFont(name: <Font name> , size: 18) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : font
      ]
}
```

## About
The project maintained by [app development agency](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transision) [Ramotion Inc.](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transision)
See our other [open-source projects](https://github.com/ramotion) or [hire](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transision) us to design, develop, and grow your product.

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/ramotion/preview-transision)
[![Twitter Follow](https://img.shields.io/twitter/follow/ramotion.svg?style=social)](https://twitter.com/ramotion)

