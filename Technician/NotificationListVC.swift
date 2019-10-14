//
//  NotificationListVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 23/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper


class NotificationListVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var notificationListTV: UITableView!
    
    var openJobListArray = [OpenTicketsList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.addRightButtonText(text: "Menu")
        notificationListTV.estimatedRowHeight = 148.0
        notificationListTV.rowHeight = UITableView.automaticDimension
        setNavigationBarItem()
        self.addNavigationBarTitleView(title: "Notification List", image: UIImage())
      
        
       // self.getNotificationList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
     
        self.getNotificationList()
    }
    
   
    //MARK:- getNotification Method
    
    func getNotificationList() {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.179:3030/api/getTechassignedjobs
        
        NetworkManager.sharedInstance.getNotificationList(url: "/getTechjobnotifications", parameter: [:], header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                   
                                    if let responseData1 = responseData["result"] as? NSDictionary {
                                        
                                    if let responseResult = responseData1["jobresult"] as? NSArray {
                                        
                                        let ticketList = Mapper<OpenTicketsList>().mapArray(JSONArray: responseResult as! [[String : Any]])
                                        print("vvv=",ticketList.count)
                                        self.openJobListArray.removeAll()
                                        self.openJobListArray.append(contentsOf: ticketList)
                                        DispatchQueue.main.async(execute: {
                                            
                                            self.notificationListTV.reloadData()
                                            
                                        })
                                        
                                    }
                                }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }else {
                    self.showAlertMessage(title: "Alert", message: "Something wrong") {
                        
                    }
                }
                
            case .failure(_): break
                
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.openJobListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "notificationList"
        var cell = self.notificationListTV.dequeueReusableCell(withIdentifier: cellIdentifier) as? NotificationListTC
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("NotificationListTC", owner: self, options: nil)
            cell = nib![0] as? NotificationListTC
        }
        let obj = self.openJobListArray[indexPath.row]
        cell?.jobIDText.text = obj.jobid
        cell?.nameText.text = obj.clientname
        cell?.mobileNOText.text = obj.mobile
        
        cell?.dateText.text = obj.scheduledate
        cell?.timeText.text = obj.scheduletime
        cell?.descriptionText.text = obj.address
        
        cell?.statusBtn.setTitle(obj.jobstatus, for: .normal)
        cell?.statusBtn.backgroundColor = UIColor(red: 95.0/255.0, green: 202.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        
        cell?.acceptBtn.tag = indexPath.row
        cell?.acceptBtn.addTarget(self, action: #selector(NotificationListVC.acceptBtnClicked(_:)), for: .touchUpInside)
        
        cell?.rejectBtn.tag = indexPath.row
        cell?.rejectBtn.addTarget(self, action: #selector(NotificationListVC.rejectBtnClicked(_:)), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @IBAction func acceptBtnClicked(_ sender: UIButton) {
    
        let value = openJobListArray[sender.tag]
        
        let tech = Singleton.sharedInstance.getTechInfo().techinfo.id
        
       self.acceptNotificationList(accepted: "1", jobID: value.id, techid: String(tech))
        
    }
    
    @IBAction func rejectBtnClicked(_ sender: UIButton) {
        
        let value = openJobListArray[sender.tag]
        
        let tech = Singleton.sharedInstance.getTechInfo().techinfo.id
        
        self.acceptNotificationList(accepted: "0", jobID: value.id, techid: String(tech))
        
    }
    
   // MARK:- AcceptNotificationList
    
    func acceptNotificationList(accepted:String, jobID:Int, techid:String ) {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
       
        
        let param = ["request":["accepted":accepted,"jobid":jobID,"techid":techid]]
      
        
        NetworkManager.sharedInstance.getAcceptNotificationList(url: "/updateTechInvitation", parameter: param, header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {

                    if let responseCode = responseValue["response"] as? NSDictionary {

                        if let code = responseCode["code"] as? String {

                            if code == "OK" {
                                
                                self.getNotificationList()

//                                if let responseData = responseCode["data"] as? NSDictionary {
//
//                                    if let responseData1 = responseData["result"] as? NSDictionary {
//
//                                        if let responseResult = responseData1["jobresult"] as? NSArray {
//
//                                            let ticketList = Mapper<OpenTicketsList>().mapArray(JSONArray: responseResult as! [[String : Any]])
//                                            print("vvv=",ticketList.count)
//                                            self.openJobListArray.removeAll()
//                                            self.openJobListArray.append(contentsOf: ticketList)
//                                            DispatchQueue.main.async(execute: {
//
//                                                self.notificationListTV.reloadData()
//
//                                            })
//
//                                        }
//                                    }
//
//                                }

                            }

                        }

                    }

                }else {
                    self.showAlertMessage(title: "Alert", message: "Something wrong") {

                    }
                }
                
            case .failure(_): break
                
            }
            
        }
        
        
    }
    
    //kToTicketDetail
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
