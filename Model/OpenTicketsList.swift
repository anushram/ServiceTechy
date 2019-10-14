//
//  OpenTicketsList.swift
//  Technician
//
//  Created by K Saravana Kumar on 12/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class OpenTicketsList: Mappable {
    
    var mobile: String
    var clientname: String
    var address: String
    var scheduledate: String
    var jobid: String
    var description: String
    var id: Int
    var scheduleday: String
    var scheduletime: String
    var latitude: String
    var longitude: String
    var jobstatus: String
    var jobstatusid: Int
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    init() {
        
        self.mobile = ""
        self.clientname = ""
        self.address = ""
        self.scheduledate = ""
        self.jobid = ""
        self.description = ""
        self.id = 0
        self.scheduleday = ""
        self.scheduletime = ""
        self.latitude = ""
        self.longitude = ""
        self.jobstatus = ""
        self.jobstatusid = 0
    }
    func mapping(map: Map) {
        self.mobile <- map["mobile"]
        self.clientname <- map["clientname"]
        self.address <- map["address"]
        self.scheduledate <- map["scheduledate"]
        self.jobid <- map["jobid"]
        self.description <- map["description"]
        self.id <- map["id"]
        self.scheduleday <- map["scheduleday"]
        self.scheduletime <- map["scheduletime"]
        self.latitude <- map["latitude"]
        self.longitude <- map["longitude"]
        self.jobstatus <- map["jobstatus"]
        self.jobstatusid <- map["jobstatusid"]
        
    }

}
