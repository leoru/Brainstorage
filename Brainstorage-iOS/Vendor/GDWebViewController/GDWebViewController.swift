//
//  GDWebViewController.swift
//  GDWebBrowserClient
//
//  Created by Alex G on 03.12.14.
//  Copyright (c) 2014 Alexey Gordiyenko. All rights reserved.
//

//MIT License
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import WebKit

enum GDWebViewControllerProgressIndicatorStyle {
    case ActivityIndicator
    case ProgressView
    case Both
    case None
}

@objc protocol GDWebViewControllerDelegate {
    optional func webViewController(webViewController: GDWebViewController, didChangeURL newURL: NSURL?)
    optional func webViewController(webViewController: GDWebViewController, didChangeTitle newTitle: NSString?)
    optional func webViewController(webViewController: GDWebViewController, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void)
    optional func webViewController(webViewController: GDWebViewController, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void);
    optional func webViewController(webViewController: GDWebViewController, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void);
}

class GDWebViewController: UIViewController, WKNavigationDelegate, GDWebViewNavigationToolbarDelegate {
    
    // MARK: Public Properties
    
    /** An object to serve as a delegate which conforms to GDWebViewNavigationToolbarDelegate protocol. */
    weak var delegate: GDWebViewControllerDelegate?
    
    /** The style of progress indication visualization. Can be one of four values: .ActivityIndicator, .ProgressView, .Both, .None*/
    var progressIndicatorStyle: GDWebViewControllerProgressIndicatorStyle = .Both
    
    /** A Boolean value indicating whether horizontal swipe gestures will trigger back-forward list navigations. The default value is false. */
    var allowsBackForwardNavigationGestures: Bool {
        get {
            return webView.allowsBackForwardNavigationGestures
        }
        set(value) {
            webView.allowsBackForwardNavigationGestures = value
        }
    }
    
    /** A boolean value if set to true shows the toolbar; otherwise, hides it. */
    var showToolbar: Bool {
        set(value) {
            self.toolbarHeight = value ? 44 : 0
        }
        
        get {
            return self.toolbarHeight == 44
        }
    }
    
    /** A boolean value if set to true shows the refresh control on the toolbar; otherwise, hides it. */
    var showRefreshControl: Bool {
        get {
            return toolbarContainer.showRefreshControl
        }
        
        set(value) {
            toolbarContainer.showRefreshControl = value
        }
    }
    
    /** The navigation toolbar object (read-only). */
    var toolbar: GDWebViewNavigationToolbar {
        get {
            return toolbarContainer
        }
    }
    
    // MARK: Private Properties
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    private var progressView: UIProgressView!
    private var toolbarContainer: GDWebViewNavigationToolbar!
    private var toolbarHeightConstraint: NSLayoutConstraint!
    private var toolbarHeight: CGFloat = 0
    
    // MARK: Public Methods
    
    /**
    Navigates to an URL created from provided string.
    
    :param: URLString The string that represents an URL.
    */
    
    func loadURLWithString(URLString: String) {
        if let URL = NSURL(string: URLString) {
            if (URL.scheme != nil) && (URL.host != nil) {
                loadURL(URL)
                return
            } else {
                loadURLWithString("http://\(URLString)")
                return
            }
        }
    }
    
    /**
    Navigates to the URL.
    
    :param: URL The URL for a request.
    :param: cachePolicy The cache policy for a request. Optional. Default value is .UseProtocolCachePolicy.
    :param: timeoutInterval The timeout interval for a request, in seconds. Optional. Default value is 0.
    */
    func loadURL(URL: NSURL, cachePolicy: NSURLRequestCachePolicy = .UseProtocolCachePolicy, timeoutInterval: NSTimeInterval = 0) {
        webView.loadRequest(NSURLRequest(URL: URL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval))
    }
    
