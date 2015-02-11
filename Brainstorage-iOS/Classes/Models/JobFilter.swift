
//
//  JobFilter.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 10.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class JobFilter: NSObject {
    
    var categories : [JobCategory] = JobCategory.allCategories()
    var query : String = ""
    
    var freelance : Bool = false
    var fulltime  : Bool = false
    var contract  : Bool = false
    var page : Int = 1

    class var sharedInstance : JobFilter {
        struct Static {
            static var instance: JobFilter?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = JobFilter()
        }
        return Static.instance!
    }
    
    func selectedCategories() -> [JobCategory] {
        return self.categories.filter({ (job : JobCategory) -> Bool in
            return job.selected
        })
    }
    
    func requestParams() -> [String : AnyObject] {
        var params = [String : AnyObject]()
        if (self.freelance) {
            params["freelance"] = "1"
        }
        if (self.fulltime) {
            params["fulltime"] = "1"
        }
        if (self.freelance) {
            params["contract"] = "1"
        }
        
        if (self.query != "") {
            params["q"] = self.query
        }
        
        var categories = [String]()
        for job in self.selectedCategories() {
            categories.append(job.id)
        }
        
        params["category_ids"] = categories
        params["page"] = "\(self.page)"
        self.page++
        
        return params
    }
    
}
