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


  private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    configureStatusBar()
    configureNavigationBar()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    
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
  
  fileprivate func configureNavigationBar() {
    
    //transparent background
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().tintColor = .white
    
    if let font = UIFont(name: "Avenir-medium" , size: 18) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : font
      ]
    }
  }
  
  fileprivate func configureStatusBar() {
//    guard  let statusBar = (UIApplication.shared.valueForKey("statusBarWindow") as AnyObject).value("statusBar") as? UIView else {
//      return
//    }
//
//    statusBar.backgroundColor = .clearColor()
//    UIApplication.shared.statusBarStyle = .lightContent
  }
}

