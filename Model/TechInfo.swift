//
//  TechInfo.swift
//  Technician
//
//  Created by K Saravana Kumar on 26/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class TechInfo: Mappable {
    
    var id: Int
    var companyid: Int
    var name: String
    var gender: String
    var emailaddress: String
    var password: String
    var mobileno: String
    var address1: String
    var address2: String
    var province: String
    var city: String
    var photo: String
    var startdate: String
    var enddate: String
    var techroleid: Int
    var status:String
    var techcode:String
    var invited: String
    var setpassword: String
    var createddate: String
    var updateddate: String
    
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    init() {
        
        self.id = 0
        self.companyid = 0
        self.name = ""
        self.gender = ""
        self.emailaddress = ""
        self.password = ""
        self.mobileno = ""
        self.address1 = ""
        self.address2 = ""
        self.province = ""
        self.city = ""
        self.photo = ""
        self.startdate = ""
        self.enddate = ""
        self.techroleid = 0
        self.status = ""
        self.techcode = ""
        self.invited = ""
        self.setpassword = ""
        self.createddate = ""
        self.updateddate = ""
        
    }
    
    func mapping(map: Map) {
        
        self.id <- map["id"]
        self.companyid <- map["companyid"]
        self.name <- map["name"]
        self.gender <- map["gender"]
        self.emailaddress <- map["emailaddress"]
        self.password <- map["password"]
        self.mobileno <- map["mobileno"]
        self.address1 <- map["address1"]
        self.address2 <- map["address2"]
        self.province <- map["province"]
        self.city <- map["city"]
        self.photo <- map["photo"]
        self.startdate <- map["startdate"]
        self.enddate <- map["enddate"]
        self.techroleid <- map["techroleid"]
        self.status <- map["status"]
        self.techcode <- map["techcode"]
        self.invited <- map["invited"]
        self.setpassword <- map["setpassword"]
        self.createddate <- map["createddate"]
        self.updateddate <- map["updateddate"]
        
    }
    

}
