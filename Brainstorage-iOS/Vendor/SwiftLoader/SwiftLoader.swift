//
//  BSLoader.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 07.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

let loaderFrame : CGRect = CGRectMake(0, 0, 120.0, 120.0)
let loaderSpinnerFrame : CGRect = CGRectMake(35.0, 20.0, 50.0, 50.0)
let loaderSpinnerImageFrame : CGRect = CGRectMake(15.0, 15.0, 30.0, 30.0)
let loaderColor = UIColor(red:0.93, green:0.43, blue:0.39, alpha:1)
let loaderBackgroundColor = UIColor.whiteColor()

class SwiftLoader: UIView {

    var titleLabel : UILabel?
    var loadingView : SwiftLoadingView?
    var animated : Bool?
    
    class func show(view : UIView, title: String, animates : Bool) -> SwiftLoader {
        var hud = SwiftLoader(frame: loaderFrame, containerView: view, title: title, animated: animates)
        hud.start()
        return hud
    }
    
    convenience init(frame: CGRect, containerView : UIView, title: String, animated : Bool) {
        self.init(frame: frame)
        self.animated = animated
        self.titleLabel = UILabel(frame: CGRectMake(0, 70.0, self.frame.width, 42.0))
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(16.0)
        self.titleLabel?.textColor = loaderColor
        self.titleLabel?.textAlignment = NSTextAlignment.Center
        self.titleLabel?.text = title
        self.addSubview(self.titleLabel!)
        containerView.addSubview(self)
        
        self.loadingView = SwiftLoadingView(frame: loaderSpinnerFrame)
        self.addSubview(self.loadingView!)
        
        var height : CGFloat = UIScreen.mainScreen().bounds.size.height
        var width : CGFloat = UIScreen.mainScreen().bounds.size.width
        var center : CGPoint = CGPointMake(width / 2.0, height / 2.0)
        self.center = center
        
    }
    
    class func hide(view : UIView, animated : Bool) {
        var hud : SwiftLoader? = self.hudForView(view)
        hud?.stop()
        if (hud != nil) {
            hud?.removeFromSuperview()
        }
    }
    
    private class func hudForView(view : UIView) -> SwiftLoader {
        var hud : SwiftLoader? = nil
        var subviews  = view.subviews
        for subview in subviews {
            var v = subview as UIView
            if v.isKindOfClass(SwiftLoader) {
                hud = v as? SwiftLoader
                break;
            }
        }
        return hud!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.alpha = 0
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 10.0
    }
    
    private func start() {
        self.loadingView?.start()
        
        if (self.animated!) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 1
            }, completion: { (finished) -> Void in
                
            });
        } else {
            self.alpha = 1
        }
        
    }
    
    private func stop() {
        if (self.animated!) {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.alpha = 0
                }, completion: { (finished) -> Void in
                    
            });
        } else {
            self.alpha = 1
        }
        
        self.loadingView?.stop()
    }
    
    
    
    /**
    *  Loader View
    */
    class SwiftLoadingView : UIView {
        var lineWidth : Float?
        var lineTintColor : UIColor?
        private var backgroundLayer : CAShapeLayer?
        private var isSpinning : Bool?
        
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        private func setup() {
            self.backgroundColor = UIColor.clearColor()
            self.lineWidth = fmaxf(Float(self.frame.size.width) * 0.025, 1)
            
            self.backgroundLayer = CAShapeLayer()
            self.backgroundLayer?.strokeColor = loaderColor.CGColor
            self.backgroundLayer?.fillColor = self.backgroundColor?.CGColor
            self.backgroundLayer?.lineCap = kCALineCapRound
            self.backgroundLayer?.lineWidth = CGFloat(self.lineWidth!)
            self.layer.addSublayer(self.backgroundLayer!)
        }
        
        override func drawRect(rect: CGRect) {
            self.backgroundLayer?.frame = self.bounds
        }
        
        private func drawBackgroundCircle(partial : Bool) {
            var startAngle : CGFloat = CGFloat(M_PI) / CGFloat(2.0)
            var endAngle : CGFloat = (2.0 * CGFloat(M_PI)) + startAngle
            
            var center : CGPoint = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2)
            var radius : CGFloat = (CGFloat(self.bounds.size.width) - CGFloat(self.lineWidth!)) / CGFloat(2.0)
            
            var processBackgroundPath : UIBezierPath = UIBezierPath()
            processBackgroundPath.lineWidth = CGFloat(self.lineWidth!)
            
            if (partial) {
                endAngle = (1.8 * CGFloat(M_PI)) + startAngle
            }
            
            processBackgroundPath.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            self.backgroundLayer?.path = processBackgroundPath.CGPath;
        }
        
        private func start() {
            self.isSpinning? = true
            self.drawBackgroundCircle(true)
            
            var rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotationAnimation.toValue = NSNumber(double: M_PI * 2.0)
            rotationAnimation.duration = 1;
            rotationAnimation.cumulative = true;
            rotationAnimation.repeatCount = HUGE;
            self.backgroundLayer?.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        }
        
        private func stop() {
            self.drawBackgroundCircle(false)
            
            self.backgroundLayer?.removeAllAnimations()
            self.isSpinning? = false
        }
    }
}
