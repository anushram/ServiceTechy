//
//  MainVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 14/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

@available(iOS 13.0, *)
class MainVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var jobTicketTV: UITableView!
    @IBOutlet weak var jobAvailableText: UILabel!
    
    var openJobListArray = [OpenTicketsList]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.addRightButtonText(text: "Menu")
        jobTicketTV.estimatedRowHeight = 120.0
        jobTicketTV.rowHeight = UITableView.automaticDimension
        setNavigationBarItem()
        self.addNavigationBarTitleView(title: "Job Tickets", image: UIImage()
        )

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.jobAvailableText.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadOffer(notification:)), name: Notification.Name.init(rawValue: "loadtickets"), object: nil)
        self.getOpenTickets()
    }
    
    @objc func reloadOffer(notification: Notification) {
        
        getOpenTickets()
        
        
    }
    
    func getOpenTickets() {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.179:3030/api/getTechassignedjobs
        
        NetworkManager.sharedInstance.getOpenTicket(url: "/getTechassignedjobs", parameter: [:], header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                    
                                    if let responseResult = responseData["result"] as? NSArray {
                                        
                                        let ticketList = Mapper<OpenTicketsList>().mapArray(JSONArray: responseResult as! [[String : Any]])
                                        print("vvv=",ticketList.count)
                                        self.openJobListArray.removeAll()
                                        self.openJobListArray.append(contentsOf: ticketList)
                                        DispatchQueue.main.async(execute: {
                                            if self.openJobListArray.count == 0 {
                                                self.jobAvailableText.isHidden = false
                                            }else{
                                                self.jobAvailableText.isHidden = true
                                            }
                                            self.jobTicketTV.reloadData()
                                            
                                        })
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                                        
                }else {
                    self.showAlertMessage(title: "Alert", message: "Please enter the correct Username and Password") {
                        
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
        let cellIdentifier = "jobtickets"
        var cell = self.jobTicketTV.dequeueReusableCell(withIdentifier: cellIdentifier) as? JobticketsTC
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("JobticketsTC", owner: self, options: nil)
            cell = nib![0] as? JobticketsTC
        }
        let obj = self.openJobListArray[indexPath.row]
        cell?.jobIDText.text = obj.jobid
        cell?.nameText.text = obj.clientname
        cell?.mobileNOText.text = obj.mobile
        
        cell?.dateText.text = obj.scheduledate
        cell?.timeText.text = obj.scheduletime
        cell?.descriptionText.text = obj.description
        
        if obj.jobstatusid == 4 {
        cell?.statusBtn.setTitle(obj.jobstatus, for: .normal)
        cell?.statusBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 143.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        }else if obj.jobstatusid == 5 {
        cell?.statusBtn.setTitle(obj.jobstatus, for: .normal)
        cell?.statusBtn.backgroundColor = UIColor(red: 52.0/255.0, green: 143.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        }else if obj.jobstatusid == 6 {
            cell?.statusBtn.setTitle(obj.jobstatus, for: .normal)
            cell?.statusBtn.backgroundColor = UIColor(red: 185.0/255.0, green: 201.0/255.0, blue: 61.0/255.0, alpha: 1.0)
            
        }else if obj.jobstatusid == 7 {
            cell?.statusBtn.setTitle(obj.jobstatus, for: .normal)
            cell?.statusBtn.backgroundColor = UIColor(red: 185.0/255.0, green: 201.0/255.0, blue: 61.0/255.0, alpha: 1.0)
        }else if obj.jobstatusid == 8 {
            cell?.statusBtn.setTitle(obj.jobstatus, for: .normal)
            cell?.statusBtn.backgroundColor = UIColor(red: 232.0/255.0, green: 174.0/255.0, blue: 63.0/255.0, alpha: 1.0)
        }else{
            cell?.statusBtn.setTitle(obj.jobstatus, for: .normal)
            cell?.statusBtn.backgroundColor = UIColor(red: 95.0/255.0, green: 202.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        
        //if indexPath.row == 0 {
        let obj = self.openJobListArray[indexPath.row]
        if obj.jobstatusid == 8 {
            
            DispatchQueue.main.async(execute: {
                //self.performSegue(withIdentifier: SegueConstants.kToTicketDetail, sender: self)
                self.performSegue(withIdentifier: SegueConstants.kFromMCtoSO, sender: obj)
                //kToTicketDetailsView
            })
            
        }else if obj.jobstatusid == 10 {
            
            DispatchQueue.main.async(execute: {
                //self.performSegue(withIdentifier: SegueConstants.kToTicketDetail, sender: self)
                self.performSegue(withIdentifier: SegueConstants.kFromMaintoQuotation, sender: obj)
                //kToTicketDetailsView
            })
            
        }
        else if obj.jobstatusid == 7 {

            DispatchQueue.main.async(execute: {
                //self.performSegue(withIdentifier: SegueConstants.kToTicketDetail, sender: self)
                self.performSegue(withIdentifier: SegueConstants.kFromTLtoCT, sender: obj)
                //kToTicketDetailsView
            })

        }
        else{
            
            DispatchQueue.main.async(execute: {
                //self.performSegue(withIdentifier: SegueConstants.kToTicketDetail, sender: self)
                self.performSegue(withIdentifier: SegueConstants.kToTicketDetailsView, sender: obj)
                //kToTicketDetailsView
            })
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueConstants.kToTicketDetailsView {
            
            let view = segue.destination as! TicketDetailsView
            
            view.jobDetailObjects = sender as? OpenTicketsList
            
        }else if segue.identifier == SegueConstants.kFromMaintoQuotation {
            
            let view = segue.destination as! QuotationVC
            
            view.jobDetailObjects = sender as? OpenTicketsList
            
        }else if segue.identifier == SegueConstants.kFromTLtoCT {
            
            let view = segue.destination as! TicketDetailsVC
            view.jobDetailObjects = sender as? OpenTicketsList
            
        }else if segue.identifier == SegueConstants.kFromMCtoSO {
            let view = segue.destination as! SelectCheckOutVC
            view.jobDetailObjects = sender as? OpenTicketsList
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
extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "menublack")!.withRenderingMode(.alwaysOriginal))
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
}
