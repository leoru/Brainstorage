//
//  Parser.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 05.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

let jobsListNodeID : String = "jobs_list"
let jobsNodesClass : String = "job"

class Parser: NSObject {
    
    var internalParser : HTMLParser?
    
    convenience init(data : NSData) {
        self.init()
        
        var error : NSError? = nil
        var stringData : NSString? = NSString(data: data, encoding: NSUTF8StringEncoding)
        if (stringData != nil) {
            self.internalParser = HTMLParser(html: stringData! as String, error: &error)
        }
    }
    
    func jobs() -> [AnyObject] {
        var bodyNode  = self.internalParser!.body
        var jobs : [Job] = [Job]()
        
        var jobsListNode = bodyNode?.findNodeById(jobsListNodeID)
        if let jobsNodes = jobsListNode?.findChildTagsAttr("div", attrName: "class", attrValue: "job") {
            
            for node in jobsNodes {
                var innerNode = node.findChildTagAttr("div", attrName: "class", attrValue: "inner")
                var hrefNode = innerNode?.findChildTagAttr("a", attrName: "class", attrValue: "job_icon")
                var hrefAttr = hrefNode?.getAttributeNamed("href")
                var imageHrefAttr = hrefNode?.getAttributeNamed("style")
                
                imageHrefAttr = imageHrefAttr?.stringByReplacingOccurrencesOfString("background-image: url(\'", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                imageHrefAttr = imageHrefAttr?.stringByReplacingOccurrencesOfString("\')", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                
                var infoNode = innerNode?.findChildTagAttr("div", attrName: "class", attrValue: "info")
                var occupationsNode = innerNode?.findChildTagAttr("div", attrName: "class", attrValue: "occupations")
                
                var titleNode = infoNode?.findChildTagAttr("div", attrName: "class", attrValue: "title")
                var titleAttr = titleNode?.getAttributeNamed("title")
                
                var metaNode = innerNode?.findChildTagAttr("div", attrName: "class", attrValue: "meta")
                var companyHrefNode = innerNode?.findChildTagAttr("a", attrName: "class", attrValue: "company_name")
                var companyTitleAttr = companyHrefNode?.getAttributeNamed("title")
                
                var locationSpanNode = metaNode?.findChildTagAttr("span", attrName: "class", attrValue: "location")
                var locationHrefNode = locationSpanNode?.findChildTag("a")
                var locationTitleAttr = locationHrefNode?.contents == nil ? "" : locationHrefNode?.contents
                
                var occupationsNodes = occupationsNode?.findChildTagsAttr("div", attrName: "class", attrValue: "occupation")
                var occupations = [String]()
                
                for node in occupationsNodes! {
                    var childs = node.findChildTags("div")
                    var classValue = childs[0].getAttributeNamed("class").componentsSeparatedByString(" ")[0]
                    occupations.append(classValue)
                }
                
                var job = Job(title: titleAttr!, company: companyTitleAttr!, location: locationTitleAttr!, imagePath: imageHrefAttr!, href: hrefAttr!)
                job.occupations = occupations
                jobs.append(job)
                
            }
        }
        
        return jobs
    }
    
    func detailsForJob(inout job : Job) {
        var bodyNode  = self.internalParser!.body
        var bodyDivNode = bodyNode?.findChildTagAttr("div", attrName: "class", attrValue: "body")
        var requirementsNode = bodyDivNode?.findChildTagAttr("div", attrName: "class", attrValue: "requirements")
        job.requirements = requirementsNode!.rawContents
        
        var bonusesNode = bodyDivNode?.findChildTagAttr("div", attrName: "class", attrValue: "bonuses")
        if (bonusesNode) != nil {
            job.bonuses = bonusesNode!.rawContents
        }
        
        var instructionsNode = bodyDivNode?.findChildTagAttr("div", attrName: "class", attrValue: "instructions")
        if (instructionsNode) != nil {
            job.instructions = instructionsNode!.rawContents
        }
        
        var jobMetaNode = bodyNode?.findChildTagAttr("div", attrName: "class", attrValue: "job_meta")
        
        var jobDateNode = jobMetaNode?.findChildTagAttr("div", attrName: "class", attrValue: "date")
        job.date = jobDateNode!.contents.cleanHtmlString()
        
        var jobViewsNode = jobMetaNode?.findChildTagAttr("div", attrName: "class", attrValue: "views")
        job.views = jobViewsNode!.contents.cleanHtmlString()
        
        var companyInfoNode = bodyNode?.findChildTagAttr("div", attrName: "class", attrValue: "section company_info")
        var companyaboutNode = companyInfoNode?.findChildTagAttr("div", attrName: "class", attrValue: "about")
        job.companyInfo = companyaboutNode!.rawContents
        
    }
   
}
