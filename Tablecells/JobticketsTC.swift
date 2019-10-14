//
//  JobticketsTC.swift
//  Technician
//
//  Created by K Saravana Kumar on 27/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class JobticketsTC: UITableViewCell {
    
    @IBOutlet weak var jobIDText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var mobileNOText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var statusBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
