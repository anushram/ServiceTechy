//
//  QuotationVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 09/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper


class QuotationVC: BaseVC,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PartsNumberDidSelectDelegate,ServiceTypeDidSelectDelegate {
    
    
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var mobileText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var problemText: UILabel!
    @IBOutlet weak var quotationTitle: UILabel!
    @IBOutlet weak var quoteActionTitle: UIButton!
    
    @IBOutlet weak var scroll: UIScrollView!
    
    @IBOutlet weak var quotationTable: UITableView!
    
    @IBOutlet weak var serviceCostTable: UITableView!
    
    @IBOutlet weak var partsCostHeight: NSLayoutConstraint!
    @IBOutlet weak var serviceCostHeight: NSLayoutConstraint!
    @IBOutlet weak var totalTaxes: UILabel!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    var partsView: PartsNumberView!
    var serviceTypeView: ServiceTypeSearchView!
    var jobDetailObjects: OpenTicketsList!
    
    var statusQuotation = 0
    
    var clientDetailsObject: ClientDetails!
    var quoteURLString = ""
    
    //var partsView: PartsNumberView!
    
    var partsCostTotalArray = [PartsCostObject]()
    var serviceTypeTotalArray = [ServiceTypeObject]()
    
    
    var partsCostArray = [PartsCostItem]()
    
    var identifier = ""
    
    var subTotalValue = 0.0
    var totalTaxesValue = 0.0
    var totalAmountValue = 0.0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBarItem()
        self.addNavigationBarTitleView(title: "Quotation", image: UIImage())
        let objPart = PartsCostObject()
        partsCostTotalArray.append(objPart)
        let objService = ServiceTypeObject()
        serviceTypeTotalArray.append(objService)
        let headerNib = UINib.init(nibName: "QuotationHeader", bundle: Bundle.main)
        quotationTable.register(headerNib, forHeaderFooterViewReuseIdentifier: "quoteheader")
        
        let headerServiceNib = UINib.init(nibName: "ServiceCostHeader", bundle: Bundle.main)
        serviceCostTable.register(headerServiceNib, forHeaderFooterViewReuseIdentifier: "servicecosttype")
        
        let footerNib = UINib.init(nibName: "QuotationFooter", bundle: Bundle.main)
        quotationTable.register(footerNib, forHeaderFooterViewReuseIdentifier: "quotefooter")
        
        partsCostHeight.constant = CGFloat((((Double(partsCostTotalArray.count) * 31.0) + 26.0) + 31.0))
        quotationTable.updateConstraints()
        quotationTable.layoutIfNeeded()
        
        serviceCostHeight.constant = CGFloat((((Double(serviceTypeTotalArray.count) * 31.0) + 26.0) + 31.0))
        serviceCostTable.updateConstraints()
        serviceCostTable.layoutIfNeeded()
        
        if statusQuotation == 10 || statusQuotation == 9 {
            
            self.quotationTitle.text = "QUOTATION"
            self.quoteActionTitle.setTitle("SEND QUOTATION", for: .normal)
            self.quoteURLString = "/generateQuotation"
            
        }else if statusQuotation == 12 || statusQuotation == 13 {
            
            self.quotationTitle.text = "INVOICE"
            self.quoteActionTitle.setTitle("SEND INVOICE", for: .normal)
            self.quoteURLString = "/generateInvoice"
            
        }else{
            
        }

