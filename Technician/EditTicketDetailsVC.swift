//
//  EditTicketDetailsVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 16/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import GoogleMaps

class EditTicketDetailsVC: BaseVC,GMSMapViewDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var numberText: UILabel!
    
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var problemTextView: UITextView!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var baseMapView: UIView!
    var dobPickerView:UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var agreeDate: UITextField!
    
    
    var mapView:GMSMapView!
    
    var jobDetailObjects: OpenTicketsList!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationBarTitleView(title: "Edit Job Details", image: UIImage())
//        nameText.text = jobDetailObjects.clientname
//        numberText.text = jobDetailObjects.mobile
//        addressTextView.text = jobDetailObjects.address
        //notesTextView.text = jobDetailObjects.
        // Do any additional setup after loading the view.
        self.addDoneButtonOnKeyboard(textView: addressTextView)
        self.addDoneButtonOnKeyboard(textView: notesTextView)
        self.addDoneButtonOnKeyboard(textView: problemTextView)
        setInputField()
        self.agreeDate.text = jobDetailObjects.scheduledate + " " + jobDetailObjects.scheduletime
        if Double(jobDetailObjects.latitude) != nil && Double(jobDetailObjects.longitude) != nil {
        let camera = GMSCameraPosition.camera(withLatitude: Double(jobDetailObjects.latitude)!, longitude: Double(jobDetailObjects.longitude)!, zoom: 3.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.baseMapView.frame.size.width, height: self.baseMapView.frame.size.height), camera: camera)
        mapView.settings.indoorPicker = true
        mapView.mapType = .normal
        self.mapView.delegate = self
        
        let position = CLLocationCoordinate2D(latitude: Double(jobDetailObjects.latitude)!, longitude: Double(jobDetailObjects.longitude)!)
        let mapIcon = MapIconView.instanceFromNib()
        mapIcon.frame = CGRect(x: 0, y: 0, width:
            109, height: 75)
        mapIcon.jobName.text = jobDetailObjects.jobid
        let london = GMSMarker(position: position)
        london.title = "London"
        london.iconView = mapIcon
        london.map = self.mapView
        self.baseMapView .addSubview(mapView)
    }
        self.getTicketDetails()
    }
    
    func getTicketDetails() {
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.179:3030/api/getTechassignedjobs
        
        let param = ["request":["jobid":jobDetailObjects.id]]
        //http://192.168.1.179:3030/api/getTechassignedjobdetail
        NetworkManager.sharedInstance.getTicketDetails(url: "/getTechassignedjobdetail", parameter: param, header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                    
                                    if let responseResult = responseData["result"] as? NSDictionary {
                                        
                                        if let jobResult = responseResult["jobResult"] as? NSArray {
                                            
                                            if let ticketDetails = jobResult[0] as? [String: AnyObject] {
                                                DispatchQueue.main.async(execute: {
                                                    self.nameText.text = ticketDetails["clientname"] as! String
                                                    self.numberText.text = ticketDetails["mobile"] as! String
                                                    
                                                    self.addressTextView.text = ticketDetails["address"] as! String
                                                    
                                                    //                                                    self.addressText.text = "#327 Nehru nagar 3rd Main road, OMR Kottivakam, Chennai 600096, Tamil nadu."
                                                    
                                                    self.problemTextView.text = ticketDetails["description"] as! String
                                                    
                                                    //                                                    self.ProlemNotesText.text = "#327 Nehru nagar 3rd Main road, OMR Kottivakam, Chennai 600096, Tamil nadu."
                                                    
                                                })
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        if let jobNotes = responseResult["notes"] as? NSArray {
                                            
                                            if jobNotes.count != 0 {
                                                
                                                if let notes = jobNotes[0] as? NSDictionary {
                                                    
                                                    self.notesTextView.text = notes["message"] as! String
                                                    //                                                self.internalText.text = "#327 Nehru nagar 3rd Main road, OMR Kottivakam, Chennai 600096, Tamil nadu."
                                                    //self.internalNotesHeight.constant = 110
                                                    //self.internalBaseView.updateConstraints()
                                                    //self.internalBaseView.layoutIfNeeded()
                                                    
                                                    
                                                }
                                                
                                            }else {
                                                //self.internalNotesHeight.constant = 0
                                                //self.internalBaseView.updateConstraints()
                                                //self.internalBaseView.layoutIfNeeded()
                                                
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

    @IBAction func updateAction(sender: UIButton){
        
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        //http://192.168.1.179:3030/api/getTechassignedjobs
        
        let param = ["request":["jobid":jobDetailObjects.id]]
        //http://192.168.1.179:3030/api/getTechassignedjobdetail
        NetworkManager.sharedInstance.getTicketDetails(url: "/getTechassignedjobdetail", parameter: param, header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print("values=",response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                    
                    if let responseCode = responseValue["response"] as? NSDictionary {
                        
                        if let code = responseCode["code"] as? String {
                            
                            if code == "OK" {
                                
                                if let responseData = responseCode["data"] as? NSDictionary {
                                    
                                    if let responseResult = responseData["result"] as? NSDictionary {
                                        
                                        if let jobResult = responseResult["jobResult"] as? NSArray {
                                            
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
    
    // MARK: -Text Field Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    @objc override func keyboardWasShown(notification : NSNotification) {
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scroll.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scroll.contentInset = contentInset
        
    }
    
    @objc override func doneButtonAction() {
        
        self.addressTextView.resignFirstResponder()
        self.notesTextView.resignFirstResponder()
        self.problemTextView.resignFirstResponder()
        self.agreeDate.resignFirstResponder()
    }
    
    @objc override func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scroll.contentInset = contentInset
    }
    
    // MARK: Textview Delegate
    
    func textViewDidBeginEditing(_ textView: UITextView){
        UIView.animate(withDuration: 0.1) {
            let scrollPoint = CGPoint(x: 0, y: textView.superview!.frame.origin.y)
            self.scroll .setContentOffset(scrollPoint, animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        UIView.animate(withDuration: 0.1) {
            let scrollPoint = CGPoint(x: 0, y: 0)
            self.scroll .setContentOffset(scrollPoint, animated: true)
        }
    }
    
    @IBAction func updateDetails(sender: UIButton){
        
        
            let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
            var param = [String: [String: Any]]()
            param = ["request":["jobid":jobDetailObjects!.id,"description":problemTextView.text!,"notes":notesTextView.text!,"agreeddate":self.agreeDate.text!,"address":addressTextView.text!]]
            //let param = ["request":["jobid":jobDetailObjects.id]]
            NetworkManager.sharedInstance.postJobEditDetails(url: "/updateTechjobinfo", parameter: param, header: header) { (response) in
                
                switch response.result {
                case .success(_):
                    
                    print("values=",response.result.value!)
                    if let responseValue = response.result.value as? NSDictionary {
                        
                        if let responseCode = responseValue["response"] as? NSDictionary {
                            
                            if let code = responseCode["code"] as? String {
                                
                                if code == "OK" {
                                    
                                    if let responseData = responseCode["data"] as? NSDictionary {
                                        
                                        if let responseResult = responseData["result"] as? NSDictionary {
                                            
                                            if let resultArray = responseResult["jobresult"] as? NSArray {
                                                
                                                
                                                
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
    
    func setInputField() {
        let newDateComponents = NSDateComponents()
        newDateComponents.month = 1
        newDateComponents.day = 0
        newDateComponents.year = 0
        dobPickerView.minimumDate = Date()
        dobPickerView.maximumDate = NSCalendar.current.date(byAdding: newDateComponents as DateComponents, to: NSDate() as Date)
        
        dobPickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        self.agreeDate.inputView = dobPickerView
        dobPickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        self.addDoneButtonOnKeyboard(textField: agreeDate)
    }
    
    
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        // NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
        let locale = NSLocale.init(localeIdentifier: "en_US")
        print(locale)
        //"MM/dd/YYYY HH:mm:ss",yyyy/MMM/dd HH:mm:ss
        //dateFormatter.dateFormat = "dd/MM/YYYY"
        //2019-09-13 17:49:17
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormatter.dateFormat = "mm/dd/yyyy HH:mm:ss"
        dateFormatter.locale = Locale.current
        agreeDate.text = dateFormatter.string(from: sender.date)
        
        
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
