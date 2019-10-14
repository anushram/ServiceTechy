//
//  SelectOptionsObject.swift
//  Technician
//
//  Created by K Saravana Kumar on 25/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class SelectOptionsObject: Mappable {
    
    var role: String
    var statusid: String
    
    
    
    required init?(map: Map) {
        self.role = ""
        self.statusid = ""
        
    }
    
    func mapping(map: Map) {
        
        self.role <- map["role"]
        self.statusid <- map["id"]
        
        
    }

}
