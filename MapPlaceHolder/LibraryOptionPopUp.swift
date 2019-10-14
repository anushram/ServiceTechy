//
//  LibraryOptionPopUp.swift
//  Technician
//
//  Created by K Saravana Kumar on 19/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class LibraryOptionPopUp: UIView {
    
    @IBOutlet weak var photoLibrarybtn: UIButton!
    @IBOutlet weak var cameraLibrarybtn: UIButton!
    
    @IBOutlet weak var cancelbtn: UIButton!
    
    class func instanceFromNib() -> LibraryOptionPopUp {
        
        return UINib(nibName: "LibraryOptionPopUp", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LibraryOptionPopUp
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
