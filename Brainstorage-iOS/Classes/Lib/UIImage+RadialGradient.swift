//
//  UIImage+RadialGradient.swift
//  Brainstorage
//
//  Created by Ivan Morozov on 17.04.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import Foundation

extension UIImage{
    class func radialGradientImage(size:CGSize, startColor:[CGFloat], endColor:[CGFloat] , centre:CGPoint, radius:Float) -> UIImage {
    
        UIGraphicsBeginImageContextWithOptions(size, true, 1);
        // Create the gradient's colours
        var num_locations : size_t  = 2;
        
        var locations : [CGFloat] = [CGFloat]();
        locations = [0.7, 1.0]
        var components : [CGFloat] = [CGFloat]();
        components = [startColor[0] , startColor[1] , startColor[2] , startColor[3] ,
                      endColor[0] , endColor[1] , endColor[2] , endColor[3] ]; // End color
    
    
        var myColorspace : CGColorSpaceRef = CGColorSpaceCreateDeviceRGB();
        var myGradient : CGGradientRef = CGGradientCreateWithColorComponents (myColorspace , components , locations , num_locations);
    
        // Normalise the 0-1 ranged inputs to the width of the image
        var myCentrePoint : CGPoint = CGPointMake(centre.x * size.width, centre.y * size.height);
        var myRadius = (Float)(min(size.width, size.height)) * radius;
    
        // Draw it!
        CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
            0, myCentrePoint, CGFloat(myRadius), CGGradientDrawingOptions(kCGGradientDrawsAfterEndLocation))    
        // Grab it as an autoreleased image
        var image : UIImage = UIGraphicsGetImageFromCurrentImageContext();
    
        // Clean up
        UIGraphicsEndImageContext();
        return image;
    }
}
