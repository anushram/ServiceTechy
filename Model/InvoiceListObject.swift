//
//  InvoiceListObject.swift
//  Technician
//
//  Created by K Saravana Kumar on 04/10/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class InvoiceListObject: Mappable {
    
    var address: String
    var clientname: String
    var description: String
    var id: Int
    var jobid: String
    var jobinvoiceid: String
    var jobquotationid: String
    var jobstatus: String
    var jobstatusid: Int
    var mobile: String
    var invoiceamount: Double
    var invoicecreationdate: String
    var quotedate: String
    var quoteday: String
    var quotetime: String
    
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    init() {
        self.address = ""
        self.clientname = ""
        self.description = ""
        self.id = 0
        self.jobid = ""
        self.jobinvoiceid = ""
        self.jobquotationid = ""
        self.jobstatus = ""
        self.jobstatusid = 0
        self.mobile = ""
        self.invoiceamount = 0.0
        self.invoicecreationdate = ""
        self.quotedate = ""
        self.quoteday = ""
        self.quotetime = ""
    }
    
    func mapping(map: Map) {
    //self.mobile <- map["mobile"]
        
        self.address <- map["address"]
        self.clientname <- map["clientname"]
        self.description <- map["description"]
        self.id <- map["id"]
        self.jobid <- map["jobid"]
        self.jobinvoiceid <- map["jobinvoiceid"]
        self.jobquotationid <- map["jobquotationid"]
        self.jobstatus <- map["jobstatus"]
        self.jobstatusid <- map["jobstatusid"]
        self.mobile <- map["mobile"]
        self.invoiceamount <- map["invoiceamount"]
        self.invoicecreationdate <- map["quotationcreationdate"]
        self.quotedate <- map["quotedate"]
        self.quoteday <- map["quoteday"]
        self.quotetime <- map["quotetime"]
    }

}
