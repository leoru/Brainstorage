//
//  JobsFilterViewController.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

protocol JobsFilterProtocol : NSObjectProtocol {
    func filterDidUpdated()
}

class JobsFilterViewController: UITableViewController {
    
    @IBOutlet weak var fieildQuery: UITextField!
    @IBOutlet weak var fieldCategories: UITextField!
    
    @IBOutlet weak var switchFulltime: UISwitch!
    @IBOutlet weak var switchContract: UISwitch!
    @IBOutlet weak var switchFreelance: UISwitch!
    
    weak var delegate : JobsFilterProtocol?
    
    var filter : JobFilter = JobFilter.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateFilter()
    }
    
    func setup() {
        self.navigationItem.title = "Фильтр"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Bordered, target: nil, action: nil)
        self.fieildQuery.addTarget(self, action: Selector("queryFieldChanged"), forControlEvents: UIControlEvents.EditingChanged)
        var closeButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.Done, target: self, action: Selector("actionCloseFilter"))
        self.navigationItem.rightBarButtonItem = closeButtonItem
    }
    
    func updateFilter() {
        
     //   if (self.filter.query != "") {
            self.fieildQuery.text = self.filter.query
     //   }
        
        var selectedCategories = self.filter.selectedCategories()
        if (selectedCategories.count > 0) {
            self.fieldCategories.text = "Выбрано \(selectedCategories.count) из 9"
        } else {
            self.fieldCategories.text = "Выберите раздел"
        }
        
        self.switchFulltime.on = self.filter.fulltime
        self.switchContract.on = self.filter.contract
        self.switchFreelance.on = self.filter.freelance
        
    }
    
    func actionCloseFilter() {
        self.dismissViewControllerAnimated(true, completion: nil)
        if ((self.delegate?) != nil) {
            self.delegate?.filterDidUpdated()
        }
    }
    
    // Actions
    
    @IBAction func changeSwitchFreelance(sender: AnyObject) {
        self.filter.freelance = self.switchFreelance.on
    }
    
    @IBAction func changeSwitchContract(sender: AnyObject) {
        self.filter.contract = self.switchContract.on
    }
    
    @IBAction func changeSwitchFulltime(sender: AnyObject) {
        self.filter.fulltime = self.switchFulltime.on
    }
    
    @IBAction func clearFilter(sender: AnyObject) {
        self.filter.freelance = false
        self.filter.contract = false
        self.filter.fulltime = false;
        self.filter.query = "";
        for item in self.filter.selectedCategories(){
            item.selected=false;
        }
        
        self.updateFilter();
    }
    
    // UITextField Text Changed Event
    
    func queryFieldChanged() {
        self.filter.query = self.fieildQuery.text
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 2) {
            tableView.deselectRowAtIndexPath(indexPath, animated:false)
            var vc : JobCategoriesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("JobCategoriesViewController") as JobCategoriesViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
