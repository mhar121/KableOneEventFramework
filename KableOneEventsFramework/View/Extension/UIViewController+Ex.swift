//
//  UIViewController+Ex.swift
//  Kableone Sales Person
//
//  Created by Muhammad Haris on 06/12/2024.
//

import UIKit

extension  UIViewController {
   
    func showLoader(loading :String = "Loading",inWindow:Bool = false)
    {
        JustHUD.shared.showInView(view: self.view,withHeader: nil, andFooter: loading)
    }
    
    func hideLoader()
    {
        JustHUD.shared.hide()
    }
}
