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
let bs_orangeColor : UIColor = UIColor(red: 245/255.0, green: 135/255.0, blue: 86/255.0, alpha: 1)
let bs_greenColor : UIColor = UIColor(red: 74/255.0, green: 191/255.0, blue: 180/255.0, alpha: 1)
let bs_blueColor : UIColor = UIColor(red: 51/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1)

class InterfaceManager: NSObject {
    
    class func applyStylesheet() {
        var navbar : UINavigationBar = UINavigationBar.appearance();
        navbar.setBackgroundImage(UIImage(named: "navbar"), forBarMetrics: UIBarMetrics.Default)
        navbar.shadowImage = UIImage(named: "navBar_border");
        let titleDict: NSDictionary = [ NSForegroundColorAttributeName : bs_textColor ];
        navbar.titleTextAttributes = titleDict
        navbar.tintColor = bs_redColor
        navbar.barTintColor = bs_navBarColor
        navbar.translucent = false
    }
   
}
