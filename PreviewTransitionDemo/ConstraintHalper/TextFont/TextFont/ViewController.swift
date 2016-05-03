//
//  ViewController.swift
//  TextFont
//
//  Created by Alex K. on 03/05/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var lableText: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let animation = CABasicAnimation(keyPath: "fontSize")
    animation.toValue = 10
    animation.duration = 3
    
    let textLayer = CATextLayer()
    textLayer.font = UIFont.systemFontOfSize(50)
    textLayer.fontSize = 50
    textLayer.string = "text"
    textLayer.foregroundColor = UIColor.redColor().CGColor
    textLayer.backgroundColor = UIColor.blackColor().CGColor
    textLayer.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    view.layer.addSublayer(textLayer)
    
    lableText.layer.addAnimation(animation, forKey: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