    /**
    Shows or hides toolbar.
    
    :param: show A Boolean value if set to true shows the toolbar; otherwise, hides it.
    :param: animated A Boolean value if set to true animates the transition; otherwise, does not.
    */
    func showToolbar(show: Bool, animated: Bool) {
        self.showToolbar = show
        
        if toolbarHeightConstraint != nil {
            toolbarHeightConstraint.constant = self.toolbarHeight
            UIView.animateWithDuration(animated ? 0.2 : 0, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    // MARK: GDWebViewNavigationToolbarDelegate Methods
    
    func webViewNavigationToolbarGoBack(toolbar: GDWebViewNavigationToolbar) {
        webView.goBack()
    }
    
    func webViewNavigationToolbarGoForward(toolbar: GDWebViewNavigationToolbar) {
        webView.goForward()
    }
    
    func webViewNavigationToolbarRefresh(toolbar: GDWebViewNavigationToolbar) {
        webView.reload()
    }
    
    // MARK: WKNavigationDelegate Methods
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        animateActivityIdicator(false)
        showError(error.localizedDescription)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        animateActivityIdicator(false)
        showError(error.localizedDescription)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        animateActivityIdicator(false)
        backForwardListChanged()
    }
    
    func webView(webView: WKWebView, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void) {
        delegate?.webViewController?(self, didReceiveAuthenticationChallenge: challenge, completionHandler: { (disposition, credential) -> Void in
            completionHandler(disposition, credential)
        }) ?? completionHandler(.PerformDefaultHandling, nil)
    }
    
    func webView(webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if (progressIndicatorStyle == .ActivityIndicator) || (progressIndicatorStyle == .Both) {
            animateActivityIdicator(true)
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        delegate?.webViewController?(self, decidePolicyForNavigationAction: navigationAction, decisionHandler: { (policy) -> Void in
            decisionHandler(policy)
            if policy == .Cancel {
                self.showError("This navigation is prohibited.")
            }
        }) ?? decisionHandler(WKNavigationActionPolicy.Allow)
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
        delegate?.webViewController?(self, decidePolicyForNavigationResponse: navigationResponse, decisionHandler: { (policy) -> Void in
            decisionHandler(policy)
            if policy == .Cancel {
                self.showError("This navigation response is prohibited.")
            }
        }) ?? decisionHandler(WKNavigationResponsePolicy.Allow)
    }
    
    // MARK: Some Private Methods
    
    private func showError(errorString: String?) {
        var alertView = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    private func animateActivityIdicator(animate: Bool) {
        if animate {
            if activityIndicator == nil {
                activityIndicator = UIActivityIndicatorView()
                activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.2)
                activityIndicator.activityIndicatorViewStyle = .WhiteLarge
                activityIndicator.hidesWhenStopped = true
                activityIndicator.setTranslatesAutoresizingMaskIntoConstraints(false)
                self.view.addSubview(activityIndicator!)
                
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[activityIndicator]-0-|", options: nil, metrics: nil, views: ["activityIndicator": activityIndicator]))
                self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[activityIndicator]-0-|", options: nil, metrics: nil, views: ["activityIndicator": activityIndicator]))
            }
            
            activityIndicator.startAnimating()
        } else if activityIndicator != nil {
            activityIndicator.stopAnimating()
        }
    }
    
    private func progressChanged(newValue: NSNumber) {
        if progressView == nil {
            progressView = UIProgressView()
            progressView.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.view.addSubview(progressView)
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[progressView]-0-|", options: nil, metrics: nil, views: ["progressView": progressView]))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-0-[progressView(2)]", options: nil, metrics: nil, views: ["progressView": progressView, "topGuide": self.topLayoutGuide]))
        }
        
        progressView.progress = newValue.floatValue
        if progressView.progress == 1 {
            progressView.progress = 0
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.progressView.alpha = 0
            })
        } else if progressView.alpha == 0 {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.progressView.alpha = 1
            })
        }
    }
    
    private func backForwardListChanged() {
        toolbarContainer.backButtonItem?.enabled = webView.canGoBack
        toolbarContainer.forwardButtonItem?.enabled = webView.canGoForward
    }
    
    // MARK: KVO
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case "estimatedProgress":
            if (progressIndicatorStyle == .ProgressView) || (progressIndicatorStyle == .Both) {
                if let newValue = change[NSKeyValueChangeNewKey] as? NSNumber {
                    progressChanged(newValue)
                }
            }
        case "URL":
            delegate?.webViewController?(self, didChangeURL: webView.URL)
        case "title":
            delegate?.webViewController?(self, didChangeTitle: webView.title)
        default:
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.edgesForExtendedLayout = UIRectEdge.All
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        // Set up toolbarContainer
        self.view.addSubview(toolbarContainer)
        self.toolbarContainer.frame = CGRectMake(0, self.view.bounds.height - self.toolbarHeight - 64.0, self.view.bounds.width, self.toolbarHeight)
        
        // Set up webView
        self.view.addSubview(webView)
        self.webView.frame = self.view.bounds
        
        self.webView?.scrollView.contentInset = UIEdgeInsetsMake(64.0, 0.0, 64.0, 0.0);
        self.webView?.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, 0.0, 64.0, 0.0);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "URL", options: .New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "URL")
        webView.removeObserver(self, forKeyPath: "title")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        webView.stopLoading()
    }
    


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        toolbarContainer = GDWebViewNavigationToolbar(delegate: self)
        toolbarContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
        
    }

}
