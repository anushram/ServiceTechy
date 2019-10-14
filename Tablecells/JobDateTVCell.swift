//
//  JobDateTVCell.swift
//  Ambassadoor Business
//
//  Created by K Saravana Kumar on 13/09/19.
//  Copyright © 2019 Tesseract Freelance, LLC. All rights reserved.
//

import UIKit

class JobDateTVCell: UITableViewCell {
    
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var jobIDText: UILabel!
    @IBOutlet weak var personNameText: UILabel!
    @IBOutlet weak var mobileNOText: UILabel!
    @IBOutlet weak var cityText: UILabel!
    @IBOutlet weak var desText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
