//
//  AppDelegate.swift
//  Technician
//
//  Created by K Saravana Kumar on 14/08/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import GooglePlaces
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GMSPlacesClient.provideAPIKey("AIzaSyBL-ANZwdOKOmoUq6notEI-_WLL1D7QU9g")
        GMSServices.provideAPIKey("AIzaSyBL-ANZwdOKOmoUq6notEI-_WLL1D7QU9g")
//        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//        application.registerUserNotificationSettings(settings)
//        application.registerForRemoteNotifications()
//        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
//        let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
//        application.registerUserNotificationSettings(pushNotificationSettings)
//        application.registerForRemoteNotifications()
//
//        UNUserNotificationCenter.current().delegate = self
//
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        center.delegate = self
        
        
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
                                                title: "Accept",
                                                options: [.foreground])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
                                                 title: "Decline",
                                                 options: [.foreground])
        // Define the notification type
        let technicianCategory =
            UNNotificationCategory(identifier: "TECH_INVITATION",
                                   actions: [acceptAction, declineAction],
                                   intentIdentifiers: [],
                                   hiddenPreviewsBodyPlaceholder: "",
                                   options: .customDismissAction)
        
        //let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("Abrir", comment: ""), options: UNNotificationActionOptions.foreground)
        
        //let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories(Set([technicianCategory]))
        
        UIApplication.shared.registerForRemoteNotifications()
        
        //Accept Decline
        

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification(_:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        return true
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                Singleton.sharedInstance.setFirebaseToken(token: result.token)
                //print("avvv=",InstanceID.instanceID().token()!)
                //ClassConstants.sharedInstance.setFIRDeviceToken(deviceToken: result.token)
            }
        }
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        completionHandler([.alert, .badge, .sound])
    }
    
    //MARK: Notification Delegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        
        let userInfo = response.notification.request.content.userInfo
//        let meetingID = userInfo["MEETING_ID"] as! String
//        let userID = userInfo["USER_ID"] as! String
        print("bgtr=",userInfo["jobid"])
        //let job
        print("ssss",userInfo["aps"])
        // Perform the task associated with the action.
        print("vvvv=",response.actionIdentifier)
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            
            let jobid = userInfo["jobid"]! as! String
            let techid = userInfo["techid"]! as! String
            let param = ["request":["accepted":"1","jobid":jobid,"techid":techid]]
            
            let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
            
            NetworkManager.sharedInstance.postLogin(url: "/updateTechInvitation", parameter: param, header: header) { (response) in
                switch response.result {
                case .success(_):
                    NotificationCenter.default.post(name: Notification.Name.init(rawValue: "loadtickets"), object: nil, userInfo: userInfo)

                    print(response.result.value!)
                    
                case .failure(_): break
                    
                }
                
            }
            
        break
            
        case "DECLINE_ACTION":
            
            let jobid = userInfo["jobid"]! as! String
            let techid = userInfo["techid"]! as! String
            let param = ["request":["accepted":"0","jobid":jobid,"techid":techid]]
            
            let header = ["Content-Type":"application/json","token": Singleton.sharedInstance.getTechToken()]
            
            NetworkManager.sharedInstance.postLogin(url: "/updateTechInvitation", parameter: param, header: header) { (response) in
                switch response.result {
                case .success(_):
                    
                    print(response.result.value!)
                    
                case .failure(_): break
                    
                }
                
            }
            
            break
            
            // Handle other actions…
            
        default:
            break
        }
        
        // Always call the completion handler when done.
        completionHandler()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        _ = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        let characterSet = CharacterSet(charactersIn: "<>")
        let nsdataStr = NSData.init(data: deviceToken)
        let deviceTokenString = nsdataStr.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "")
        //print("deviceToken1=",deviceTokenString)
        Singleton.sharedInstance.setDeviceToken(token: deviceTokenString)
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                Singleton.sharedInstance.setFirebaseToken(token: result.token)
                //print("avvv=",InstanceID.instanceID().token()!)
                //ClassConstants.sharedInstance.setFIRDeviceToken(deviceToken: result.token)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    

}

