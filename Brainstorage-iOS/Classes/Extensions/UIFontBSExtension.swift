//
//  NSString+BSAdditions.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 08.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    func sizeOfString(string: NSString, constrainedToWidth width: Double) -> CGSize {
        return string.boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: self],
            context: nil).size
    }
    
}