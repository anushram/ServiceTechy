//
//  MenuVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 14/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import SDWebImage

@available(iOS 13.0, *)
class MenuVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var techName: UILabel!
    @IBOutlet weak var techSpecialist: UILabel!
    @IBOutlet weak var techImage: UIImageView!
    
    var openJobTicketViewController = UIViewController()
    var myScheduleViewController = UIViewController()
    var jobMapViewController = UIViewController()
    var quotationViewController = UIViewController()
    
    var notificationListViewController = UIViewController()
    
    var menuImages = ["myschedule","openjob","closejob","quotation","invoice","myschedule","invoice","logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.customizeNavigationBar()
        // Do any additional setup after loading the view.
        self.techName.text = Singleton.sharedInstance.getTechInfo().techinfo.name
        self.techSpecialist.text = Singleton.sharedInstance.getTechInfo().techinfo.province
        let url = URL(string: Singleton.sharedInstance.getTechInfo().techinfo.photo)
        self.techImage.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultProduct"))
        self.instantiateViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func instantiateViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let openTicket = storyboard.instantiateViewController(withIdentifier: SegueConstants.kMainVC)
        self.openJobTicketViewController = UINavigationController(rootViewController: openTicket)
      
        let mySchedule = storyboard.instantiateViewController(withIdentifier: SegueConstants.kMyShedule)
        self.myScheduleViewController = UINavigationController(rootViewController: mySchedule)
      
        let jobMap = storyboard.instantiateViewController(withIdentifier: SegueConstants.kJobMap)
        self.jobMapViewController = UINavigationController(rootViewController: jobMap)
        
        let quotation = storyboard.instantiateViewController(withIdentifier: SegueConstants.kQuotationlist)
        self.quotationViewController = UINavigationController(rootViewController: quotation)
        //QuotationVC
        
        
        
        //notificationListViewcontroller
        let notificationList = storyboard.instantiateViewController(withIdentifier: SegueConstants.kNotificationList)
        self.notificationListViewController = UINavigationController(rootViewController: notificationList)
        
        //QuotationsListVC
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return global.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "menuitems"
        let cell = menuTable.dequeueReusableCell(withIdentifier: cellIdentifier) as! MenuTC
        cell.menuText.text = global.menuItems[indexPath.row]
        cell.imageView?.image = UIImage(named: menuImages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 0 {
            self.slideMenuController()?.changeMainViewController(self.myScheduleViewController, close: true)
        
        }else if indexPath.row == 1 {
            self.slideMenuController()?.changeMainViewController(self.openJobTicketViewController, close: true)
        }else if indexPath.row == 2 {
                self.slideMenuController()?.changeMainViewController(self.jobMapViewController, close: true)
        }else if indexPath.row == 3 {
            Singleton.sharedInstance.identifyQuotation = "yes"
             self.slideMenuController()?.changeMainViewController(self.quotationViewController, close: true)
            
        }else if indexPath.row == 4 {
            Singleton.sharedInstance.identifyQuotation = "no"
             self.slideMenuController()?.changeMainViewController(self.quotationViewController, close: true)
            
        }
        else if indexPath.row == global.menuItems.count - 1 {
            
            DispatchQueue.main.async(execute: {
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)

                let redViewController = self.mainStoryBoard.instantiateViewController(withIdentifier: "loginvc") as! LoginVC
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
                let menuNavigationController =
                    self.mainStoryBoard.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
                //menuNavigationController.setToolbarHidden(true, animated: true)
                menuNavigationController.setViewControllers([redViewController], animated: false)
                appDelegate.window?.rootViewController = menuNavigationController
                
            })
            
        }else if indexPath.row == 6 {
            
             self.slideMenuController()?.changeMainViewController(self.notificationListViewController, close: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @IBAction func closeAction(sender: UIButton){
        self.slideMenuController()?.closeLeft()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
