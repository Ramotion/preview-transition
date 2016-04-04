//
//  AppDelegate.swift
//  PreviewTransitionDemo
//
//  Created by Alex K. on 04/04/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    configureStatusBar()
    configureNavigationBar()
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    
  }

  func applicationDidEnterBackground(application: UIApplication) {
   
  }

  func applicationWillEnterForeground(application: UIApplication) {
  }

  func applicationDidBecomeActive(application: UIApplication) {
  }

  func applicationWillTerminate(application: UIApplication) {
  }
}

extension AppDelegate {
  
  private func configureNavigationBar() {
    
    UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().translucent = true
    UINavigationBar.appearance().tintColor = .whiteColor()
    
    if let font = UIFont(name: "Avenir-medium" , size: 18) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : font
      ]
    }
    
    guard let navigationController = window?.rootViewController as? UINavigationController else {
      return
    }
    let gradient = getGradientView(CGRect(x: 0,
      y: 0,
      width: UIScreen.mainScreen().bounds.size.width,
      height: navigationController.navigationBar.bounds.size.height))
    navigationController.navigationBar.addSubview(gradient)
  }
  
  private func getGradientView(frame: CGRect) -> UIView {
    let gradientView: UIView = UIView(frame: frame)
    let gradient: CAGradientLayer = CAGradientLayer()
    gradient.frame = gradientView.bounds
    gradient.colors = [UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2).CGColor,
                       UIColor.clearColor().CGColor]
    gradientView.layer.insertSublayer(gradient, atIndex: 0)
    return gradientView
  }
  
  
  private func configureStatusBar() {
    guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
      return
    }
    
    statusBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
    UIApplication.sharedApplication().statusBarStyle = .LightContent
  }
}

