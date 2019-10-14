//
//  JobDetails.swift
//  Technician
//
//  Created by K Saravana Kumar on 16/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class JobDetails: Mappable {
    
    var mobile: String
    var clientname: String
    var address: String
    var agreeddate: String
    var jobid: String
    var description: String
    var jobstatus: String
    var jobstatusid: Int
    
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    init() {
        
        self.mobile = ""
        self.clientname = ""
        self.address = ""
        self.agreeddate = ""
        self.jobid = ""
        self.description = ""
        self.jobstatus = ""
        self.jobstatusid = 0
    }
    func mapping(map: Map) {
        self.mobile <- map["mobile"]
        self.clientname <- map["clientname"]
        self.address <- map["address"]
        self.agreeddate <- map["agreeddate"]
        self.jobid <- map["jobid"]
        self.description <- map["description"]
        self.jobstatus <- map["jobstatus"]
        self.jobstatusid <- map["jobstatusid"]
    }
    
    
}