        self.getClientDetails()
    }
    //MARK: Client Details
    func getClientDetails() {
            
            let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
            //http://192.168.1.229:3030/api/getClientByJob
            
            let param = ["request":["jobid":jobDetailObjects.id]]
            //http://192.168.1.179:3030/api/getTechassignedjobdetail
            NetworkManager.sharedInstance.getTicketDetails(url: "/getClientByJob", parameter: param, header: header) { (response) in
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
                                            
                                            let clientObject = Mapper<ClientDetails>().map(JSON: responseResult[0] as! [String : Any])
                                            
                                            self.clientDetailsObject = clientObject
                                            
                                            self.nameText.text = self.clientDetailsObject.clientname
                                            self.mobileText.text = self.clientDetailsObject.mobile
                                            self.addressText.text = self.clientDetailsObject.address
                                            self.problemText.text = self.clientDetailsObject.description
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

    //MARK: Tableview Delegates
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == quotationTable{
        return partsCostTotalArray.count + 1
        }else{
        return serviceTypeTotalArray.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == quotationTable {
        
        if indexPath.row == partsCostTotalArray.count {
            
            let cellIdentifier = "addrow"
            var cell = self.quotationTable.dequeueReusableCell(withIdentifier: cellIdentifier) as? AddRowTVC
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("AddRowTVC", owner: self, options: nil)
                cell = nib![0] as? AddRowTVC
            }
            cell!.addRowBtn.addTarget(self, action: #selector(self.addRowAction(sender:)), for: .touchUpInside)
            return cell!
        
        
        }else {
            
            let cellIdentifier = "partscost"
            var cell = self.quotationTable.dequeueReusableCell(withIdentifier: cellIdentifier) as? PartsCostTVC
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("PartsCostTVC", owner: self, options: nil)
                cell = nib![0] as? PartsCostTVC
                cell?.partsNo.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
                cell?.unitPrice.addTarget(self, action: #selector(self.textFieldUnitPriceDidChange(_:)), for: UIControl.Event.editingChanged)
                cell?.unitPrice.addDoneCancelToolbar()
                cell?.Qty.addTarget(self, action: #selector(self.textFieldQtyDidChange(_:)), for: UIControl.Event.editingChanged)
                cell?.Qty.addDoneCancelToolbar()
                cell?.partsNo.delegate = self
                cell?.partsNo.tag = indexPath.row + 1
                cell?.partsName.delegate = self
                cell?.partsName.tag = indexPath.row + 2
                cell?.Qty.delegate = self
                cell?.Qty.tag = indexPath.row + 3
                cell?.unitPrice.delegate = self
                cell?.unitPrice.tag = indexPath.row + 4
                cell?.cost.delegate = self
                cell?.cost.isUserInteractionEnabled = false
                cell?.cost.tag = indexPath.row + 5
                cell?.tag = indexPath.row
                cell?.closeBTN.addTarget(self, action: #selector(self.deleteRow(sender:)), for: .touchUpInside)
                //cell?.closeBTN.tag =
            }
            return cell!
            
        }
            
        }else{
            
            if indexPath.row == serviceTypeTotalArray.count {
                
                let cellIdentifier = "addrow"
                var cell = self.quotationTable.dequeueReusableCell(withIdentifier: cellIdentifier) as? AddRowTVC
                if cell == nil {
                    let nib = Bundle.main.loadNibNamed("AddRowTVC", owner: self, options: nil)
                    cell = nib![0] as? AddRowTVC
                }
                cell!.addRowBtn.addTarget(self, action: #selector(self.addServiceRowAction(sender:)), for: .touchUpInside)
                return cell!
            
            
            }else {
                
                let cellIdentifier = "servicecost"
                var cell = self.serviceCostTable.dequeueReusableCell(withIdentifier: cellIdentifier) as? ServiceCostTVC
                if cell == nil {
                    let nib = Bundle.main.loadNibNamed("ServiceCostTVC", owner: self, options: nil)
                    cell = nib![0] as? ServiceCostTVC
                    cell?.serviceType.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
                    cell?.totalHrs.addTarget(self, action: #selector(self.textFieldTotalhrsDidChange(_:)), for: UIControl.Event.editingChanged)
                    cell?.totalHrs.addDoneCancelToolbar()
                    cell?.costHrs.addTarget(self, action: #selector(self.textFieldCosthrsDidChange), for: UIControl.Event.editingChanged)
                    cell?.costHrs.addDoneCancelToolbar()
//                    cell?.unitPrice.addTarget(self, action: #selector(self.textFieldUnitPriceDidChange(_:)), for: UIControl.Event.editingChanged)
                    cell?.serviceType.delegate = self
                    cell?.serviceType.tag = indexPath.row + 1
                    cell?.costHrs.delegate = self
                    cell?.costHrs.tag = indexPath.row + 2
                    cell?.totalHrs.delegate = self
                    cell?.totalHrs.tag = indexPath.row + 3
                    cell?.costText.delegate = self
                    cell?.costText.isUserInteractionEnabled = false
                    cell?.costText.tag = indexPath.row + 4
                    cell?.closeBtn.addTarget(self, action: #selector(self.deleteServiceCostRow(sender:)), for: .touchUpInside)
//                    cell?.partsName.delegate = self
//                    cell?.partsName.tag = indexPath.row + 2
//                    cell?.Qty.delegate = self
//                    cell?.Qty.tag = indexPath.row + 3
//                    cell?.unitPrice.delegate = self
//                    cell?.unitPrice.tag = indexPath.row + 4
//                    cell?.cost.delegate = self
//                    cell?.cost.isUserInteractionEnabled = false
//                    cell?.cost.tag = indexPath.row + 5
                    cell?.tag = indexPath.row
                }
                return cell!
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == quotationTable{
            
            if indexPath.row == partsCostTotalArray.count {
                
                return 26
                
            }else{
                return 31.0
            }
        }else{
            
            if indexPath.row == serviceTypeTotalArray.count {
                
                return 26
                
            }else{
                return 31.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == quotationTable {
        
        let headerView = quotationTable.dequeueReusableHeaderFooterView(withIdentifier: "quoteheader") as! QuotationHeader
       // headerView.backgroundView?.backgroundColor = UIColor.blue
       // headerView.backgroundColor = UIColor.blue
        return headerView
        }else{
            let headerView = serviceCostTable.dequeueReusableHeaderFooterView(withIdentifier: "servicecosttype") as! ServiceCostHeader
            // headerView.backgroundView?.backgroundColor = UIColor.blue
            // headerView.backgroundColor = UIColor.blue
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 31.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = quotationTable.dequeueReusableHeaderFooterView(withIdentifier: "quotefooter") as! QuotationFooter
        // headerView.backgroundView?.backgroundColor = UIColor.blue
        // headerView.backgroundColor = UIColor.blue
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.0
    }
    
    //MARK: Add Row Actions
    
    
    @objc func deleteRow(sender: UIButton){
        
        let cell = sender.superview?.superview
        print("vvv=",cell!.tag)
        if (cell?.isKind(of: PartsCostTVC.self))!{
            if self.partsCostTotalArray.count > 1 {
                let partsCell = cell as! PartsCostTVC
                /*
                 @IBOutlet weak var partsNo: UITextField!
                 @IBOutlet weak var partsName: UITextField!
                 @IBOutlet weak var Qty: UITextField!
                 @IBOutlet weak var unitPrice: UITextField!
                 @IBOutlet weak var cost: UITextField!
                 @IBOutlet weak var closeBTN: UIButton!
                 */
                partsCell.partsNo.text = ""
                partsCell.partsName.text = ""
                partsCell.Qty.text = ""
                partsCell.unitPrice.text = ""
                partsCell.cost.text = ""
            self.partsCostTotalArray.remove(at: cell!.tag)
            quotationTable.reloadData()
            self.calculateTaxesAmount()
            }else{
                self.showAlertMessage(title: "Alert", message: "You cannot delete the entire list") {
            }
            }
            
        }
        //else if (cell?.isKind(of: ServiceCostTVC.self))!{
            
        //    self.serviceTypeTotalArray.remove(at: cell!.tag)
            
        //}
    }
    
    @objc func deleteServiceCostRow(sender: UIButton){
        
        let cell = sender.superview?.superview
        print("vvv=",cell!.tag)
        if (cell?.isKind(of: ServiceCostTVC.self))!{
            if self.serviceTypeTotalArray.count > 1 {
            let serviceCostCell = cell as! ServiceCostTVC
                /*
                 @IBOutlet weak var serviceType: UITextField!
                 @IBOutlet weak var costHrs: UITextField!
                 @IBOutlet weak var totalHrs: UITextField!
                 @IBOutlet weak var costText: UITextField!
                 @IBOutlet weak var closeBtn: UIButton!
                 */
                serviceCostCell.serviceType.text = ""
                serviceCostCell.costHrs.text = ""
                serviceCostCell.totalHrs.text = ""
                serviceCostCell.costText.text = ""
                
            self.serviceTypeTotalArray.remove(at: cell!.tag)
            serviceCostTable.reloadData()
            self.calculateTaxesAmount()
            }else{
                self.showAlertMessage(title: "Alert", message: "You cannot delete the entire list") {
                    
                }
            }
        }
        //else if (cell?.isKind(of: ServiceCostTVC.self))!{
            
        //    self.serviceTypeTotalArray.remove(at: cell!.tag)
            
        //}
    }
    
    @IBAction func addRowAction(sender: UIButton){
        
        
        let checkObject = partsCostTotalArray[partsCostTotalArray.count - 1]
        
        if checkObject.itemno.count != 0 && checkObject.itemname.count != 0 && checkObject.qty != 0 && checkObject.price != 0.0 && checkObject.cost != 0 {
            let obj = PartsCostObject()
            self.partsCostTotalArray.append(obj)
            quotationTable.reloadData()
            partsCostHeight.constant = CGFloat((((Double(partsCostTotalArray.count) * 31.0) + 26.0) + 31.0))
            quotationTable.updateConstraints()
            quotationTable.layoutIfNeeded()
        }else{
            self.showAlertMessage(title: "Alert", message: "Please complete the last Parts Cost") {
                
            }
        }
        
        
    }
    
    @IBAction func addServiceRowAction(sender: UIButton){
        
        let checkObject = serviceTypeTotalArray[serviceTypeTotalArray.count - 1]
        
        if checkObject.serviceType.count != 0 && checkObject.costHrs != 0 && checkObject.totalHrs != 0 && checkObject.cost != 0 {
            let obj = ServiceTypeObject()
            self.serviceTypeTotalArray.append(obj)
            serviceCostTable.reloadData()
            serviceCostHeight.constant = CGFloat((((Double(serviceTypeTotalArray.count) * 31.0) + 26.0) + 31.0))
            serviceCostTable.updateConstraints()
            serviceCostTable.layoutIfNeeded()
        }else{
            self.showAlertMessage(title: "Alert", message: "Please complete the last Service Cost") {
                
            }
        }
        
        
    }
    
    //MARK: TextField Delegates
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        
        
        let cell = textField.superview?.superview
        
        if (cell?.isKind(of: PartsCostTVC.self))!{
            
            self.getItemNoPartsCost(search: textField.text!, cell: cell! as! PartsCostTVC)
            
        }else if (cell?.isKind(of: ServiceCostTVC.self))!{
            
            self.getServiceCostType(search: textField.text!, cell: cell! as! ServiceCostTVC)
        }
        
    }
    
    @objc func textFieldTotalhrsDidChange(_ textField: UITextField) {
        
        let cell = textField.superview?.superview
        
        if (cell?.isKind(of: ServiceCostTVC.self))!{
            
            let cellClass = cell as! ServiceCostTVC
            
            if cellClass.serviceType.text?.count != 0 {
                
                if cellClass.costHrs.text?.count != 0 {
                    
                    if cellClass.totalHrs.text?.count != 0 {
                        
                        if ((Double(cellClass.costHrs.text!) != nil) && (Double(cellClass.totalHrs.text!) != nil)) {
                            
                            let costPerHour = Double(cellClass.costHrs.text!)
                            let totalHours = Double(cellClass.totalHrs.text!)
                            cellClass.costText.text = String(costPerHour! * totalHours!)
                            let obj = serviceTypeTotalArray[cellClass.tag]
                            //var serviceType = ""
                            //var costHrs = 0.0
                            //var totalHrs = 0.0
                            //var cost = 0.0
                            //var tax = 0.0
                            obj.serviceType = cellClass.serviceType.text!
                            obj.costHrs = costPerHour!
                            obj.totalHrs = totalHours!
                            obj.cost = (costPerHour! * totalHours!)
                            obj.tax = ((costPerHour! * totalHours!) * 5)/100
                            obj.qty = totalHours!
                            serviceTypeTotalArray[cellClass.tag] = obj
                            self.calculateTaxesAmount()
                        }
                        
                    }else{
                        cellClass.costText.text = ""
                        let obj = serviceTypeTotalArray[cellClass.tag]
                        obj.serviceType = ""
                        obj.costHrs = 0.0
                        obj.totalHrs = 0.0
                        obj.cost = 0.0
                        obj.tax = 0.0
                        obj.qty = 0.0
                        serviceTypeTotalArray[cellClass.tag] = obj
                        
                    }
                    
                }else{
                    cellClass.costText.text = ""
                    let obj = serviceTypeTotalArray[cellClass.tag]
                    obj.serviceType = ""
                    obj.costHrs = 0.0
                    obj.totalHrs = 0.0
                    obj.cost = 0.0
                    obj.tax = 0.0
                    obj.qty = 0.0
                    serviceTypeTotalArray[cellClass.tag] = obj
                }
                
            }else{
                let obj = serviceTypeTotalArray[cellClass.tag]
                obj.serviceType = ""
                obj.costHrs = 0.0
                obj.totalHrs = 0.0
                obj.cost = 0.0
                obj.tax = 0.0
                obj.qty = 0.0
                serviceTypeTotalArray[cellClass.tag] = obj
            }
            
        }
        
    }
    
    @objc func textFieldCosthrsDidChange(_ textField: UITextField) {
        
        let cell = textField.superview?.superview
        
        if (cell?.isKind(of: ServiceCostTVC.self))!{
            
            let cellClass = cell as! ServiceCostTVC
            
            if cellClass.serviceType.text?.count != 0 {
                
                if cellClass.costHrs.text?.count != 0 {
                    
                    if cellClass.totalHrs.text?.count != 0 {
                        
                        if ((Double(cellClass.costHrs.text!) != nil) && (Double(cellClass.totalHrs.text!) != nil)) {
                            
                            let costPerHour = Double(cellClass.costHrs.text!)
                            let totalHours = Double(cellClass.totalHrs.text!)
                            cellClass.costText.text = String(costPerHour! * totalHours!)
                            let obj = serviceTypeTotalArray[cellClass.tag]
                            //var serviceType = ""
                            //var costHrs = 0.0
                            //var totalHrs = 0.0
                            //var cost = 0.0
                            //var tax = 0.0
                            obj.serviceType = cellClass.serviceType.text!
                            obj.costHrs = costPerHour!
                            obj.totalHrs = totalHours!
                            obj.cost = (costPerHour! * totalHours!)
                            obj.tax = ((costPerHour! * totalHours!) * 5)/100
                            obj.qty = totalHours!
                            serviceTypeTotalArray[cellClass.tag] = obj
                            self.calculateTaxesAmount()
                        }
                        
                    }else{
                        cellClass.costText.text = ""
                        let obj = serviceTypeTotalArray[cellClass.tag]
                        obj.serviceType = ""
                        obj.costHrs = 0.0
                        obj.totalHrs = 0.0
                        obj.cost = 0.0
                        obj.tax = 0.0
                        obj.qty = 0.0
                        serviceTypeTotalArray[cellClass.tag] = obj
                        
                    }
                    
                }else{
                    cellClass.costText.text = ""
                    let obj = serviceTypeTotalArray[cellClass.tag]
                    obj.serviceType = ""
                    obj.costHrs = 0.0
                    obj.totalHrs = 0.0
                    obj.cost = 0.0
                    obj.tax = 0.0
                    obj.qty = 0.0
                    serviceTypeTotalArray[cellClass.tag] = obj
                }
                
            }else{
                let obj = serviceTypeTotalArray[cellClass.tag]
                obj.serviceType = ""
                obj.costHrs = 0.0
                obj.totalHrs = 0.0
                obj.cost = 0.0
                obj.tax = 0.0
                obj.qty = 0.0
                serviceTypeTotalArray[cellClass.tag] = obj
            }
            
        }

        
    }
    
    @objc func textFieldUnitPriceDidChange(_ textField: UITextField) {
        
        
        
        let cell = textField.superview?.superview
        
        if (cell?.isKind(of: PartsCostTVC.self))!{
            
            let cellClass = cell as! PartsCostTVC
                                       
                if cellClass.partsNo.text?.count != 0 {
                   
                    if cellClass.partsName.text?.count != 0 {
                       
                        if cellClass.Qty.text?.count != 0 {
                           
                            if cellClass.unitPrice.text?.count != 0 {
                               
                                if ((Int(cellClass.Qty.text!) != nil) && (Double(cellClass.unitPrice.text!) != nil)) {
                                    let qtyValue = Double(cellClass.Qty.text!)
                                    let price = Double(cellClass.unitPrice.text!)
                                    cellClass.cost.text = String(price! * qtyValue!)
                                    let obj = partsCostTotalArray[cellClass.tag]
                                    
                                    obj.itemno = cellClass.partsNo.text!
                                    obj.itemname = cellClass.partsName.text!
                                    obj.qty = Int(cellClass.Qty.text!)!
                                    obj.price = price!
                                    obj.cost = price! * qtyValue!
                                    obj.tax = ((price! * qtyValue!) * 5)/100
                                    //partsCostTotalArray.insert(obj, at: cellClass.unitPrice.tag)
                                    partsCostTotalArray[cellClass.tag] = obj
                                    self.calculateTaxesAmount()
                                }
                                
                            }else {
                                cellClass.cost.text = ""
                                let obj = partsCostTotalArray[cellClass.tag]
                                obj.itemno = ""
                                obj.itemname = ""
                                obj.qty = 0
                                obj.price = 0
                                obj.cost = 0
                                obj.tax = 0
                                partsCostTotalArray[cellClass.tag] = obj
                            }
                            
                        }else {
                            cellClass.cost.text = ""
                            let obj = partsCostTotalArray[cellClass.tag]
                            obj.itemno = ""
                            obj.itemname = ""
                            obj.qty = 0
                            obj.price = 0
                            obj.cost = 0
                            obj.tax = 0
                            partsCostTotalArray[cellClass.tag] = obj
                        }
                        
                    }else{
                        let obj = partsCostTotalArray[cellClass.tag]
                        obj.itemno = ""
                        obj.itemname = ""
                        obj.qty = 0
                        obj.price = 0
                        obj.cost = 0
                        obj.tax = 0
                        partsCostTotalArray[cellClass.tag] = obj
                    }
                    
                }else{
                    let obj = partsCostTotalArray[cellClass.tag]
                    obj.itemno = ""
                    obj.itemname = ""
                    obj.qty = 0
                    obj.price = 0
                    obj.cost = 0
                    obj.tax = 0
                    partsCostTotalArray[cellClass.tag] = obj
            }
                
            
            
        }

        
    }
    
    @objc func textFieldQtyDidChange(_ textField: UITextField) {
        
        
        
        let cell = textField.superview?.superview
        
        if (cell?.isKind(of: PartsCostTVC.self))!{
            
            let cellClass = cell as! PartsCostTVC
                                       
                if cellClass.partsNo.text?.count != 0 {
                   
                    if cellClass.partsName.text?.count != 0 {
                       
                        if cellClass.Qty.text?.count != 0 {
                           
                            if cellClass.unitPrice.text?.count != 0 {
                               
                                if ((Int(cellClass.Qty.text!) != nil) && (Double(cellClass.unitPrice.text!) != nil)) {
                                    let qtyValue = Double(cellClass.Qty.text!)
                                    let price = Double(cellClass.unitPrice.text!)
                                    cellClass.cost.text = String(price! * qtyValue!)
                                    let obj = partsCostTotalArray[cellClass.tag]
                                    
                                    obj.itemno = cellClass.partsNo.text!
                                    obj.itemname = cellClass.partsName.text!
                                    obj.qty = Int(cellClass.Qty.text!)!
                                    obj.price = price!
                                    obj.cost = price! * qtyValue!
                                    obj.tax = ((price! * qtyValue!) * 5)/100
                                    //partsCostTotalArray.insert(obj, at: cellClass.unitPrice.tag)
                                    partsCostTotalArray[cellClass.tag] = obj
                                    self.calculateTaxesAmount()
                                }
                                
                            }else {
                                cellClass.cost.text = ""
                                let obj = partsCostTotalArray[cellClass.tag]
                                obj.itemno = ""
                                obj.itemname = ""
                                obj.qty = 0
                                obj.price = 0
                                obj.cost = 0
                                obj.tax = 0
                                partsCostTotalArray[cellClass.tag] = obj
                            }
                            
                        }else {
                            cellClass.cost.text = ""
                            let obj = partsCostTotalArray[cellClass.tag]
                            obj.itemno = ""
                            obj.itemname = ""
                            obj.qty = 0
                            obj.price = 0
                            obj.cost = 0
                            obj.tax = 0
                            partsCostTotalArray[cellClass.tag] = obj
                        }
                        
                    }else{
                        let obj = partsCostTotalArray[cellClass.tag]
                        obj.itemno = ""
                        obj.itemname = ""
                        obj.qty = 0
                        obj.price = 0
                        obj.cost = 0
                        obj.tax = 0
                        partsCostTotalArray[cellClass.tag] = obj
                    }
                    
                }else{
                    let obj = partsCostTotalArray[cellClass.tag]
                    obj.itemno = ""
                    obj.itemname = ""
                    obj.qty = 0
                    obj.price = 0
                    obj.cost = 0
                    obj.tax = 0
                    partsCostTotalArray[cellClass.tag] = obj
            }
                
            
            
        }

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let cell = textField.superview?.superview
        
        if (cell?.isKind(of: PartsCostTVC.self))! {
            
            self.identifier = "PostCost"
            
        }else if (cell?.isKind(of: ServiceCostTVC.self))! {
            
            self.identifier = "ServiceType"
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let cell = textField.superview?.superview
        
        if (cell?.isKind(of: PartsCostTVC.self))!{
            
            let cellClass = cell as! PartsCostTVC
            
            //let unitCostIndex = (cell!.tag + 4)
            
            //if cellClass.unitPrice.tag == unitCostIndex {
               
                if cellClass.partsNo.text?.count != 0 {
                   
                    if cellClass.partsName.text?.count != 0 {
                       
                        if cellClass.Qty.text?.count != 0 {
                           
                            if cellClass.unitPrice.text?.count != 0 {
                               
                                if ((Int(cellClass.Qty.text!) != nil) && (Double(cellClass.unitPrice.text!) != nil)) {
                                    let qtyValue = Double(cellClass.Qty.text!)
                                    let price = Double(cellClass.unitPrice.text!)
                                    cellClass.cost.text = String(price! * qtyValue!)
                                    let obj = partsCostTotalArray[cellClass.tag]
                                    
                                    obj.itemno = cellClass.partsNo.text!
                                    obj.itemname = cellClass.partsName.text!
                                    obj.qty = Int(cellClass.Qty.text!)!
                                    obj.price = price!
                                    obj.cost = price! * qtyValue!
                                    obj.tax = ((price! * qtyValue!) * 5)/100
                                    //partsCostTotalArray.insert(obj, at: cellClass.tag)
                                    partsCostTotalArray[cellClass.tag] = obj
                                    self.calculateTaxesAmount()
                                }
                                
                            }else{
                                cellClass.cost.text = ""
                                let obj = partsCostTotalArray[cellClass.tag]
                                obj.itemno = ""
                                obj.itemname = ""
                                obj.qty = 0
                                obj.price = 0
                                obj.cost = 0
                                obj.tax = 0
                                partsCostTotalArray[cellClass.tag] = obj
                            }
                            
                        }else{
                            cellClass.cost.text = ""
                            let obj = partsCostTotalArray[cellClass.tag]
                            obj.itemno = ""
                            obj.itemname = ""
                            obj.qty = 0
                            obj.price = 0
                            obj.cost = 0
                            obj.tax = 0
                            partsCostTotalArray[cellClass.tag] = obj
                        }
                        
                    }else{
                        let obj = partsCostTotalArray[cellClass.tag]
                        obj.itemno = ""
                        obj.itemname = ""
                        obj.qty = 0
                        obj.price = 0
                        obj.cost = 0
                        obj.tax = 0
                        partsCostTotalArray[cellClass.tag] = obj
                    }
                    
                }else{
                    let obj = partsCostTotalArray[cellClass.tag]
                    obj.itemno = ""
                    obj.itemname = ""
                    obj.qty = 0
                    obj.price = 0
                    obj.cost = 0
                    obj.tax = 0
                    partsCostTotalArray[cellClass.tag] = obj
            }
                
            //}
            
        }else if (cell?.isKind(of: ServiceCostTVC.self))!{
            
            let cellClass = cell as! ServiceCostTVC
            //let totalHrs = (cell!.tag + 3)
            
            //if cellClass.totalHrs.tag == totalHrs {
                
                if cellClass.serviceType.text?.count != 0 {
                    
                    if cellClass.costHrs.text?.count != 0 {
                        
                        if cellClass.totalHrs.text?.count != 0 {
                            
                            if ((Double(cellClass.costHrs.text!) != nil) && (Double(cellClass.totalHrs.text!) != nil)) {
                                
                                let costPerHour = Double(cellClass.costHrs.text!)
                                let totalHours = Double(cellClass.totalHrs.text!)
                                cellClass.costText.text = String(costPerHour! * totalHours!)
                                let obj = serviceTypeTotalArray[cellClass.tag]
                                //var serviceType = ""
                                //var costHrs = 0.0
                                //var totalHrs = 0.0
                                //var cost = 0.0
                                //var tax = 0.0
                                obj.serviceType = cellClass.serviceType.text!
                                obj.costHrs = costPerHour!
                                obj.totalHrs = totalHours!
                                obj.cost = (costPerHour! * totalHours!)
                                obj.tax = ((costPerHour! * totalHours!) * 5)/100
                                obj.qty = totalHours!
                                
                                serviceTypeTotalArray[cellClass.tag] = obj
                                self.calculateTaxesAmount()
                            }
                            
                        }else{
                            cellClass.costText.text = ""
                            let obj = serviceTypeTotalArray[cellClass.tag]
                            obj.serviceType = ""
                            obj.costHrs = 0.0
                            obj.totalHrs = 0.0
                            obj.cost = 0.0
                            obj.tax = 0.0
                            obj.qty = 0.0
                            serviceTypeTotalArray[cellClass.tag] = obj
                            
                        }
                        
                    }else{
                        cellClass.costText.text = ""
                        let obj = serviceTypeTotalArray[cellClass.tag]
                        obj.serviceType = ""
                        obj.costHrs = 0.0
                        obj.totalHrs = 0.0
                        obj.cost = 0.0
                        obj.tax = 0.0
                        obj.qty = 0.0
                        serviceTypeTotalArray[cellClass.tag] = obj
                    }
                    
                }else{
                    let obj = serviceTypeTotalArray[cellClass.tag]
                    obj.serviceType = ""
                    obj.costHrs = 0.0
                    obj.totalHrs = 0.0
                    obj.cost = 0.0
                    obj.tax = 0.0
                    obj.qty = 0.0
                    serviceTypeTotalArray[cellClass.tag] = obj
                }

                
            //}
            
        }
        
    }
    
    @objc override func keyboardWasShown(notification : NSNotification) {

//        let userInfo = notification.userInfo!
//        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        var contentInset:UIEdgeInsets = self.scroll.contentInset
//        contentInset.bottom = keyboardFrame.size.height + 500
        //let scrollPoint = CGPoint(x: 0, y: 600)
        //scroll.contentInset = scrollPoint
        if self.identifier == "PostCost" {
        UIView.animate(withDuration: 0.1) {
            let scrollPoint = CGPoint(x: 0, y: 200)
            self.scroll .setContentOffset(scrollPoint, animated: true)
        }
        }else{
            
            UIView.animate(withDuration: 0.1) {
                let scrollPoint = CGPoint(x: 0, y: 350)
                self.scroll .setContentOffset(scrollPoint, animated: true)
            }
        }

    }

    @objc override func keyboardWillHide(notification:NSNotification){
        if (self.partsView != nil) {
            
            self.partsView.removeFromSuperview()
            self.partsView = nil
        }
        if (self.serviceTypeView != nil) {
            self.serviceTypeView.removeFromSuperview()
            self.serviceTypeView = nil
        }
        UIView.animate(withDuration: 0.1) {
            let scrollPoint = CGPoint(x: 0, y: 0)
            self.scroll .setContentOffset(scrollPoint, animated: true)
        }
    }
    
    //MARK: Item and Service's Tableview Update Frames
    
    fileprivate func updateTableViewFrame(button: PartsCostTVC){
        let updatedFrame = getSelectedBtnFrame(button: button)
        
        UIView.animate(withDuration: 0.5) {
            
            if (self.partsView != nil) {
                self.partsView.tableview.reloadData()
//                self.partsView.removeFromSuperview()
//                self.partsView = nil
            }else{
            self.partsView = PartsNumberView.instanceFromNib()
            self.partsView.frame = CGRect(x: updatedFrame.origin.x + 7, y: updatedFrame.origin.y + 30, width:
                74, height: 200)
            self.partsView.tableview.reloadData()
            self.partsView.delegate = self
            self.partsView.cell = button
            self.quotationTable.superview!.superview! .addSubview(self.partsView)
            }
            
            //self.moveView.frame.size.width = updatedFrame.width
            
            //self.moveView.frame.origin.x = updatedFrame.origin.x
        }
    }
    
    fileprivate func getSelectedBtnFrame(button: PartsCostTVC) -> CGRect {
        
        
        
        
        let convertedRect = button.convert(button.bounds, to: self.scroll)
        
        return convertedRect
        
        //        }
        //
        //        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    fileprivate func updateServiceCostTypeFrame(button: ServiceCostTVC){
            let updatedFrame = getSelectedServiceBtnFrame(button: button)

            UIView.animate(withDuration: 0.5) {

                if (self.serviceTypeView != nil) {
                    self.serviceTypeView.tableview.reloadData()
    //                self.partsView.removeFromSuperview()
    //                self.partsView = nil
                }else{
                self.serviceTypeView = ServiceTypeSearchView.instanceFromNib()
                self.serviceTypeView.frame = CGRect(x: updatedFrame.origin.x + 7, y: updatedFrame.origin.y + 30, width:
                    150, height: 200)
                self.serviceTypeView.tableview.reloadData()
                self.serviceTypeView.delegate = self
                self.serviceTypeView.cell = button
                self.serviceCostTable.superview!.superview! .addSubview(self.serviceTypeView)
                }

                //self.moveView.frame.size.width = updatedFrame.width

                //self.moveView.frame.origin.x = updatedFrame.origin.x
            }
        }

        fileprivate func getSelectedServiceBtnFrame(button: ServiceCostTVC) -> CGRect {




            let convertedRect = button.convert(button.bounds, to: self.scroll)

            return convertedRect

            //        }
            //
            //        return CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    
    //MARK: Calculate Taxes and Subtotal
    
    func calculateTaxesAmount() {
        
        var taxes = 0.0
        var subTotal = 0.0
        
        for object in partsCostTotalArray {
            
            subTotal  = subTotal + object.cost
            taxes = taxes + object.tax
        }
        
        for object1 in serviceTypeTotalArray {
            subTotal = subTotal + object1.cost
            taxes = taxes + object1.tax
        }
        
        self.totalTaxes.text = String(taxes)
        self.subTotal.text = String(subTotal)
        self.totalAmount.text = String(subTotal + taxes)
        
        self.totalTaxesValue = taxes
        self.subTotalValue = subTotal
        self.totalAmountValue = subTotal + taxes
        
    }
    
    //MARK: Parts Cost's Item Search Tableview Delegate
    
    func sendObjectID(pickedString: PartsCostItem, cell: PartsCostTVC) {
        cell.partsNo.text = pickedString.itemid
        cell.partsName.text = pickedString.itemname
        cell.Qty.text = String(1)
        cell.unitPrice.text = String(pickedString.price)
        cell.cost.text = String(pickedString.price * Double(1))
        
        let obj = partsCostTotalArray[cell.tag]
        
        obj.itemno = pickedString.itemid
        obj.itemname = pickedString.itemname
        obj.qty = 1
        //obj.qty = Int(pickedString.quantity)
        obj.price = pickedString.price
        obj.cost = pickedString.price * Double(obj.qty)
        let taxValue = pickedString.taxsettings["taxamount"] as! Double
        obj.tax = (obj.cost * Double(taxValue))/100
        //partsCostTotalArray.insert(obj, at: cell.tag)
        partsCostTotalArray[cell.tag] = obj
        self.calculateTaxesAmount()
        if (self.partsView != nil) {
            self.partsView.removeFromSuperview()
            self.partsView = nil
        }
        
    }
    //MARK: Service Cost's Service Type Search Tableview Delegates
    
    func sendServiceObjectID(pickedString: ServiceCostItem, cell: ServiceCostTVC) {
        
        cell.serviceType.text = pickedString.servicename
        cell.costHrs.text = String(pickedString.costperhour)
        cell.totalHrs.text = String(1)
        cell.costText.text = String(pickedString.costperhour * 1)
        
        let obj = serviceTypeTotalArray[cell.tag]
        
        obj.serviceType = pickedString.servicename
        obj.costHrs = pickedString.costperhour
        obj.totalHrs = 1
        obj.cost = pickedString.costperhour * 1
        obj.qty = 1
        let taxValue = pickedString.taxsettings["taxamount"] as! Double
        obj.tax = (obj.cost * Double(taxValue))/100
        //partsCostTotalArray.insert(obj, at: cell.tag)
        serviceTypeTotalArray[cell.tag] = obj
        //self.calculateTaxesAmount()
        if (self.serviceTypeView != nil) {
            self.serviceTypeView.removeFromSuperview()
            self.serviceTypeView = nil
        }
        
    }
    
    //MARK: Item Number Search Web Services
    
    func getItemNoPartsCost(search: String, cell: PartsCostTVC) {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.179:3030/api/getTechassignedjobs
        let params = ["request":["searchKey":search]]
        
        NetworkManager.sharedInstance.getOpenTicket(url: "/searchMaterial", parameter: params, header: header) { (response) in
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
                                        
                                        let partCost = Mapper<PartsCostItem>().mapArray(JSONArray: responseResult as! [[String : Any]])
                                        
                                        Singleton.sharedInstance.partsCostObjects.removeAll()
                                        
                                        if partCost.count != 0 {
                                            Singleton.sharedInstance.partsCostObjects.append(contentsOf: partCost)
                                               self.updateTableViewFrame(button: cell)
                                            
                                        }else{
                                            if (self.partsView != nil) {
                                                self.partsView.removeFromSuperview()
                                                self.partsView = nil
                                            }
                                        }
                                        
                                        
                                        
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
    
    //MARK: Service Cost Search Web Service
    
    func getServiceCostType(search: String, cell: ServiceCostTVC) {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.229:3030/api/searchServicecost
        let params = ["request":["searchKey":search]]
        
        NetworkManager.sharedInstance.getOpenTicket(url: "/searchServicecost", parameter: params, header: header) { (response) in
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
                                        
                                        let partCost = Mapper<ServiceCostItem>().mapArray(JSONArray: responseResult as! [[String : Any]])

                                        Singleton.sharedInstance.serviceTypeObjects.removeAll()

                                        if partCost.count != 0 {
                                            Singleton.sharedInstance.serviceTypeObjects.append(contentsOf: partCost)
                                               self.updateServiceCostTypeFrame(button: cell)

                                        }else{
                                            if (self.serviceTypeView != nil) {
                                                self.serviceTypeView.removeFromSuperview()
                                                self.serviceTypeView = nil
                                            }
                                        }
                                        
                                        
                                        
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

    //MARK: Preview Quotation Web Service
    @IBAction func previewQuotationsActions() {
        
        /*
         jobid
         materials[]
             itemno
             itemname
             qty
             price
             cost
             tax
         servicecost[]
             servicename
             fixedcost
             cost
             tax
         subtotal
         totaltax
         */
        
        var materials = [[String:Any]]()
        var service = [[String:Any]]()
        
        
        for value in partsCostTotalArray {
            
            if value.itemno.count != 0 && value.itemname.count != 0 && value.qty != 0 && value.price != 0.0 && value.cost != 0 {
                
                
                let materialValue = ["itemno":value.itemno,"itemname":value.itemname,"qty":value.qty,"price":value.price,"cost":value.cost,"tax":value.tax] as [String : Any]
                
                materials.append(materialValue)
                
            }else{
                self.showAlertMessage(title: "Alert", message: "Please Fill all the incomplete Fields") {
                    
                }
                return
            }
            
        }
        
        for value in serviceTypeTotalArray {
            
            if value.serviceType.count != 0 && value.costHrs != 0 && value.totalHrs != 0 && value.cost != 0 {
                
                let serviceValue = ["servicename":value.serviceType,"fixedcost":value.costHrs,"cost":value.cost,"tax":value.tax,"qty":value.qty] as [String : Any]
                service.append(serviceValue)
                
            }else{
                self.showAlertMessage(title: "Alert", message: "Please Fill all the incomplete Fields") {
                    
                }
                return
            }
            
        }
        
        
        let params = ["jobid":jobDetailObjects.id,"materials":materials,"servicecost":service,"subtotal":self.subTotalValue,"totaltax":self.totalTaxesValue,"email":clientDetailsObject.email,"clientid":clientDetailsObject.clientsId,"jobstatusid":self.statusQuotation] as [String : Any]
        let param = ["request":params]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data

            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data

            // you can now cast it with the right type
            if let dictFromJSON = decoded as? [String:Any] {
                // use dictFromJSON
                print("value",dictFromJSON)
            }
        } catch {
            print(error.localizedDescription)
        }
        print("val=",param)
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.229:3030/api/getClientByJob
        
        //http://192.168.1.179:3030/api/getTechassignedjobdetail
        NetworkManager.sharedInstance.postQuotations(url: self.quoteURLString, parameter: param, header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                if self.statusQuotation == 10 || self.statusQuotation == 9 {
                                    self.showAlertMessage(title: "Alert", message: "Quotation successfully sent to this \(self.clientDetailsObject.email)") {
                                        
                                        DispatchQueue.main.async {
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                    
                                }
                                    
                                }else if self.statusQuotation == 12 || self.statusQuotation == 13 {
                                    
                                    self.showAlertMessage(title:  "Alert", message: "Invoice successfully sent to this \(self.clientDetailsObject.email)") {
                                        
                                        DispatchQueue.main.async {
                                            self.navigationController?.popToRootViewController(animated: true)
                                        }
                                        
                                    }
                                    
                                }
                                
                                //if let responseData = responseCode["data"] as? NSDictionary {
                                    
                                    
                                    
                                //}
                                
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
    //MARK: End
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
