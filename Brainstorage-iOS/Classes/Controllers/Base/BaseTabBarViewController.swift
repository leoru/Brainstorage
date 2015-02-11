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
        self.tabBar.barTintColor = bs_navBarColor
        self.tabBar.tintColor = bs_redColor
        
        var tabbarItemJobs : UITabBarItem = self.tabBar.items![0] as UITabBarItem
        tabBarItem.selectedImage = UIImage(named: "vacancy_active")
        
        var tabbarItemAbout : UITabBarItem = self.tabBar.items![1] as UITabBarItem
        tabBarItem.selectedImage = UIImage(named: "about_active")
    }
   
}
