//
//  JobCategoryCell.swift
//  Brainstorage
//
//  Created by Kirill Kunst on 10.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class JobCategoryCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    var jobCategory : JobCategory = JobCategory() {
        didSet {
            update()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func update() {
        self.titleLabel.text = self.jobCategory.name
        self.descLabel.text = self.jobCategory.desc
    }
    
    func Check(isCheck:Bool) {
        UIView.animateWithDuration(0.3,
            delay:0,
            options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.checkMark.alpha = (isCheck) ? 1 : 0
        }, completion: nil)
    }
    
    class func height(jobCategory: JobCategory, width : Float) -> Float {
        var height : Float = 0.0
        var font: UIFont = UIFont(name: "Helvetica Neue", size:13.0)!
        var descHeight : CGFloat = font.sizeOfString(jobCategory.desc, constrainedToWidth: Double(width)).height
        
        
        height = 10.0 + 21.0 + 3.0 + Float(descHeight) + 10.0
        
        return height
    }

    
}
