//
//  ForgetPasswordVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 27/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit

class ForgetPasswordVC: BaseVC,UITextFieldDelegate {
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var emailText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavigationBarTitleView(title: "Forget Password", image: UIImage())
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
