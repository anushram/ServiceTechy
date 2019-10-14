//
//  BaseVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 14/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class DeviceManager {
    static let sharedInstance = DeviceManager()
    
    // Method to get Device Width
    func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Method to get Device Height
    func getDeviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
}

class BaseVC: UIViewController {
    
    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    var slideMenuViewController: SlideMenuController!
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    var activityIndicator: UIActivityIndicatorView!
    var activityIndicatorView: UIView!
    
    var backgroundView: UIView!
    
    var bottomOptionsView: BottomOptionsView!
    var libraryOptionView: LibraryOptionPopUp!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    //Show Activity Indicator
    func showActivityIndicator() {
        if self.activityIndicatorView == nil {
            DispatchQueue.main.async(execute: {
                let xPos = DeviceManager.sharedInstance.getDeviceWidth()/2 - 25 //  - half of image size
                let yPos = DeviceManager.sharedInstance.getDeviceHeight()/2 - 25
                self.activityIndicatorView =
                    UIView(frame: CGRect(x: xPos, y: yPos, width: 50, height: 50))
                self.activityIndicatorView.alpha = 1
                self.activityIndicatorView.backgroundColor = UIColor.white
                let layer: CALayer = self.activityIndicatorView.layer
                layer.cornerRadius = 5.0
                
                self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
                if #available(iOS 13.0, *) {
                    self.activityIndicator.style = UIActivityIndicatorView.Style.large
                } else {
                    // Fallback on earlier versions
                    //self.activityIndicator.style = UIActivityIndicatorView.Style.large
                }
                let transform: CGAffineTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.activityIndicator.transform = transform
                self.activityIndicatorView.addSubview(self.activityIndicator)
                self.activityIndicator .startAnimating()
                self.activityIndicator.color = UIColor.blue
                self.activityIndicatorView.isHidden = true
                self.view.addSubview(self.activityIndicatorView)
                self.activityIndicatorView.isHidden = false
            })
        }
        else {
            self.activityIndicatorView.removeFromSuperview()
        }
        
    }
    
    //Hide Activity Indicator
    func hideActivityIndicator() {
        if  self.activityIndicatorView != nil {
            DispatchQueue.main.async(execute: {
                if self.activityIndicator == nil {
                    
                }
                else{
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.removeFromSuperview()
                    self.activityIndicator = nil
                    
                    self.activityIndicatorView .removeFromSuperview()
                    self.activityIndicatorView = nil
                }
            })
            
        }
    }
    
    //Method for Alert iew Controller
    func showAlertMessage(title: String, message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertController.dismiss(animated: true, completion: {
                
            })
            completion()
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Method for Alert iew Controller
    func showAlertMessageForDestruction(title: String, message: String, cancelTitle: String, destructionTitle: String, completion: @escaping () -> Void, completionDestruction: @escaping () -> Void) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (action) in
            completion()
        }
        
        let destructionAction = UIAlertAction(title: destructionTitle, style: .default) { (action) in
            
            completionDestruction()
        }
        destructionAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(cancelAction)
        alertController.addAction(destructionAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func popAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
//    func instantiateToMainScreen() {
//        self.appDelegate?.window?.rootViewController?.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.async(execute: {
//            let instantiateViewController = self.mainStoryBoard.instantiateInitialViewController()
//            self.appDelegate?.window?.rootViewController = instantiateViewController
//        })
//    }
    
    
    func addDoneButtonOnKeyboard(textView: UITextView)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace,done]
        //        items.addObject(flexSpace)
        //        items.addObject(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
        
        
    }
    
    func addDoneButtonOnKeyboard(textField: UITextField)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace,done]
        //        items.addObject(flexSpace)
        //        items.addObject(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
        
        
    }
    
    @objc func doneButtonAction(){
        
    }
    
    
    func addDoneButtonOnPicker(textView: UITextField, LeftText: String, tag: Int)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.valueChangedAction(sender:)))
        done.tag  = tag
        let startTime : UIBarButtonItem = UIBarButtonItem(title: LeftText, style: .plain, target: self, action: nil)
        
        let items = [startTime,flexSpace,done]
        //        items.addObject(flexSpace)
        //        items.addObject(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textView.inputAccessoryView = doneToolbar
        
        
    }
    
    @IBAction func valueChangedAction(sender: UIBarButtonItem){
        
    }
    
    
    @objc func keyboardWasShown(notification : NSNotification) {
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
    }
    
    @objc func textfieldDidChangeText(notification:NSNotification){
        
    }
    
    func addRightButton(image: UIImage) {
        
        let rightButton: UIBarButtonItem = UIBarButtonItem(image: image.withRenderingMode(.alwaysOriginal), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.addRightAction(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func addRightButtonText(text: String) {
        
        let rightButton: UIBarButtonItem = UIBarButtonItem.init(title: text, style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.addRightAction(sender:)))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @IBAction func addRightAction(sender: UIBarButtonItem){
        
    }
    
    func customizeNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]
        self.navigationController?.view.backgroundColor = UIColor.black
    }
    
    func addNavigationBarTitleView(title: String,image: UIImage) {
        // container viewF
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 150, height: 46)
        container.backgroundColor = UIColor.clear
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 150, height: 36)
        label.backgroundColor = UIColor.clear
        label.text =  title
        label.font = UIFont.italicSystemFont(ofSize: 18.0)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 36)
        imageView.backgroundColor = UIColor.clear
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "trellologo")
        imageView.contentMode = .scaleAspectFit
        
        container.addSubview(imageView)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
