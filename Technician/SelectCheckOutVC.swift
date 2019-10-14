//
//  SelectCheckOutVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 24/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class SelectCheckOutVC: BaseVC,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var statusListTable: UITableView!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var scroll: UIScrollView!
    
    var jobDetailObjects: OpenTicketsList!
    
    var statusListArray = [SelectOptionsObject]()
    var selectedArray = [Int]()

    var selectedObject: SelectOptionsObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.text = "Give Completion Notes"
        notesTextView.textColor = UIColor.lightGray
        notesTextView.font = UIFont(name: "NotoSans", size: 13.0)
        self.addDoneButtonOnKeyboard(textView: notesTextView)
        self.addNavigationBarTitleView(title: "", image: UIImage())
        // Do any additional setup after loading the view.
        self.getSelectOptionStatus()
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "statusoptions"
        let cell = statusListTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StatusOptionsTVC
        let obj = statusListArray[indexPath.row]
        cell.optionsText.text = obj.role
        if selectedArray.contains(indexPath.row){
            cell.radioImage.image = UIImage(named: "radiocircle")
        }else{
            cell.radioImage.image = UIImage(named: "radio")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.selectedArray.removeAll()
        let obj = statusListArray[indexPath.row]
        selectedArray.append(indexPath.row)
        self.statusListTable.reloadData()
        self.selectedObject = obj
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    @IBAction func sendJobCheckOutStatus(status: UIButton) {
        
        if notesTextView.text != "Give Completion Notes" && notesTextView.text != nil {
        
        if self.selectedArray.last != nil {
                let obj = statusListArray[self.selectedArray.last!]
                
                if Int(obj.statusid) == 14{
                self.updateStatus(jobstatusID: "14")
                    
                }else{
                    self.updateStatus(jobstatusID: "8")
                }
            
        }else{
            
            self.showAlertMessage(title: "Alert", message: "Please Pick any of the options") {
                
            }
            
        }
            
        }else{
            self.showAlertMessage(title: "Alert", message: "Please give completion Notes") {
                
            }
        }
        
        }
    
    func updateStatus(jobstatusID: String) {
        
        let obj = statusListArray[self.selectedArray.last!]
        
        self.showActivityIndicator()
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        var param = [String: [String: Any]]()
        param = ["request": ["jobstatusid": jobstatusID,"jobid": jobDetailObjects.id,"notes": self.notesTextView.text!]]
        //let param = ["request":["jobid":jobDetailObjects.id]]
        NetworkManager.sharedInstance.postJobEditDetails(url: "/updatetechJobstatus", parameter: param, header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                DispatchQueue.main.async {

                                    if Int(obj.statusid) == 9 || Int(obj.statusid) == 10 {
                                        
                                        self.performSegue(withIdentifier: "fromSOtoQuote", sender: Int(obj.statusid))
                                        
                                    }else if Int(obj.statusid) == 13 || Int(obj.statusid) == 12 {
                                        
                                        self.performSegue(withIdentifier: "fromSOtoQuote", sender: Int(obj.statusid))
                                        
                                    }else if Int(obj.statusid) == 14 {
                                        
                                        self.showAlertMessage(title: "Alert", message: "This job is moved to Job Pending") {
                                            
                                            self.navigationController?.popToRootViewController(animated: true)
                                            
                                        }
                                        
                                    }

                                }
                                
                            }
                        }
                    }
                }
                
            case .failure(_):
                
                print("error")
                
            }
            
        }

        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    
        if textView.text == "Give Completion Notes" {
            
            notesTextView.text = ""
            notesTextView.textColor = UIColor.black
            notesTextView.font = UIFont(name: "NotoSans", size: 13.0)
            
            UIView.animate(withDuration: 0.1) {
                let scrollPoint = CGPoint(x: 0, y: textView.superview!.frame.origin.y)
                self.scroll .setContentOffset(scrollPoint, animated: true)
            }
            
        }else{
            
            UIView.animate(withDuration: 0.1) {
                let scrollPoint = CGPoint(x: 0, y: textView.superview!.frame.origin.y)
                self.scroll .setContentOffset(scrollPoint, animated: true)
            }
            
        }
        
        
        
    }
    
        override func doneButtonAction() {
        if notesTextView.text == "" {
            
            notesTextView.text = "Give Completion Notes"
            notesTextView.textColor = UIColor.lightGray
            notesTextView.font = UIFont(name: "NotoSans", size: 13.0)
        }
        notesTextView.resignFirstResponder()
        UIView.animate(withDuration: 0.1) {
            let scrollPoint = CGPoint(x: 0, y: 0)
            self.scroll .setContentOffset(scrollPoint, animated: true)
        }
        
    }
    
    func getSelectOptionStatus() {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.229:3030/api/getTechnicanroles
        
        NetworkManager.sharedInstance.getSelectOptions(url: "/getTechnicanroles", parameter: [:], header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                   
                                    if let responseData1 = responseData["result"] as? NSArray {
                                        
                                         let selectOptions = Mapper<SelectOptionsObject>().mapArray(JSONArray: responseData1 as! [[String : Any]])
                                        self.statusListArray.removeAll()
                                        self.statusListArray = selectOptions
                                        DispatchQueue.main.async {
                                            self.statusListTable.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromSOtoQuote" {
            let view = segue.destination as! QuotationVC
            view.jobDetailObjects = jobDetailObjects
            view.statusQuotation = sender as! Int
        }
        
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
