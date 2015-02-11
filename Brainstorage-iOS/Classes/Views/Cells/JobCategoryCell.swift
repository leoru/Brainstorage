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
        var selectedBackView = UIView(frame: self.bounds)
        selectedBackView.backgroundColor = bs_navBarColor
        self.selectedBackgroundView = selectedBackView
    }
    
    func update() {
        self.titleLabel.text = self.jobCategory.name
        self.descLabel.text = self.jobCategory.desc
    }
    
}
