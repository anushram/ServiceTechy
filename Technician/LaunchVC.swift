//
//  LaunchVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 28/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import ObjectMapper
import SlideMenuControllerSwift

class LaunchVC: BaseVC {
    
    @IBOutlet weak var rotateImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.rotateView(targetView: rotateImage)
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.timerAction(sender:)), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction(sender: AnyObject){
        
        if Singleton.sharedInstance.getRememberMeStatus()! == true{
            
            let credetials = Singleton.sharedInstance.getUserNamePassword()
            
            
            let param = ["request":["email":credetials["email"],"password":credetials["password"]]]
            
            let header = ["Content-Type":"application/json"]
            self.showActivityIndicator()
            NetworkManager.sharedInstance.postLogin(url: "/login", parameter: param, header: header) { (response) in
                self.hideActivityIndicator()
                switch response.result {
                case .success(_):
                    print(response.result.value!)
                    if let responseValue = response.result.value as? NSDictionary {
                        
                        print(responseValue)
                        if let responseDict = responseValue["response"] as? NSDictionary {
                            if responseDict["code"] as! String == "OK" {
                                
                                //Singleton.sharedInstance.setRememberMeStatus(status: false)
                                
                                if let techInfo = Mapper<TechDetails>().map(JSON: responseDict["data"] as! [String: Any]){
                                    
                                    print(techInfo.token)
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
                                DispatchQueue.main.async(execute: {
                                self.performSegue(withIdentifier: "loginscreen", sender: self)
                                })
                                
                            }
                        }
                        
                    }else {
                        DispatchQueue.main.async(execute: {
                        self.performSegue(withIdentifier: "loginscreen", sender: self)
                        })
                    }
                    
                case .failure(_):
                    DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "loginscreen", sender: self)
                    })
                }
                
            }
            
            
        }else{
            DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "loginscreen", sender: self)
            })
            
        }
        
        
        
    }
    
    private func rotateView(targetView: UIView, duration: Double = 1.0) {
        
        
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotation.fromValue = 0
        rotation.toValue = Double.pi
        rotation.duration = 2.0 // or however long you want ...
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        targetView.layer.add(rotation, forKey: "rotationAnimation")
        var transform: CATransform3D = CATransform3DIdentity
        transform.m34 = 1.0 / 500.0
        targetView.layer.transform = transform
        
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
