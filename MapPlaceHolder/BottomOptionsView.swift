//
//  BottomOptionsView.swift
//  Technician
//
//  Created by K Saravana Kumar on 19/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class BottomOptionsView: UIView {
    
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    class func instanceFromNib() -> BottomOptionsView {
        
        return UINib(nibName: "BottomOptionsView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BottomOptionsView
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
