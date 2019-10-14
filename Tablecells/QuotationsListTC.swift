//
//  QuotationsListTC.swift
//  Technician
//
//  Created by K Saravana Kumar on 04/10/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class QuotationsListTC: UITableViewCell {
    
    @IBOutlet weak var jobID: UILabel!
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var quotationAmt: UILabel!
    @IBOutlet weak var quotationNumber: UILabel!
    @IBOutlet weak var quotationDate: UILabel!
    @IBOutlet weak var qteDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
