//
//  PartsCostItem.swift
//  Technician
//
//  Created by K Saravana Kumar on 20/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class PartsCostItem: Mappable {
    
    var companyId: Int
    var id: Int
    var inventoried: String
    var itemid: String
    var itemname: String
    var price: Double
    var purchasecost: Double
    var quantity: Int
    var taxincluded: String
    var taxsettings: NSDictionary
    var taxsettingsId: Int
    
    
    convenience required init?(map: Map) {
        self.init()
        
    }
    
    init() {
        
        self.companyId = 0
        self.id = 0
        self.inventoried = ""
        self.itemid = ""
        self.itemname = ""
        self.price = 0
        self.purchasecost = 0
        self.quantity = 0
        self.taxincluded = ""
        self.taxsettings = NSDictionary()
        self.taxsettingsId = 0
        
    }
    
    func mapping(map: Map) {
        
        self.companyId <- map["companyId"]
        self.id <- map["id"]
        self.inventoried <- map["inventoried"]
        self.itemid <- map["itemid"]
        self.itemname <- map["itemname"]
        self.price <- map["price"]
        self.purchasecost <- map["purchasecost"]
        self.quantity <- map["quantity"]
        self.taxincluded <- map["taxincluded"]
        self.taxsettings <- map["taxsettings"]
        self.taxsettingsId <- map["taxsettingsId"]
        
    }

}
