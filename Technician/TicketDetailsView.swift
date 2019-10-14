//
//  TicketDetailsView.swift
//  Technician
//
//  Created by K Saravana Kumar on 09/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectMapper

class TicketDetailsView: BaseVC,GMSMapViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var mobileText: UILabel!
    @IBOutlet weak var ProlemNotesText: UILabel!
    @IBOutlet weak var internalText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var editTextButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navigateButton: UIButton!
    
    @IBOutlet weak var internalBaseView: UIView!
    
    @IBOutlet weak var ticketDetailtime: UILabel!
    @IBOutlet weak var jobStatus: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    
    var agrPickerView:UIDatePicker = UIDatePicker()
    
    @IBOutlet weak var modifiedDate: UITextField!
    @IBOutlet weak var modifiedNotes: UITextView!
    @IBOutlet weak var modifiedDes: UITextView!
    
    @IBOutlet weak var internalNotesHeight: NSLayoutConstraint!
    
    var mapView:GMSMapView!
    @IBOutlet weak var bottomView: UIView!
    
    var jobDetailObjects: OpenTicketsList!
    var jobDetails: JobDetails!
    var dateString = ""
    var updateDict = [String: Any]()
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commonClickBtn: UIButton!
    
    @IBOutlet weak var jobScheduleHeight: NSLayoutConstraint!
    
    @IBOutlet weak var baseMapView: UIView!
    
    var optionReferenceView: BottomOptionsView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationBarTitleView(title: "Job Details View", image: UIImage())
        // Do any additional setup after loading the view.
        updateDict["jobid"] = jobDetailObjects.id
        self.addDoneButtonOnKeyboard(textView: modifiedNotes)
        self.addDoneButtonOnKeyboard(textView: modifiedDes)
//        modifiedDes.
//
//        modifiedNotes.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.updateButton.isHidden = true
        modifiedDate.isHidden = true
        modifiedNotes.isHidden = true
        modifiedDes.isHidden = true
        setInputField()
        
        
        if Double(jobDetailObjects.latitude) != nil && Double(jobDetailObjects.longitude) != nil {
        
        let camera = GMSCameraPosition.camera(withLatitude: Double(jobDetailObjects.latitude)!, longitude: Double(jobDetailObjects.longitude)!, zoom: 0.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.baseMapView.frame.size.width, height: self.baseMapView.frame.size.height), camera: camera)
            self.mapView.animate(to: camera)

        mapView.settings.indoorPicker = true
        mapView.mapType = .normal
        self.mapView.delegate = self
        
        let position = CLLocationCoordinate2D(latitude: Double(jobDetailObjects.latitude)!, longitude: Double(jobDetailObjects.longitude)!)
        let mapIcon = MapIconView.instanceFromNib()
        mapIcon.frame = CGRect(x: 0, y: 10, width:
            109, height: 75)
        mapIcon.jobName.text = jobDetailObjects.jobid
        let london = GMSMarker(position: position)
        //london.title = "London"
        london.iconView = mapIcon
        london.map = self.mapView
            
        //mapView.myLocation?.coordinate.
        
        self.baseMapView .addSubview(mapView)
        }
        self.ticketDetailtime.text = jobDetailObjects.scheduledate + " " + jobDetailObjects.scheduletime
        self.getTicketDetails()
        modifiedDes.translatesAutoresizingMaskIntoConstraints = false
        modifiedDes.isScrollEnabled = false
        
        modifiedNotes.translatesAutoresizingMaskIntoConstraints = false
        modifiedNotes.isScrollEnabled = false
        //mapView.animate(toZoom: 15)
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
                                                
                                                    if let ticketDetailObject = Mapper<JobDetails>().map(JSON: ticketDetails) {
                                                        
                                                        self.jobStatus.text = ticketDetailObject.jobstatus
                                                        if ticketDetailObject.jobstatusid == 4 || ticketDetailObject.jobstatusid == 3 {
                                                            self.bottomView.isHidden = true
                                                            
                                                            self.editButton.isHidden = false
                                                            self.editTextButton.isHidden = false
                                                            self.statusViewHeight.constant = 18
                                                            self.statusView.updateConstraints()
                                                            self.statusView.layoutIfNeeded()
                                                        }else if ticketDetailObject.jobstatusid == 5 {
                                                            self.bottomView.isHidden = false
                                                            self.commonClickBtn.isHidden = true
                                                            self.backButton.isHidden = false
                                                            self.navigateButton.isHidden = false
                                                            self.editButton.isHidden = false
                                                            self.editTextButton.isHidden = false
                                                            
                                                            self.statusViewHeight.constant = 18
                                                            self.statusView.updateConstraints()
                                                            self.statusView.layoutIfNeeded()
                                                        }else if ticketDetailObject.jobstatusid == 6 {
                                                            
                                                            
                                                            self.bottomView.isHidden = false
                                                            self.commonClickBtn.isHidden = false
                                                            self.backButton.isHidden = true
                                                            self.navigateButton.isHidden = true
                                                            self.editButton.isHidden = true
                                                            self.editTextButton.isHidden = true
                                                            
                                                            self.statusViewHeight.constant = 0
                                                            self.statusView.updateConstraints()
                                                            self.statusView.layoutIfNeeded()
                                                            
                                                        }
                                                     self.jobDetails = ticketDetailObject
                                                        
                                                        self.nameText.text = self.jobDetails.clientname
                                                        self.mobileText.text = self.jobDetails.mobile
                                                        
                                                        self.addressText.text = self.jobDetails.address
                                                        
                                                        //                                                    self.addressText.text = "#327 Nehru nagar 3rd Main road, OMR Kottivakam, Chennai 600096, Tamil nadu."
                                                        
                                                        self.ProlemNotesText.text = self.jobDetails.description
                                                        
                                                        self.modifiedDes.text = self.jobDetails.description
                                                        
                                                    }
                                                    
                                                
                                                    
