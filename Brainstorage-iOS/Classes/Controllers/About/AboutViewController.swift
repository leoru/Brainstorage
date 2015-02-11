//
//  AboutViewController.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleForPage(titleString: "О программе")
    }
    
    @IBAction func actionSendEmail(sender: AnyObject) {
        var url : NSURL = NSURL(string: DeveloperEmail)!
        UIApplication.sharedApplication().openURL(url)
    }
}
