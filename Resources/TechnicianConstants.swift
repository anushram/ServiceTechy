//
//  TechnicianConstants.swift
//  Technician
//
//  Created by K Saravana Kumar on 26/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import Foundation
import UIKit

class Singleton {
    static let sharedInstance = Singleton()
    
    var isRemember: Bool
    var token: String
    var deviceToken: String
    var techInfo: TechDetails
    var partsCostObjects: [PartsCostItem]
    var serviceTypeObjects: [ServiceCostItem]
    var identifyQuotation: String
    
    
    init() {
        self.isRemember = false
        self.token = ""
        self.deviceToken = ""
        self.techInfo = TechDetails()
        self.partsCostObjects = [PartsCostItem]()
        self.serviceTypeObjects = [ServiceCostItem]()
        self.identifyQuotation = ""
    }
    
    func getRememberMeStatus() -> Bool? {
        
        if let tag = UserDefaults.standard.value(forKey: "rememberme") as? Bool {
            
            return tag
            
        }else{
            return false
        }
    }
    
    func setRememberMeStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: "rememberme")
    }
    
    func getUserNamePassword() -> [String: String] {
        
        let credentials = ["email" : UserDefaults.standard.value(forKey: "username")!,"password": UserDefaults.standard.value(forKey: "password")!]
        
        return credentials as! [String : String]
        
    }
    
    func setUserNamePassword(username: String, password: String) {
        
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        
    }
    
    func setTechToken(token: String) {
        UserDefaults.standard.set(token, forKey: "apptoken")
    }
    
    func getTechToken() -> String {
        let tokenValue = UserDefaults.standard.value(forKey: "apptoken") as! String
        return tokenValue
    }
    
    func setFirebaseToken(token: String) {
        self.token = token
    }
    
    func getFirebaseToken() -> String {
        return self.token
    }
    
    func setDeviceToken(token: String) {
        self.deviceToken = token
    }
    
    func getDeviceToken() -> String {
        return self.deviceToken
    }
    func setTechInfo(object: TechDetails) {
        self.techInfo = object
    }
    
    func getTechInfo() -> TechDetails {
        return self.techInfo
    }
    
    
    
}

struct SegueConstants {
    static let kMainVC = "mainVC"
    static let kMyShedule = "mySchedule"
    static let kJobMap = "jobmapviewvc"
    static let kToTicketDetail = "toTicketDetail"
    static let kToTicketDetailsView = "toTicketDetailsView"
    static let kQuotation = "quotation"
    static let kLoginvc = "loginvc"
    static let kFromMaintoQuotation = "fromMaintoQuotation"
    static let kFromTLtoCT = "fromTLtoCT"
    static let kNotificationList = "notificationList"
    static let kFromMCtoSO = "fromMCtoSO"
    static let kQuotationlist = "quotationlist"
    //static let kFromMCtoSO = "fromMCtoSO"
}

class ConstantInstances {
    var menuItems = ["My Schedule","Open Job Tickets","Closed Job Tickets","Quotations","Invoices","My Profile","Notifications","Log Out"]
    
}

enum JobStatus: String {
    case assainged, scheduled, Started
}

let global = ConstantInstances()


struct TechnicianConstants {
    
    static let IS_IPAD = (UIDevice.init().userInterfaceIdiom == .pad)
    static let IS_IPHONE = (UIDevice.init().userInterfaceIdiom == .phone)
    static let IS_RETINA = (UIScreen.main.scale >= 2.0)
    static let SCREEN_WIDTH = (UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT = (UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH = (max(SCREEN_WIDTH, SCREEN_HEIGHT))
    static let SCREEN_MIN_LENGTH = (min(SCREEN_WIDTH, SCREEN_HEIGHT))
    static let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
    static let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
    static let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
    static let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
    static let IS_IPHONE_X = (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
    static let IS_IPHONE_Xs = (IS_IPHONE && SCREEN_MAX_LENGTH == 896.0)
}

let kBaseUrl: String = "http://18.219.84.173:3000/api"
//let kBaseUrl: String = "http://192.168.1.229:3030/api"