//                                                    self.ProlemNotesText.text = "#327 Nehru nagar 3rd Main road, OMR Kottivakam, Chennai 600096, Tamil nadu."
                                                    
                                                })
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        if let jobNotes = responseResult["notes"] as? NSArray {
                                            
                                            if jobNotes.count != 0 {
                                                
                                            if let notes = jobNotes[0] as? NSDictionary {
                                                
                                                if let message = notes["message"] as? String {
                                                    
                                                    self.internalText.text = message
                                                    self.modifiedNotes.text = (notes["message"] as! String)
                                                    
                                                }else{
                                                    
                                                }

                                                
                                            }
                                                
                                            }else {
                                                
                                                
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
    
    // MARK: MAPVIEW Delegates
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        print("map zoom is ",String(zoom))
        
        
        
    }
    
    //
    
//    @IBAction func scheduleAction(sender: UIButton){
//
//        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
//        var param = [String: [String: Any]]()
//        if jobDetailObjects!.jobstatus == "Assigned" {
//            param = ["request":["jobid":jobDetailObjects!.id,"type":"schedule"]]
//        }
//        //let param = ["request":["jobid":jobDetailObjects.id]]
//        NetworkManager.sharedInstance.postScheduleJob(url: "/updateTechjobstatus", parameter: param, header: header) { (response) in
//
//            switch response.result {
//            case .success(_):
//
//                print("values=",response.result.value!)
//                if let responseValue = response.result.value as? NSDictionary {
//
//                    if let responseCode = responseValue["response"] as? NSDictionary {
//
//                        if let code = responseCode["code"] as? String {
//
//                            if code == "OK" {
//
//                                if let responseData = responseCode["data"] as? NSDictionary {
//
//                                    if let responseResult = responseData["result"] as? NSDictionary {
//
//                                        if let resultArray = responseResult["jobresult"] as? NSArray {
//
//
//
//                                        }
//
//
//
//                                    }
//                                }
//
//                            }
//                        }
//                    }
//                }
//
//            case .failure(_):
//
//                print("error")
//
//            }
//
//        }
//
//    }
    
    @IBAction func ticketEditAction(sender: UIButton){
        
        //self.performSegue(withIdentifier: "editticketdetails", sender: self)
        self.updateButton.isHidden = false
        self.modifiedDate.isHidden = false
        self.modifiedNotes.isHidden = false
        self.modifiedDes.isHidden = false
        
        var statusString = ""
        
        if self.jobDetails.jobstatusid == 4 || self.jobDetails.jobstatusid == 3 {
            
            statusString = "Add To Schedule"
            
        }else if self.jobDetails.jobstatusid == 5 {
            
            statusString = "In-Transit"
            
        }else if self.jobDetails.jobstatusid == 6 {
            
            statusString = "Check-In"
            
        }
        
        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: statusString, style: .default , handler:{ (UIAlertAction)in
//            print("User click Approve button")
//
//
//
//            if self.jobDetails.jobstatusid == 4 || self.jobDetails.jobstatusid == 3 {
//
//                self.jobStatus.text = "Scheduled"
//                self.updateDict["jobstatusid"] = 5
//                self.modifiedDate.becomeFirstResponder()
//
//            }else if self.jobDetails.jobstatusid == 5 {
//
//                //statusString = "In-Transit"
//                self.jobStatus.text = "Started"
//                self.updateDict["jobstatusid"] = 6
//                self.modifiedDes.becomeFirstResponder()
//
//            }else if self.jobDetails.jobstatusid == 6 {
//                self.jobStatus.text = "Check-In"
//                self.updateDict["jobstatusid"] = 7
//
//            }
//
//        }))
//
//
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:{ (UIAlertAction)in
//            print("User click Dismiss button")
//            self.updateButton.isHidden = true
//            self.modifiedDate.isHidden = true
//            self.modifiedNotes.isHidden = true
//            self.modifiedDes.isHidden = true
//        }))
//        //alert.view.backgroundColor = UIColor.white
//        for view1 in alert.view.subviews {
//            if view1.isKind(of: UIView.self) {
//
//                for view2 in view1.subviews {
//
//                    for view3 in view2.subviews {
//
//                        for view4 in view3.subviews {
//
//                            for view5 in view4.subviews {
//
//
//                                view5.backgroundColor = UIColor.red
//
//
////                                if view5.isKind(of: UIButton.self) {
////                                    view5.backgroundColor = UIColor.red
////                                }
//
//                            }
//
//
//
//                        }
//                    }
//                }
//
//            }else{
//
//            }
//
//        }
//        //alert.view.tintColor = UIColor.black
//
//        self.present(alert, animated: true, completion: {
//            print("completion block")
//        })
        
       self.optionReferenceView = self.bottomPopupView(view: self.view)
       self.optionReferenceView.statusButton.setTitle(statusString, for: .normal)
        self.optionReferenceView.statusButton.addTarget(self, action: #selector(self.statusUpdateAction(sender:)), for: .touchUpInside)
        self.optionReferenceView.closeButton.addTarget(self, action: #selector(closeAction(sender:)), for: .touchUpInside)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == modifiedDes{
           // self.ProlemNotesText.isHidden = true
            self.ProlemNotesText.text = textView.text
            //modifiedTextView.text = textField.text
        }else if textView == modifiedNotes {
            self.internalText.text = textView.text
        }
        
    }
    
    override func myviewTapped(gesture: UIGestureRecognizer) {
        self.closeSuccessView(sender: self.optionReferenceView)
        self.updateButton.isHidden = true
        self.modifiedDate.isHidden = true
        self.modifiedNotes.isHidden = true
        self.modifiedDes.isHidden = true
    }
    
    @IBAction func closeAction(sender: UIButton){
        
        self.closeSuccessView(sender: self.optionReferenceView)
        
        self.updateButton.isHidden = true
        self.modifiedDate.isHidden = true
        self.modifiedNotes.isHidden = true
        self.modifiedDes.isHidden = true
        
    }
    
    @IBAction func statusUpdateAction(sender: UIButton){
        
        self.closeSuccessView(sender: self.optionReferenceView)
        
        if self.jobDetails.jobstatusid == 4 || self.jobDetails.jobstatusid == 3 {
            
            self.jobStatus.text = "Scheduled"
            self.updateDict["jobstatusid"] = 5
            self.modifiedDate.becomeFirstResponder()
            
        }else if self.jobDetails.jobstatusid == 5 {
            
            //statusString = "In-Transit"
            self.jobStatus.text = "Started"
            self.updateDict["jobstatusid"] = 6
            self.modifiedDes.becomeFirstResponder()
            
        }else if self.jobDetails.jobstatusid == 6 {
            self.jobStatus.text = "Check-In"
            self.updateDict["jobstatusid"] = 7
            
        }else if self.jobDetails.jobstatusid == 7 {
            
            self.jobStatus.text = "Check Out"
            self.updateDict["jobstatusid"] = 8
            
        }
    
    }
    
    @IBAction func updateAction(sender: UIButton){
        
        self.showActivityIndicator()
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        var param = [String: [String: Any]]()
            self.updateDict["description"] = self.ProlemNotesText.text!
            self.updateDict["notes"] = self.internalText.text!
        param = ["request": self.updateDict]
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
                                
                                self.updateButton.isHidden = true
                                self.bottomView.isHidden = false
                                self.getTicketDetails()
                                
                                if self.jobStatus.text == "Scheduled" {
                                    DispatchQueue.main.async {
                                        self.bottomView.isHidden = false
                                        self.performSegue(withIdentifier: "fromJobDetailViewToSchedule", sender: self)
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
    
    // MARK: TextField Delegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.modifiedDes {
            self.updateDict["description"] = self.ProlemNotesText.text!
            self.modifiedNotes.becomeFirstResponder()
        }else if textField == self.modifiedNotes {
            self.updateDict["notes"] = self.internalText.text!
           textField.resignFirstResponder()
        }
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
    
    @objc override func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scroll.contentInset = contentInset
    }
    
    func setInputField() {
        let newDateComponents = NSDateComponents()
        newDateComponents.month = 1
        newDateComponents.day = 0
        newDateComponents.year = 0
        agrPickerView.minimumDate = Date()
        agrPickerView.maximumDate = NSCalendar.current.date(byAdding: newDateComponents as DateComponents, to: NSDate() as Date)
        
        agrPickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        self.modifiedDate.inputView = agrPickerView
        //agrPickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        //self.addDoneButtonOnKeyboard(textField: modifiedDate)
        self.addDoneButtonOnPicker(textView: modifiedDate, LeftText: "Start Time", tag: 5)
    }
    
    func setEndTimeFields() {
        let date = agrPickerView.date
        self.addDoneButtonOnPicker(textView: modifiedDate, LeftText: "End Time", tag: 6)
        let newDateComponents = NSDateComponents()
        newDateComponents.hour = 8
        newDateComponents.month = 0
        newDateComponents.day = 0
        newDateComponents.year = 0
        agrPickerView.minimumDate = date
        agrPickerView.maximumDate = NSCalendar.current.date(byAdding: newDateComponents as DateComponents, to: NSDate() as Date)
        
        agrPickerView.datePickerMode = .time
        
        self.modifiedDate.inputView = agrPickerView
        //agrPickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        //self.addDoneButtonOnKeyboard(textField: modifiedDate)
        
    }
    
    override func doneButtonAction() {
        self.modifiedDate.resignFirstResponder()
        self.modifiedDes.resignFirstResponder()
        self.modifiedNotes.resignFirstResponder()
    }
    
    @IBAction override func valueChangedAction(sender: UIBarButtonItem) {
        
        if sender.tag == 5 {
        
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
        dateString = dateFormatter.string(from: agrPickerView.date)
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        //        dateFormatter.dateFormat = "mm/dd/yyyy HH:mm:ss"
        dateFormatter.locale = Locale.current
        //modifiedDate.text = dateFormatter.string(from: sender.date)
        self.ticketDetailtime.text = dateFormatter.string(from: agrPickerView.date)
        self.updateDict["schedulestartdate"] = dateString
        self.modifiedDate.resignFirstResponder()
        self.setEndTimeFields()
        self.modifiedDate.becomeFirstResponder()
        }else{
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = DateFormatter.Style.medium
            
            dateFormatter.timeStyle = DateFormatter.Style.none
            // NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"EN"];
            let locale = NSLocale.init(localeIdentifier: "en_US")
            print(locale)
            //"MM/dd/YYYY HH:mm:ss",yyyy/MMM/dd HH:mm:ss
            //dateFormatter.dateFormat = "dd/MM/YYYY"
            //2019-09-13 17:49:17
            dateFormatter.dateFormat = "HH:mm"
            //dateString = dateFormatter.string(from: agrPickerView.date)
            dateFormatter.dateFormat = "HH:mm"
            //        dateFormatter.dateFormat = "mm/dd/yyyy HH:mm:ss"
            dateFormatter.locale = Locale.current
            //modifiedDate.text = dateFormatter.string(from: sender.date)
            //self.ticketDetailtime.text = dateFormatter.string(from: agrPickerView.date)
            //self.updateDict["scheduledate"] = dateString
            print(dateFormatter.string(from: agrPickerView.date))
            let dateArray = dateString.components(separatedBy: " ")
            let appendedString = (dateArray.first)! + " " + dateFormatter.string(from: agrPickerView.date) + ":00"
            self.updateDict["scheduleenddate"] = appendedString
            print("ValueAddedString=",appendedString)
            self.modifiedDes.becomeFirstResponder()
            
        }
        
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
        dateString = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        //        dateFormatter.dateFormat = "mm/dd/yyyy HH:mm:ss"
        dateFormatter.locale = Locale.current
        //modifiedDate.text = dateFormatter.string(from: sender.date)
        self.ticketDetailtime.text = dateFormatter.string(from: sender.date)
        self.updateDict["scheduledate"] = dateString
        self.modifiedDes.becomeFirstResponder()
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextView) {
        
        if textField == modifiedDes{
           // self.ProlemNotesText.isHidden = true
            self.ProlemNotesText.text = textField.text
            //modifiedTextView.text = textField.text
        }else if textField == modifiedNotes {
            self.internalText.text = textField.text
        }
        
    }
    
    @IBAction func navigateAction(sender: UIButton){
        
        self.performSegue(withIdentifier: "fromJDToJM", sender: self)
        
    }
    
    @IBAction func checkInAction(sender: UIButton){
        
        
        self.showActivityIndicator()
        let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
        var param = [String: [String: Any]]()
        self.updateDict["jobstatusid"] = 7
        param = ["request": self.updateDict]
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
                                    
                                    self.performSegue(withIdentifier: "fromTDtoCT", sender: self)
                                    
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
    
    @IBAction func backAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editticketdetails" {
            
            let view = segue.destination as! EditTicketDetailsVC
            view.jobDetailObjects = jobDetailObjects
            
        }else if segue.identifier == "fromJDToJM" {
            
            let view = segue.destination as! JobMapViewVC
            view.mapArray = [jobDetailObjects]
            
        }else if segue.identifier == "fromJobDetailViewToSchedule"{
            let view = segue.destination as! MyscheduleVC
            view.segueIdentifier = "fromJobDetailViewToSchedule"
            
        }else if segue.identifier == "fromTDtoCT" {
            let view = segue.destination as! TicketDetailsVC
            view.jobDetailObjects = jobDetailObjects
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
