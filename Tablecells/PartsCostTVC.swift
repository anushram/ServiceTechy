//
//  PartsCostTVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 09/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class PartsCostTVC: UITableViewCell {
    
    @IBOutlet weak var partsNo: UITextField!
    @IBOutlet weak var partsName: UITextField!
    @IBOutlet weak var Qty: UITextField!
    @IBOutlet weak var unitPrice: UITextField!
    @IBOutlet weak var cost: UITextField!
    @IBOutlet weak var closeBTN: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
