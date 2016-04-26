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
  }
  
  private func configureStatusBar() {
    guard  let statusBar = UIApplication.sharedApplication().valueForKey("statusBarWindow")?.valueForKey("statusBar") as? UIView else {
      return
    }

    statusBar.backgroundColor = .clearColor()
    UIApplication.sharedApplication().statusBarStyle = .LightContent
  }
}

