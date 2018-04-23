[![header](./header.png)](https://ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition-logo)
![Animation](./preview.gif)
# Preview-transition
[![Twitter](https://img.shields.io/badge/Twitter-@Ramotion-blue.svg?style=flat)](http://twitter.com/Ramotion)
[![Travis](https://img.shields.io/travis/Ramotion/preview-transition.svg)](https://travis-ci.org/Ramotion/preview-transition.svg?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Ramotion/preview-transition)
[![CocoaPods](https://img.shields.io/cocoapods/p/PreviewTransition.svg)](https://cocoapods.org/pods/PreviewTransition)
[![CocoaPods](https://img.shields.io/cocoapods/v/PreviewTransition.svg)](http://cocoapods.org/pods/PreviewTransition)
[![codebeat badge](https://codebeat.co/badges/b99f71fe-b7e7-4a08-94bd-d98307d176ea)](https://codebeat.co/projects/github-com-ramotion-preview-transition)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/Ramotion)


## About
This project is maintained by Ramotion, Inc.<br>
We specialize in the designing and coding of custom UI for Mobile Apps and Websites.<br>

**Looking for developers for your project?**<br>
This project is maintained by Ramotion, Inc. We specialize in the designing and coding of custom UI for Mobile Apps and Websites.

<a href="https://dev.ramotion.com/?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition-contact-us">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a> <br>

The [iPhone mockup](https://store.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition) available [here](https://store.ramotion.com?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition).

## Requirements

- iOS 9.0+
- Xcode 9

## Licence

Preview-transition is released under the MIT license.
See [LICENSE](./LICENSE) for details.

## Installation

Just add the Source folder to your project or use [CocoaPods](https://cocoapods.org) like this:
``` ruby
pod "PreviewTransition"
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
# Get the Showroom App for iOS to give it a try
Try this UI component and more like this in our iOS app. Contact us if interested.

<a href="https://itunes.apple.com/app/apple-store/id1182360240?pt=550053&ct=preview-transition&mt=8" >
<img src="https://github.com/ramotion/gliding-collection/raw/master/app_store@2x.png" width="117" height="34"></a>
<a href="https://dev.ramotion.com/?utm_source=gthb&utm_medium=special&utm_campaign=preview-transition-contact-us">
<img src="https://github.com/ramotion/gliding-collection/raw/master/contact_our_team@2x.png" width="187" height="34"></a>
<br>
<br>

Follow us for the latest updates<br>
<a href="https://goo.gl/rPFpid" >
<img src="https://i.imgur.com/ziSqeSo.png/" width="156" height="28"></a>