//        self.navigationController?.navigationBar.titleTextAttributes =
//            [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14.0)]
        self.navigationController?.view.backgroundColor = UIColor.black
        self.navigationItem.titleView = container
        
    }
    
    func addBackgroundView(view: UIView) {
        
        
        self.removeSubview(subview: self.backgroundView)
        
        self.backgroundView = UIView()
        self.addTapGesture(view: self.backgroundView)
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: TechnicianConstants.SCREEN_WIDTH, height: TechnicianConstants.SCREEN_HEIGHT)
        view.addSubview(self.backgroundView)
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        
    }
    
    func addTapGesture(view: UIView) {
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped))
        viewTapGesture.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(viewTapGesture)
        
    }
    
    @objc func myviewTapped(gesture: UIGestureRecognizer) {
        
        
    }
    
    func addPopupStartingAnimationSorted(view: UIView) {
        // Add popup starting animation
        //view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        view.transform = CGAffineTransform(translationX: 0, y: 600)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            view.transform = CGAffineTransform.identity
        }, completion: {(finished: Bool) -> Void in
        })
    }
    
    func bottomPopupView(view: UIView) -> BottomOptionsView {
        addBackgroundView(view: view)
        
        let sortView = showBottomView(view: view)
        view.addSubview(sortView)
        addPopupStartingAnimationSorted(view: sortView)
        
        return sortView
    }
    
    func libraryOptionPopUp(view: UIView) -> LibraryOptionPopUp {
        
        addBackgroundView(view: view)
        
        let sortView = showLibraryOptionPopUp(view: view)
        view.addSubview(sortView)
        addPopupStartingAnimationSorted(view: sortView)
        
        return sortView
        
    }
    
    func showLibraryOptionPopUp(view: UIView) -> LibraryOptionPopUp {
        if self.libraryOptionView == nil {
            self.libraryOptionView = LibraryOptionPopUp.instanceFromNib()
            self.libraryOptionView.frame = CGRect(x: 0, y: view.frame.height - libraryOptionView.frame.size.height, width:
                self.view.frame.width, height: libraryOptionView.frame.size.height)
            return self.libraryOptionView
        }
        else {
            self.libraryOptionView .removeFromSuperview()
            self.libraryOptionView = nil
            self.libraryOptionView = LibraryOptionPopUp.instanceFromNib()
            self.libraryOptionView.frame = CGRect(x: 0, y: view.frame.height - libraryOptionView.frame.size.height, width:
                self.view.frame.width, height: libraryOptionView.frame.size.height)
            return self.libraryOptionView
        }
        
    }
    
    func showBottomView(view: UIView) -> BottomOptionsView {
        if self.bottomOptionsView == nil {
            self.bottomOptionsView = BottomOptionsView.instanceFromNib()
            self.bottomOptionsView.frame = CGRect(x: 0, y: view.frame.height - bottomOptionsView.frame.size.height, width:
                self.view.frame.width, height: bottomOptionsView.frame.size.height)
            return self.bottomOptionsView
        }
        else {
            self.bottomOptionsView .removeFromSuperview()
            self.bottomOptionsView = nil
            self.bottomOptionsView = BottomOptionsView.instanceFromNib()
            self.bottomOptionsView.frame = CGRect(x: 0, y: view.frame.height - bottomOptionsView.frame.size.height, width:
                self.view.frame.width, height: bottomOptionsView.frame.size.height)
            return self.bottomOptionsView
        }
        
    }
    
    func removeSubview(subview: UIView?) {
        if subview != nil {
            subview!.removeFromSuperview()
        }
    }
    
    @objc func closeSuccessView(sender: UIView) {
        let senderView = sender
        dismiss(senderView: senderView)
        //        dismiss(senderView!)
        
    }
    
    func dismiss(senderView: UIView) {
        if senderView.superview != nil {
            addPopupClosingAnimation(viewToDismiss: senderView)
        }
    }
    
    func addPopupClosingAnimation(viewToDismiss: UIView) {
        viewToDismiss.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            viewToDismiss.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: {(finished: Bool) -> Void in
            viewToDismiss.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        })
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
