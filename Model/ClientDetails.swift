//
//  ClientDetails.swift
//  Technician
//
//  Created by K Saravana Kumar on 21/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class ClientDetails: Mappable {
    
    var address: String
    var city: String
    var clientname: String
    var clientsId: Int
    var country: String
    var description: String
    var email: String
    var mobile: String
    var postcode: String
    
    
    required init?(map: Map) {
        self.address = ""
        self.city = ""
        self.clientname = ""
        self.clientsId = 0
        self.country = ""
        self.description = ""
        self.email = ""
        self.mobile = ""
        self.postcode = ""
    }
    
    func mapping(map: Map) {
        
        self.address <- map["address"]
        self.city <- map["city"]
        self.clientname <- map["clientname"]
        self.clientsId <- map["clientsId"]
        self.description <- map["description"]
        self.email <- map["email"]
        self.mobile <- map["mobile"]
        self.postcode <- map["postcode"]
        
    }
    

}
