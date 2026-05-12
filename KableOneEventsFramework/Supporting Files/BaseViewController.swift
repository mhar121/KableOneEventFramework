//
//  BaseViewController.swift
//  KableOneEventsFramework
//
//  Created by Muhammad Haris on 08/01/2026.
//

import UIKit

public class BaseViewController: UIViewController {
    let bgGradientLayer = CAGradientLayer()
  public override func viewDidLoad() {
    super.viewDidLoad()
  
    let customImage = UIImage(named: "navigationbar_logo")
    let imageView = UIImageView(image: customImage)
    imageView.tintColor = UIColor(named: "mainColor")
    imageView.contentMode = .scaleAspectFit
    self.navigationItem.titleView = imageView
    self.navigationItem.backBarButtonItem = UIBarButtonItem()
    
  }

}
