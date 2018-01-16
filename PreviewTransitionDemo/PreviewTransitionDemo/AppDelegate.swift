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

  func applicationDidFinishLaunching(_ application: UIApplication) {
    configureNavigationBar()
  }
}

extension AppDelegate {
  
  fileprivate func configureNavigationBar() {
    //transparent background
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().isTranslucent = true
    
    
    if let font = UIFont(name: "Avenir-medium" , size: 18) {
      UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedStringKey.foregroundColor : UIColor.white,
        NSAttributedStringKey.font : font
      ]
    }
  }
}

