//
//  BaseTabBarViewController.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.whiteColor();
        self.tabBar.tintColor = bs_redColor;
        self.tabBar.backgroundColor = UIColor.whiteColor();
        self.tabBar.shadowImage = UIImage(named: "tabBar_Border");
        self.tabBar.translucent=false;
        
        var offset = UIOffset(horizontal: 0, vertical: -4);
        (self.tabBar.items![0] as! UITabBarItem).selectedImage = UIImage(named: "vacancy_active");
        (self.tabBar.items![0] as! UITabBarItem).setTitlePositionAdjustment(offset);
        
        (self.tabBar.items![1] as! UITabBarItem).selectedImage = UIImage(named: "about_active");
        (self.tabBar.items![1] as! UITabBarItem).setTitlePositionAdjustment(offset);
    }
   
}
