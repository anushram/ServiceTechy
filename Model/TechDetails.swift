//
//  TechDetails.swift
//  Technician
//
//  Created by K Saravana Kumar on 26/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class TechDetails: Mappable {
    
    var token: String
    var techinfo: TechInfo
    
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    init() {
        
        self.token = ""
        self.techinfo = TechInfo()
    }
    func mapping(map: Map) {
        self.token <- map["token"]
        self.techinfo <- map["techinfo"]
    }

}
