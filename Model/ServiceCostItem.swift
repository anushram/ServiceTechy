//
//  ServiceCostItem.swift
//  Technician
//
//  Created by K Saravana Kumar on 21/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class ServiceCostItem: Mappable {
    
    var companyId: Int
    var id: Int
    var costtype: String
    var costperhour: Double
    var description: String
    var fixedcost: Double
    var servicename: String
    var taxsettings: NSDictionary
    var taxsettingsId: Int
    
    
    convenience required init?(map: Map) {
        self.init()
        
    }
    
    init() {
        
        self.companyId = 0
        self.id = 0
        self.costtype = ""
        self.costperhour = 0.0
        self.description = ""
        self.fixedcost = 0.0
        self.servicename = ""
        self.taxsettings = NSDictionary()
        self.taxsettingsId = 0
        
    }
    
    func mapping(map: Map) {
        
        self.companyId <- map["companyId"]
        self.id <- map["id"]
        self.costtype <- map["costtype"]
        self.costperhour <- map["costperhour"]
        self.description <- map["description"]
        self.fixedcost <- map["fixedcost"]
        self.servicename <- map["servicename"]
        self.taxsettings <- map["taxsettings"]
        self.taxsettingsId <- map["taxsettingsId"]
        
    }

}
