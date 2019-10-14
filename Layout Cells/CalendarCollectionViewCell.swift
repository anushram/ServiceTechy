//
//  CalendarCollectionViewCell.swift
//  CalendarView
//
//  Created by K Saravana Kumar on 19/06/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayText: UILabel!
    
    @IBOutlet weak var jobOne: UILabel!
    
    @IBOutlet weak var jobTwo: UILabel!
    
    @IBOutlet weak var jobMidText: UILabel!
    @IBOutlet weak var hiddenTextHeight: NSLayoutConstraint!
    //    override func layoutSubviews() {
//        self.dayText.layer.cornerRadius = self.frame.size.width/2
//        self.dayText.layer.masksToBounds = true
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        self.layer.cornerRadius = 9
        
    }
    
    
}
