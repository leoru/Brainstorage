//
//  GDWebViewNavigationToolbar.swift
//  GDWebBrowserClient
//
//  Created by Alex G on 04.12.14.
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

@objc protocol GDWebViewNavigationToolbarDelegate {
    func webViewNavigationToolbarGoBack(toolbar: GDWebViewNavigationToolbar)
    func webViewNavigationToolbarGoForward(toolbar: GDWebViewNavigationToolbar)
    func webViewNavigationToolbarRefresh(toolbar: GDWebViewNavigationToolbar)
}

class GDWebViewNavigationToolbar: UIView {
    
    // MARK: Public Properties
    
    var toolbar: UIToolbar! {
        get {
            return _toolbar
        }
    }
    weak var delegate: GDWebViewNavigationToolbarDelegate?
    var backButtonItem: UIBarButtonItem? {
        get {
            return _backButtonItem
        }
    }
    var forwardButtonItem: UIBarButtonItem? {
        get {
            return _forwardButtonItem
        }
    }
    var refreshButtonItem: UIBarButtonItem? {
        get {
            return _refreshButtonItem
        }
    }
    
    /** The tint color to apply to the toolbar button items.*/
    var toolbarTintColor: UIColor? {
        get {
            return _toolbarTintColor
        }
        
        set(value) {
            _toolbarTintColor = value
            if let toolbar = self.toolbar {
                toolbar.tintColor = _toolbarTintColor
            }
        }
    }
    
    /** The toolbar's background color.*/
    var toolbarBackgroundColor: UIColor? {
        get {
            return _toolbarBackgroundColor
        }
        
        set(value) {
            _toolbarBackgroundColor = value
            if let toolbar = self.toolbar {
                toolbar.backgroundColor = _toolbarBackgroundColor
            }
        }
    }
    
    /** A Boolean value that indicates whether the toolbar is translucent (true) or not (false).*/
    var toolbarTranslucent: Bool {
        get {
            return _toolbarTranslucent
        }
        
        set(value) {
            _toolbarTranslucent = value
            if let toolbar = self.toolbar {
                toolbar.translucent = _toolbarTranslucent
            }
        }
    }
    
    var showRefreshControl: Bool {
        get {
            return _showRefreshControl
        }
        
        set(value) {
            if _toolbar != nil {
                if value && !_showRefreshControl {
                    _toolbar.setItems([_backButtonItem, _forwardButtonItem, _flexibleSpace, _refreshButtonItem], animated: false)
                } else if !value && _showRefreshControl {
                    _toolbar.setItems([_backButtonItem, _forwardButtonItem], animated: false)
                }
            }
            
            _showRefreshControl = value
        }
    }
    
    // MARK: Private Properties
    
    private var _toolbar: UIToolbar!
    private var _backButtonItem: UIBarButtonItem!
    private var _forwardButtonItem: UIBarButtonItem!
    private var _refreshButtonItem: UIBarButtonItem!
    private var _flexibleSpace: UIBarButtonItem!
    private var _toolbarTintColor: UIColor?
    private var _toolbarBackgroundColor: UIColor?
    private var _toolbarTranslucent = true
    private var _showRefreshControl = true
    
    // MARK: Navigation Methods
    func goBack() {
        delegate?.webViewNavigationToolbarGoBack(self)
    }
    
    func goForward() {
        delegate?.webViewNavigationToolbarGoForward(self)
    }
    
    func refresh() {
        delegate?.webViewNavigationToolbarRefresh(self)
    }
    
    // MARK: Life Cycle
    
    init(delegate: GDWebViewNavigationToolbarDelegate) {
        super.init()
        self.delegate = delegate
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (_toolbar == nil) {
            _toolbar = UIToolbar()
            _toolbar.tintColor = _toolbarTintColor
            _toolbar.backgroundColor = _toolbarBackgroundColor
            _toolbar.translucent = _toolbarTranslucent
            _toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(_toolbar)
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[toolbar]-0-|", options: nil, metrics: nil, views: ["toolbar": _toolbar]))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[toolbar]-0-|", options: nil, metrics: nil, views: ["toolbar": _toolbar]))
            
            // Set up _toolbar
            _backButtonItem = UIBarButtonItem(title: "\u{25C0}\u{FE0E}", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
            _backButtonItem.enabled = false
            _forwardButtonItem = UIBarButtonItem(title: "\u{25B6}\u{FE0E}", style: UIBarButtonItemStyle.Plain, target: self, action: "goForward")
            _forwardButtonItem.enabled = false
            _flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
            _refreshButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refresh")
            var items = _showRefreshControl ? [_backButtonItem, _forwardButtonItem, _flexibleSpace, _refreshButtonItem] : [_backButtonItem, _forwardButtonItem]
            _toolbar.setItems(items, animated: false)
        }
    }

}
