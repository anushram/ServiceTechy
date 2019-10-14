//
//  ServiceCostTVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 21/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class ServiceCostTVC: UITableViewCell {
    
    @IBOutlet weak var serviceType: UITextField!
    @IBOutlet weak var costHrs: UITextField!
    @IBOutlet weak var totalHrs: UITextField!
    @IBOutlet weak var costText: UITextField!
    @IBOutlet weak var closeBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
