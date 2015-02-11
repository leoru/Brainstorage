//
//  HTMLBulder.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 10.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import Foundation
import UIKit

class HTMLBuilder : NSObject {
    
    class func CSS() -> String {
        var css = ""
            css += "body {font-family: Helvetica; background-color:transparent; margin: 0; margin-left: 10px; margin-right: 10px; color: #33485E; font-size: 11pt; }"
            css += " a { color: #EC6259; text-decoration : none; }"
            css += ".instructions { background: #fff8e6; color: #8e856d; margin: 20px -20px 0; padding: 20px 20px; }"
            css += ".instructions .title { font-weight: bold; margin-bottom: 10px; }"
            css += ".about { padding-bottom: 10px; }"
            css += ".about .subtitle { font-weight: bold; margin-top: 10px;  }"
            css += ".about .contacts { margin-top: 10px;}"
            css += ""
        return css
    }
    
    class func htmlForJob(job : Job) -> String {
        println(job.requirements)
        var html : String = ""
                html +=   "<html>"
                html +=   "     <head>"
                html +=   "     <title></title>"
                html +=   "     <style>\(self.CSS())</style></head>"
                html +=   "     <body>"
                html +=   "       \(job.requirements)   "
                html +=   "       \(job.bonuses)   "
                html +=   "       \(job.instructions)   "
                html +=   "       \(job.companyInfo)   "
                html +=   "     </body>"
                html +=   "</html>"
        return html
    }
}
