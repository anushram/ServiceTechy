//
//  QuotationsListVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 04/10/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper

class QuotationsListVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var quotationListTable: UITableView!
    
    var quotationsListArray = [QuotationsListObject]()
    
    var invoiceListArray = [InvoiceListObject]()
    
    var identifyList = ""
    
    @IBOutlet weak var titleText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        quotationListTable.estimatedRowHeight = 112.0
        quotationListTable.rowHeight = UITableView.automaticDimension
        setNavigationBarItem()
        self.addNavigationBarTitleView(title: "Notification List", image: UIImage())
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Singleton.sharedInstance.identifyQuotation == "yes"{
            self.identifyList = "/getTechquotationslist"
            self.titleText.text = "QUOTATIONS"
            self.quotationsListArray.removeAll()
            self.quotationListTable.reloadData()
            
        }else{
            self.identifyList = "/getTechinvoiceslist"
            self.titleText.text = "INVOICES"
            self.invoiceListArray.removeAll()
            self.quotationListTable.reloadData()
        }
        self.getQuotationsList()
    }
    
    func getQuotationsList() {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        NetworkManager.sharedInstance.getQuotationsList(url: self.identifyList, parameter: [:], header: header) { (response) in
            
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                   
                                    if let quotationsList = responseData["result"] as? NSArray {
                                        
                                        if Singleton.sharedInstance.identifyQuotation == "yes"{
                                        
                                        let ticketList = Mapper<QuotationsListObject>().mapArray(JSONArray: quotationsList as! [[String : Any]])
                                        self.quotationsListArray.removeAll()
                                        self.quotationsListArray.append(contentsOf: ticketList)
                                        DispatchQueue.main.async {
                                            self.quotationListTable.reloadData()
                                        }
                                            
                                        }else{
                                            
                                            let ticketList = Mapper<InvoiceListObject>().mapArray(JSONArray: quotationsList as! [[String : Any]])
                                            self.invoiceListArray.removeAll()
                                            self.invoiceListArray.append(contentsOf: ticketList)
                                            DispatchQueue.main.async {
                                                self.quotationListTable.reloadData()
                                            }
                                            
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
        if Singleton.sharedInstance.identifyQuotation == "yes"{
        return self.quotationsListArray.count
        }else{
        return self.invoiceListArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Singleton.sharedInstance.identifyQuotation == "yes"{
        let cellIdentifier = "quotationslist"
        var cell = self.quotationListTable.dequeueReusableCell(withIdentifier: cellIdentifier) as? QuotationsListTC
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("QuotationsListTC", owner: self, options: nil)
            cell = nib![0] as? QuotationsListTC
        }
        let obj = self.quotationsListArray[indexPath.row]
        cell?.jobID.text = obj.jobid
        cell?.clientName.text = obj.clientname
        cell?.quotationAmt.text = String(obj.quotationamount)
        cell?.quotationDate.text = obj.quotedate
        cell?.qteDescription.text = obj.description
        cell?.quotationNumber.text = obj.jobquotationid
        return cell!
        }else{
            
            let cellIdentifier = "quotationslist"
            var cell = self.quotationListTable.dequeueReusableCell(withIdentifier: cellIdentifier) as? QuotationsListTC
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("QuotationsListTC", owner: self, options: nil)
                cell = nib![0] as? QuotationsListTC
            }
            let obj = self.invoiceListArray[indexPath.row]
            cell?.jobID.text = obj.jobid
            cell?.clientName.text = obj.clientname
            cell?.quotationAmt.text = "10"
            cell?.quotationDate.text = ""
            cell?.qteDescription.text = obj.description
            cell?.quotationNumber.text = ""
            return cell!
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
