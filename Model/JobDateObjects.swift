//
//  JobDateObjects.swift
//  Technician
//
//  Created by K Saravana Kumar on 13/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class JobDateObjects: Mappable {
    
    var mobile: String
    var clientname: String
    var address: String
    var agreeddate: String
    var jobid: String
    var description: String
    var id: Int
    var agreedday: String
    var agreedtime: String
    var latitude: String
    var longitude: String
    
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
        self.id = 0
        self.agreedday = ""
        self.agreedtime = ""
        self.latitude = ""
        self.longitude = ""
    }
    func mapping(map: Map) {
        self.mobile <- map["mobile"]
        self.clientname <- map["clientname"]
        self.address <- map["address"]
        self.agreeddate <- map["agreeddate"]
        self.jobid <- map["jobid"]
        self.description <- map["description"]
        self.id <- map["id"]
        self.agreedday <- map["agreedday"]
        self.agreedtime <- map["agreedtime"]
        self.latitude <- map["latitude"]
        self.longitude <- map["longitude"]
        
    }


}
