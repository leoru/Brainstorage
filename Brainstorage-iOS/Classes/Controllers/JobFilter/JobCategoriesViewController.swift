//
//  JobCategoriesViewController.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 10.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class JobCategoriesViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Категории"
        
        self.table?.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        var className : String = "JobCategoryCell"
        self.table?.registerNib(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }

    
    // TableView Delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cellIdentifier : String = "JobCategoryCell"
        var cell : JobCategoryCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! JobCategoryCell
        var jobCategory = JobFilter.sharedInstance.categories[indexPath.row]
        cell.jobCategory = jobCategory
        if (jobCategory.selected) {
            cell.Check(true);
        } else {
            cell.Check(false);
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return JobFilter.sharedInstance.categories.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var jobCategory = JobFilter.sharedInstance.categories[indexPath.row]
        
        var width: Float = Float(self.view.frame.size.width) - 59.0
        var height : Float = JobCategoryCell.height(jobCategory, width: width)
        return CGFloat(height)
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell : JobCategoryCell  = tableView.cellForRowAtIndexPath(indexPath) as! JobCategoryCell
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        var jobCategory = JobFilter.sharedInstance.categories[indexPath.row]
        jobCategory.selected = !jobCategory.selected
        
        if (jobCategory.selected) {
             cell.Check(true);
        } else {
            cell.Check(false);
        }
    }

}
