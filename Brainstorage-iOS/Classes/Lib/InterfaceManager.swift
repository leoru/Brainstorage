//
//  InterfaceManager.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

let bs_navBarColor : UIColor = UIColor(red:0.86, green:0.89, blue:0.89, alpha:1)
let bs_textColor : UIColor = UIColor(red:0.45, green:0.52, blue:0.53, alpha:1)
let bs_redColor : UIColor = UIColor(red:0.93, green:0.43, blue:0.39, alpha:1)

class InterfaceManager: NSObject {
    
    class func applyStylesheet() {
        var navbar : UINavigationBar = UINavigationBar.appearance();
        navbar.setBackgroundImage(UIImage(named: "navbar"), forBarMetrics: UIBarMetrics.Default)
        let titleDict: NSDictionary = [ NSForegroundColorAttributeName : bs_textColor ];
        navbar.titleTextAttributes = titleDict
        navbar.tintColor = bs_redColor
        navbar.barTintColor = bs_navBarColor
    }
   
}
