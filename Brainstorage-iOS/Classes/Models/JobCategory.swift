//
//  JobCategory.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 10.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

var token: dispatch_once_t = 0
var categories: [JobCategory] = [JobCategory]()

class JobCategory: NSObject {
    
    var id : String = ""
    var name : String = ""
    var desc : String = ""
    var selected : Bool = false
    
    override init() {
        super.init()
    }
    
    init(jobCategoryDict : NSDictionary) {
        super.init()
        self.id = jobCategoryDict.objectForKey("id") as! String
        self.name = jobCategoryDict.objectForKey("name") as! String
        self.desc = jobCategoryDict.objectForKey("desc") as! String
    }
    
    class func allCategories() -> [JobCategory] {
        dispatch_once(&token) {
            categories = self.loadCategories()
        }
        return categories
    }
    
    private class func loadCategories() -> [JobCategory] {
        var cats = [JobCategory]()
        var path = NSBundle.mainBundle().pathForResource("categories", ofType: "plist")
        if path != nil {
            var dataDict = NSDictionary(contentsOfFile: path!)
            
            if let data = dataDict {
                var catsArray : [AnyObject] = data["categories"] as! [AnyObject]
                
                for item in catsArray  {
                    let itemDict = item as! NSDictionary
                    var jobCategory = JobCategory(jobCategoryDict: itemDict)
                    cats.append(jobCategory)
                }
            }
        }
        return cats
    }
   
}
