//
//  UIImage+Animating.swift
//  Brainstorage
//
//  Created by Ivan Morozov on 21.04.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import Foundation

extension UIImageView{
    
    func br_startAnimating() {
        self.hidden=false;
        var fullRotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation");
        fullRotation.fromValue = 0
        fullRotation.toValue = ((360*M_PI)/180)
        fullRotation.duration = 0.5;
        fullRotation.repeatCount = HUGE
        self.layer.addAnimation(fullRotation, forKey: "360")
    }
    
    func br_stopAnimating() {
        self.layer.removeAllAnimations();
        self.hidden=true;
    }
}