//
//  JobViewController.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 08.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import Foundation
import UIKit

class JobViewController: UITableViewController, UIWebViewDelegate, UIActionSheetDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    @IBOutlet weak var worktimeIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var detailsBrowser: UIWebView!
    
    var detailsHeight : CGFloat?
    
    @IBOutlet weak var detailsCell: UITableViewCell!
    
    var job : Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    
    func setup() {
        self.updateJob()
        
        var filterButton : UIButton = UIButton(frame: CGRectMake(0, 0, 24, 24))
        filterButton.setImage(UIImage(named: "share"), forState: UIControlState.Normal)
        filterButton.addTarget(self, action: Selector("actionOpenShare:"), forControlEvents: UIControlEvents.TouchUpInside)
        filterButton.addTarget(self, action: Selector("clickAnimationNormal:"), forControlEvents: UIControlEvents.TouchUpOutside)
         filterButton.addTarget(self, action: Selector("clickAnimationPush:"), forControlEvents: UIControlEvents.TouchDown)
        
        var barButtonItem : UIBarButtonItem = UIBarButtonItem(customView: filterButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        self.detailsBrowser.delegate = self
        self.detailsBrowser.scrollView.scrollEnabled = false
        detailsHeight = self.detailsBrowser.frame.size.height
        
        SwiftLoader.show(title: "Загрузка...", animated: true)
        RequestClient.sharedInstance.details(&self.job!, success: {
            self.successLoadingDetails()
            }, failure: {(error : NSError) in
                
        })
    }
    
    // actions 
    
    func updateJob() {
        if (self.job != nil) {
            self.titleLabel.text = self.job?.title
            self.locationLabel.text = self.job?.locationName
            self.navigationItem.title = "Вакансии"
            self.workTimeLabel.text = self.job?.occupationName()
            self.workTimeLabel.textColor = self.job?.occupationColor()
            self.worktimeIcon.image = UIImage(named: self.job!.occupationIcon())
            self.dateLabel.text = self.job!.date
            self.viewsLabel.text = self.job!.views
        }
    }
    
    func successLoadingDetails() {
        SwiftLoader.hide()
        self.detailsBrowser.loadHTMLString(HTMLBuilder.htmlForJob(self.job!), baseURL: nil)
        self.updateJob()
    }
    
    func actionOpenShare(sender:UIButton) {
        clickAnimationNormal(sender)
        var actionSheet : UIActionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Отмена", destructiveButtonTitle: nil, otherButtonTitles: "Открыть в браузере", "Скопировать ссылку")
        actionSheet.showInView(self.view)
    }
    
    func clickAnimationNormal(sender:UIButton) {
        UIView.animateWithDuration(
            0.05,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(1.5, 1.5)
            },
            completion: nil)
        UIView.animateWithDuration(
            0.05,
            delay: 0.05,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(1, 1)
            },
            completion: nil)
       }
    
    func clickAnimationPush(sender:UIButton) {
        UIView.animateWithDuration(
            0.05,
            delay: 0,
            options: UIViewAnimationOptions.CurveLinear,
            animations: { () -> Void in
                sender.transform = CGAffineTransformMakeScale(0.8, 0.8)
            },
            completion: nil)
    }

    
    func openBrowser(url : NSURL) {
        var browser = GDWebViewController()
        browser.showToolbar = true
        browser.loadURL(url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 120.0)
        self.navigationController?.pushViewController(browser, animated: true)
    }

    // TableView Delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 2) {
            println(self.detailsHeight)
            return self.detailsHeight!
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    
    // WebView Delegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.sizeToFit()
        detailsHeight = webView.frame.size.height
        self.tableView.reloadData()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (navigationType == UIWebViewNavigationType.LinkClicked) {
            var url = request.URL
            if (url.scheme == "http" || url.scheme == "https") {
                self.openBrowser(url)
                return false
            }
        }
        return true
    }
    
    
    // ActionSheet Delegate
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) {
            UIApplication.sharedApplication().openURL(NSURL(string: self.job!.href)!)
        } else if (buttonIndex == 2) {
            UIPasteboard.generalPasteboard().string = self.job?.href
        }
    }
    
}
