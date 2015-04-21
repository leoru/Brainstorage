//
//  RequestClient.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 05.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit
import Alamofire

typealias RequestClientSuccessWithArray = [AnyObject] -> ()
typealias RequestClientSuccessWithObject = String -> ()
typealias RequestClientSuccess = Void -> ()
typealias RequestClientFailure = NSError -> ()

let BrainStorageJobsPath : String = "http://brainstorage.me/jobs"

class RequestClient: NSObject {
    
    class var sharedInstance : RequestClient {
        struct Static {
            static var instance: RequestClient?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = RequestClient()
        }
        
        return Static.instance!
    }
    
    
    func jobs(filter : JobFilter, success : RequestClientSuccessWithArray, failure : RequestClientFailure) {
        Alamofire.request(.GET, BrainStorageJobsPath, parameters:filter.requestParams())
            .response { (request, response, responseData, error) in
                println(request)
                if (error != nil) {
                    failure(error!)
                } else {
                    var parser = Parser(data: responseData as! NSData)
                    var jobs = parser.jobs()
                    success(jobs)
                }
        }
    }
    
    func details(inout job: Job, success : RequestClientSuccess, failure : RequestClientFailure) {
        Alamofire.request(.GET, job.href, parameters: nil)
            .response { (request, response, responseData, error) in
                if (error != nil) {
                    failure(error!)
                } else {
                    var parser = Parser(data: responseData as! NSData)
                    parser.detailsForJob(&job)
                    success()
                    
                }
        }
    }
}
