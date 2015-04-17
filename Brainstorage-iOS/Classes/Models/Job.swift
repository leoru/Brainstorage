//
//  Job.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 05.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class Job: NSObject {
    
    var title : String = ""
    var imagePath : String = ""
    var companyName : String = ""
    var locationName : String = ""
    var occupations : [String] = [String]()
    var requirements : String = ""
    var bonuses: String = ""
    var instructions: String = ""
    var companyInfo: String = ""
    var href : String = ""
    var views : String = ""
    var date: String  = ""
    
    init(title: String, company: String, location: String, imagePath: String, href: String) {
        self.title = title
        self.companyName = company
        self.locationName = location
        self.href = BrainstorageRootUrl.stringByAppendingString(href)
        
        if imagePath.hasPrefix("http") {
            self.imagePath = imagePath
        } else {
            self.imagePath = BrainstorageRootUrl.stringByAppendingString(imagePath)
        }
    }
    
    override init() {
        super.init()
    }
    
    func occupationIcon() -> String! {
        switch self.occupations[0] {
        case "fulltime" :
            return "clock_orange"
        case "freelance" :
            return "clock_blue"
        default:
            return "clock_green"
        }
    }
    
    func occupationName() -> String! {
        switch self.occupations[0] {
        case "fulltime" :
            return "Фуллтайм"
        case "freelance" :
            return "Удаленно"
        default:
            return "Контракт"
        }
    }
    
    func occupationColor() -> UIColor! {
        switch self.occupations[0] {
        case "fulltime" :
            return bs_orangeColor
        case "freelance" :
            return bs_blueColor
        default:
            return bs_greenColor
        }
    }
   
}
