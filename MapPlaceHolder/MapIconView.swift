//
//  MapIconView.swift
//  Technician
//
//  Created by K Saravana Kumar on 05/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class MapIconView: UIView {
    
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var jobImage: UIImageView!
    
    class func instanceFromNib() -> MapIconView {
        return UINib(nibName: "MapIconView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MapIconView
    }
    override init (frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func awakeFromNib() {
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
