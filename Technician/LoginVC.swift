//
//  LoginVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 14/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper
import SlideMenuControllerSwift

class LoginVC: BaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var secutrityHide: UIButton!
    @IBOutlet weak var rememberMe: UIButton!
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var forgetTapGesture: UITapGestureRecognizer!

    @IBOutlet weak var signTop: NSLayoutConstraint!
    @IBOutlet weak var toptext: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var topLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var safeBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.adjustConstraints()
        let img = UIImage(named: "loginbg")
        scroll.layer.contentsGravity = .resizeAspectFill
        scroll.layer.contents = img?.cgImage
        self.scroll.backgroundColor = UIColor.black.withAlphaComponent(0.25)
//        self.scroll.contentSize = CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height)
        //Username : sreenatarajan+28@securenext.in
        //rw3nvpmc
//       self.userText.text = "ifthekar.patan@gmail.com"
//       self.passwordText.text = "fs14nlb7"
        //self.userText.text = "ramkumar@securenext.in"
        //self.passwordText.text = "123456"
        //boopathig89@gmail.com
        //123456
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginAction(sender: UIButton){
        
        //testuser1@gmail.com
        //123123
        
        if self.userText.text?.count != 0 {
            
            if self.passwordText.text?.count != 0 {
        
                let param = ["request":["email":self.userText.text!,"password":self.passwordText.text!,"devicetype":"iOS","devicetoken":Singleton.sharedInstance.getDeviceToken(),"firebasetoken":Singleton.sharedInstance.getFirebaseToken()]]
                
//let param = ["request":["email":self.userText.text!,"password":self.passwordText.text!,"devicetype":"iOS","devicetoken":"16C0452F-7784-4E71-893A-5CBFE15FAF6C","firebasetoken":"dCbQkUa5P00:APA91bHEh2DhxxfuU4-RteRfowPlO_Ll2i26Enc6_-gssbpC7npGxksNh7VAL6YDsR9vZg2FmQAjhmYAagdxQvAhC8h73aAomHMksbjWDZ32uANnWUZWRpnYVsGQTYkpU82OOaeF5CgW"]]
        
        let header = ["Content-Type":"application/json"]
        self.showActivityIndicator()
        NetworkManager.sharedInstance.postLogin(url: "/tech/login", parameter: param, header: header) { (response) in
            self.hideActivityIndicator()
            switch response.result {
            case .success(_):
                print(response.result.value!)
                if let responseValue = response.result.value as? NSDictionary {
                
                    print(responseValue)
                    if let responseDict = responseValue["response"] as? NSDictionary {
                    if responseDict["code"] as! String == "OK" {
                        
                        //Singleton.sharedInstance.setRememberMeStatus(status: false)
                        
                        Singleton.sharedInstance.setUserNamePassword(username: self.userText.text!, password: self.passwordText.text!)
                        
                    
                    if let techInfo = Mapper<TechDetails>().map(JSON: responseDict["data"] as! [String: Any]){
                        
                        print(techInfo.token)
                        Singleton.sharedInstance.setTechToken(token: techInfo.token)
                        Singleton.sharedInstance.setTechInfo(object: techInfo)
                        let mainNavigationController =
                            self.mainStoryBoard.instantiateViewController(withIdentifier: "MainNavigationController")
                        
                        let menuNavigationController =
                            self.mainStoryBoard.instantiateViewController(withIdentifier: "MenuNavigationController") as! UINavigationController
                        SlideMenuOptions.leftViewWidth = UIScreen.main.bounds.width * 0.75
                        SlideMenuOptions.contentViewOpacity = 0
                        SlideMenuOptions.contentViewScale = 1
                        SlideMenuOptions.simultaneousGestureRecognizers = false
                        
                        self.slideMenuViewController = SlideMenuController(mainViewController: mainNavigationController, leftMenuViewController: menuNavigationController)
                        self.slideMenuViewController.modalPresentationStyle = .fullScreen
                        self.present(self.slideMenuViewController, animated: true, completion: nil)
                        
                    }
                    }else {
                        
                        self.showAlertMessage(title: "Alert", message: "Please enter the correct Username and Password") {
                            
                        }
                        
                 }
                }
                    
                }else {
                    self.showAlertMessage(title: "Alert", message: "Please enter the correct Username and Password") {
                        
                    }
                }
                
            case .failure(_):
                self.showAlertMessage(title: "Network Error", message: "Please! Try again later") {
                    
                }
            }
            
        }
        }else {
                self.showAlertMessage(title: "Alert", message: "Please enter your Password") {
                    
                }
        }
        
    }else{
            
            self.showAlertMessage(title: "Alert", message: "Please enter your Username") {
                
            }
    
    }
     
    }
    
    
    @IBAction func passwordShowAction(sender: UIButton){
        if passwordText.isSecureTextEntry {
            self.passwordText.isSecureTextEntry = false
            self.secutrityHide.setBackgroundImage(UIImage.init(named: "show"), for: UIControl.State.normal)
        }else{
            self.passwordText.isSecureTextEntry = true
            self.secutrityHide.setBackgroundImage(UIImage.init(named: "hidden"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func rememberMeAction(sender: UIButton){
        
        if Singleton.sharedInstance.getRememberMeStatus() == true {
            
            Singleton.sharedInstance.setRememberMeStatus(status: false)
            //self.rememberMe.setImage(, forState: .normal)
            self.rememberMe.setBackgroundImage(UIImage(named: "square"), for: .normal)
            
        }else{
            Singleton.sharedInstance.setRememberMeStatus(status: true)
            self.rememberMe.setBackgroundImage(UIImage(named: "squareTick"), for: .normal)
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

    @objc override func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scroll.contentInset = contentInset
    }
    
    @IBAction func forgetPasswordAction(sender: AnyObject){
        //toForgetPassword
        DispatchQueue.main.async(execute: {
            
            self.performSegue(withIdentifier: "toForgetPassword", sender: self)
            
        })
    }
    
    
    
    func adjustConstraints() {
        if TechnicianConstants.IS_IPHONE_5 {
            self.topLogoConstraint.constant = 115
            self.viewHeight.constant = 235
            self.safeBottom.constant = 55
            self.toptext.constant = 30
            self.signTop.constant = 5
            self.baseView.layoutIfNeeded()
            self.baseView.updateConstraints()
        }else if TechnicianConstants.IS_IPHONE_6 {
            self.topLogoConstraint.constant = 132
            self.viewHeight.constant = 300
            self.safeBottom.constant = 50
            self.baseView.layoutIfNeeded()
            self.baseView.updateConstraints()
        }else if TechnicianConstants.IS_IPHONE_6P {
            self.topLogoConstraint.constant = 160
            self.viewHeight.constant = 340
            self.signTop.constant = 80
            self.safeBottom.constant = 109
            self.baseView.layoutIfNeeded()
            self.baseView.updateConstraints()
        }else if TechnicianConstants.IS_IPHONE_X {
            
            self.topLogoConstraint.constant = 190
            self.viewHeight.constant = 320
            self.signTop.constant = 60
            self.safeBottom.constant = 109
            self.baseView.layoutIfNeeded()
            self.baseView.updateConstraints()
            
        }else if TechnicianConstants.IS_IPHONE_Xs {
            
            self.topLogoConstraint.constant = 230
            self.viewHeight.constant = 350
            self.signTop.constant = 90
            self.safeBottom.constant = 109
            self.baseView.layoutIfNeeded()
            self.baseView.updateConstraints()
            
        }else{
            
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

