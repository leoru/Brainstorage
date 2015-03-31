//
//  JobCell.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {

    var job : Job = Job() {
        didSet {
            update()
        }
    }

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    private func update() {
        self.title.text = self.job.title
        self.company.text = self.job.companyName
        self.location.text = self.job.locationName
        
        self.icon.sd_setImageWithURL(NSURL(string: self.job.imagePath)!)
        
        self.title.sizeToFit()
        self.company.sizeToFit()
        self.location.sizeToFit()
    }
    
    class func height(job: Job, width : Float) -> Float {
        var height : Float = 0.0
        var font: UIFont = UIFont.boldSystemFontOfSize(16.0)
        var titleHeight : CGFloat = font.sizeOfString(job.title, constrainedToWidth: Double(width)).height
        
        font = UIFont.boldSystemFontOfSize(13.0)
        var companyHeight : CGFloat = font.sizeOfString(job.companyName, constrainedToWidth: Double(width)).height
        var locationHeight : CGFloat = font.sizeOfString(job.locationName, constrainedToWidth: Double(width)).height
        
        height = 15.0 + Float(titleHeight) + 3.0 + Float(companyHeight) + 3.0 + Float(locationHeight) + 15.0
        return height
    }
    
}
