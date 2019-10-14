//
//  NotificationViewController.swift
//  TicketContent
//
//  Created by K Saravana Kumar on 10/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI


class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    @IBOutlet var acceptButton: UIButton!
    @IBOutlet var declineButton: UIButton!
    
    var jobID = ""
    var techid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        self.jobID = notification.request.content.userInfo["jobid"] as! String
        self.techid = notification.request.content.userInfo["techid"] as! String
    }
    
    @IBAction func acceptAction(sender: UIButton){
        
        //let jobid = userInfo["jobid"]! as! String
        //let techid = userInfo["techid"]! as! String
        let param = ["request":["accepted":"1","jobid":jobID,"techid":techid]]
        
        let token = UserDefaults.standard.object(forKey: "apptoken") as! String
        
        //let header = ["Content-Type":"application/json","token": token]
        
        let urlString = "" + "/updateTechInvitation"
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "Post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        //NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request) {
            (
            data, response, error) in
            if (error != nil && data != nil) {
                
                
            }
            else if (error != nil || data == nil){
            }
            else{
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString)
            }
            
        }
        
        task.resume()
        
        
        
        
    }
    
    @IBAction func declineAction(sender: UIButton){
        
        let param = ["request":["accepted":"1","jobid":jobID,"techid":techid]]
        
        let token = UserDefaults.standard.object(forKey: "apptoken") as! String
        
        //let header = ["Content-Type":"application/json","token": token]
        
        let urlString = "http://18.219.84.173:3000/api" + "/updateTechInvitation"
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        var request = URLRequest(url: url!)
        request.httpMethod = "Post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        //NSURLRequest.CachePolicy.reloadIgnoringCacheData
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = session.dataTask(with: request) {
            (
            data, response, error) in
            if (error != nil && data != nil) {
                
                
            }
            else if (error != nil || data == nil){
            }
            else{
                let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(dataString)
            }
            
        }
        
        task.resume()
        
    }

}
