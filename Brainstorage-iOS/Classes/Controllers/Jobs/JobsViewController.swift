//
//  JobsViewController.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class JobsViewController: BaseTableViewController, JobsFilterProtocol {
    
    var items : [Job] = [Job]()
    var isRefreshing : Bool = false
    
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
        self.setTitleForPage(titleString: "Вакансии")
        
        var backItem = UIBarButtonItem(title: "", style: .Bordered, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        var className : String = "JobCell"
        self.table?.registerNib(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
        self.table?.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        self.table?.rowHeight = UITableViewAutomaticDimension;
        self.table?.estimatedRowHeight = 44
        self.table?.contentInset = UIEdgeInsetsMake(64.0, 0.0, 64.0, 0.0);
        self.table?.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, 0.0, 64.0, 0.0);
        self.setContentInset()
        
        self.table?.addPullToRefresh({ () -> () in
            self.isRefreshing = true
            self.refresh()
        })
        
        self.loadMore()
    }
    
    
    func actionOpenFilter(sender:UIButton) {
        clickAnimationNormal(sender)
        var vc : UINavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("JobsFilterViewControllerContainer") as UINavigationController
        (vc.topViewController as JobsFilterViewController).delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func clickAnimationNormal(sender:UIButton) {
        UIView.animateWithDuration(
            0.05,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(0.7, 0.7)
            },
            completion: nil)
        UIView.animateWithDuration(
            0.2,
            delay: 0.05,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(1, 1)
            },
            completion: nil)
    }
    
    func setupNavBar() {
        var filterButton : UIButton = UIButton(frame: CGRectMake(0, 0, 24, 24))
        filterButton.setImage(UIImage(named: "filter"), forState: UIControlState.Normal)
        filterButton.addTarget(self, action: Selector("actionOpenFilter:"), forControlEvents: UIControlEvents.TouchUpInside)
        filterButton.addTarget(self, action: Selector("clickAnimationNormal:"), forControlEvents: UIControlEvents.TouchUpOutside)        
        var barButtonItem : UIBarButtonItem = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
    }
    
    func successLoading(objects : [AnyObject]) {
        
        self.items += objects as [Job]
        self.table?.reloadData()
        
        self.hideLoading()
        self.isPageLoading = false
        
        UIView.animateWithDuration(0.3,
            delay:0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.emptyView.alpha = (self.items.count>0) ? 0 : 1
            }, completion: nil)
    }
    
    override func loadMore() {
        
        super.loadMore()
        self.showLoading()
        
        RequestClient.sharedInstance.jobs(JobFilter.sharedInstance, success: {(objects : [AnyObject]) in
            
            self.successLoading(objects)
            
            }, failure: {(error : NSError) in
        })
    }
    
    override func refresh() {
        JobFilter.sharedInstance.page = 1
        self.items = [Job]()
        self.loadMore()
        
    }
    
    override func showLoading() {
        if (self.isRefreshing == false) {
            super.showLoading()
        }
    }
    
    override func hideLoading() {
        if (self.isRefreshing) {
            self.table?.stopPullToRefresh()
            self.isRefreshing = false
        } else {
            super.hideLoading()
        }
    }

    
    override func shouldWillLoadMore(cell: UITableViewCell, indexPath: NSIndexPath) -> Bool {
        if (indexPath.row == self.items.count - 1) && self.isPageLoading == false {
            println("indexPath: \(indexPath.row)")
            return true
        }
        return false
    }
    
    // TableView Delegate
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier : String = "JobCell"
        var cell : JobCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as JobCell
        cell.job = self.items[indexPath.row] as Job
        return cell
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var job = self.items[indexPath.row]
        
        var width: Float = Float(self.view.frame.size.width) - 30.0 - 50.0
        var height : Float = JobCell.height(job, width: width)
        return CGFloat(height)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var vc : JobViewController = self.storyboard?.instantiateViewControllerWithIdentifier("JobViewController") as JobViewController
        vc.job = self.items[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func filterDidUpdated() {
        self.refresh()
    }

}
