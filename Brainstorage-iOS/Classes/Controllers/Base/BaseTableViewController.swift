//
//  BaseTableViewController.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table : UITableView?
    var footerView : UIView?
    var footerActInd : UIImageView?//UIActivityIndicatorView?
    var isPageLoading : Bool?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isPageLoading = false
        self.registerTableNibsAndClasses()
        self.addFooter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMore() {
        // should be overriden
    }
    
    func refresh() {
        // should be overriden
    }
    
    func showLoading() {
        self.footerView?.hidden = false
        self.table?.tableFooterView = self.footerView
        self.footerActInd?.startAnimating()
    }
    
    func hideLoading() {
        self.footerView?.hidden = true
        self.table?.tableFooterView = nil;
        self.footerActInd?.stopAnimating()
    }
    
    func addPullToRefresh() {
        
    }
    
    func hidePullToRefresh() {
        
    }
    
    func registerTableNibsAndClasses() {
        
    }
    
    func setContentInset() {
        self.table?.contentInset = UIEdgeInsetsMake(64.0, 0.0, 64.0, 0.0);
        self.table?.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, 0.0, 64.0, 0.0);
    }
    
    
    // UI
    
    func addFooter() {
        var footerFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        self.footerView = UIView(frame: footerFrame)
        self.footerView?.backgroundColor = UIColor.clearColor()
        self.footerView?.hidden = false
        self.footerActInd = UIImageView(image: UIImage(named:"indicator"))
        self.footerActInd?.center = CGPointMake(footerFrame.width / 2, footerFrame.height / 2)
        self.footerView?.addSubview(self.footerActInd!)
    }
    
    
    // TableView
    
    func shouldWillLoadMore(cell : UITableViewCell, indexPath : NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if self.isPageLoading! {
            return
        }
        
        if (self.shouldWillLoadMore(cell, indexPath: indexPath)) {
            self.isPageLoading = true
            self.showLoading()
            
            var delayInSeconds : Double = 0.5
            var popTime : dispatch_time_t  = dispatch_time(DISPATCH_TIME_NOW, (Int64)(delayInSeconds * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), { [weak self] () -> Void in
                self!.loadMore()
            })
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}
