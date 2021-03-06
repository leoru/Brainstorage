//
//  JobCell.swift
//  Brainstorage-iOS
//
//  Created by Kirill Kunst on 04.02.15.
//  Copyright (c) 2015 Kirill Kunst. All rights reserved.
//

import UIKit

class JobCell: UITableViewCell {

    var wasSelected : Bool = false;
    var animationcomplete : Bool = true;
    
    var job : Job = Job() {
        didSet {
            update()
        }
    }

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var animationBody: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var start : [CGFloat] = [CGFloat]();
        var end : [CGFloat] = [CGFloat]();
        start = [225/255.0,229/255.0,230/255.0, 1.0];
        end = [1,1,1,1];
        
        var im : UIImage = UIImage.radialGradientImage(self.animationBody.frame.size, startColor: start, endColor: end, centre: CGPointMake(0.3,0.4), radius: 0.7)
        
        var imageview : UIImageView = UIImageView(image: im)
        self.animationBody.addSubview(imageview);
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        self.selected = highlighted;
        if (highlighted) {
            animationcomplete = false;
            UIView.animateWithDuration(0.3,
                delay: 0,
                options: UIViewAnimationOptions.CurveLinear,
                animations: { () -> Void in
                    self.animationBody.transform = CGAffineTransformMakeScale(65, 65);
            }, completion: { (Bool b) -> Void in
                if (!(self.selected)) {
                    self.animationBody.transform = CGAffineTransformMakeScale(0, 0);
                }
                self.animationcomplete = true
            })
            
        } else {
            if (self.animationcomplete) {
                self.animationBody.transform = CGAffineTransformMakeScale(0, 0);
            }
            
        }

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func update() {
        self.title.text = self.job.title
        self.company.text = self.job.companyName
        self.location.text = self.job.locationName
        
        self.icon.sd_setImageWithURL(NSURL(string: self.job.imagePath)!, placeholderImage: UIImage(named: "placeholder")!)
        
        self.title.sizeToFit()
        self.company.sizeToFit()
        self.location.sizeToFit()
    }
    
    class func height(job: Job, width : Float) -> Float {
        var height : Float = 0.0
        var font: UIFont = UIFont(name: "Helvetica Neue", size:15.0)!
        var titleHeight : CGFloat = font.sizeOfString(job.title, constrainedToWidth: Double(width)).height
        
        font = UIFont(name: "Helvetica Neue", size:13.0)!
        var companyHeight : CGFloat = font.sizeOfString(job.companyName, constrainedToWidth: Double(width)).height
        var locationHeight : CGFloat = font.sizeOfString(job.locationName, constrainedToWidth: Double(width)).height
        
        if (job.locationName=="") {
            locationHeight=0;
        }
        
        height = 11.0 + Float(titleHeight) + 3.0 + Float(companyHeight) + 3.0 + Float(locationHeight) + 11.0
        
        if (height<76) {height=76;}
        
        return height
    }
    
}
