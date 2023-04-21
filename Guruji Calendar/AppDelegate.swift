//
//  AppDelegate.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 11/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Contacts

let app_Delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isData = false

    var contactStore = CNContactStore()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
         let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        print(documentsDirectory)
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn");
        
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "tithi")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "desc")
        UserDefaults.standard.removeObject(forKey: "selecteddate")
        UserDefaults.standard.removeObject(forKey: "Type1")
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.removeObject(forKey: "04:00AM")
        UserDefaults.standard.removeObject(forKey: "04:15AM")
        UserDefaults.standard.removeObject(forKey: "04:30AM")
        UserDefaults.standard.removeObject(forKey: "04:45AM")
        UserDefaults.standard.removeObject(forKey: "05:00AM")
        UserDefaults.standard.removeObject(forKey: "05:15AM")
        UserDefaults.standard.removeObject(forKey: "05:30AM")
        UserDefaults.standard.removeObject(forKey: "05:45AM")
        UserDefaults.standard.removeObject(forKey: "06:00AM")
        UserDefaults.standard.removeObject(forKey: "06:15AM")
        UserDefaults.standard.removeObject(forKey: "06:30AM")
        UserDefaults.standard.removeObject(forKey: "06:45AM")
        UserDefaults.standard.removeObject(forKey: "07:00AM")
        UserDefaults.standard.removeObject(forKey: "07:15AM")
        UserDefaults.standard.removeObject(forKey: "07:30AM")
        UserDefaults.standard.removeObject(forKey: "07:45AM")
        UserDefaults.standard.removeObject(forKey: "08:00AM")
        UserDefaults.standard.removeObject(forKey: "08:15AM")
        UserDefaults.standard.removeObject(forKey: "08:30AM")
        UserDefaults.standard.removeObject(forKey: "08:45AM")
        UserDefaults.standard.removeObject(forKey: "09:00AM")
        UserDefaults.standard.removeObject(forKey: "09:15AM")
        UserDefaults.standard.removeObject(forKey: "09:30AM")
        UserDefaults.standard.removeObject(forKey: "09:45AM")
        UserDefaults.standard.removeObject(forKey: "10:00AM")
        UserDefaults.standard.removeObject(forKey: "10:15AM")
        UserDefaults.standard.removeObject(forKey: "10:30AM")
        UserDefaults.standard.removeObject(forKey: "10:45AM")
        UserDefaults.standard.removeObject(forKey: "11:00AM")
        UserDefaults.standard.removeObject(forKey: "11:15AM")
        UserDefaults.standard.removeObject(forKey: "11:30AM")
        UserDefaults.standard.removeObject(forKey: "11:45AM")
        UserDefaults.standard.removeObject(forKey: "12:00PM")
        UserDefaults.standard.removeObject(forKey: "12:15PM")
        UserDefaults.standard.removeObject(forKey: "12:30PM")
        UserDefaults.standard.removeObject(forKey: "12:45PM")
        UserDefaults.standard.removeObject(forKey: "01:00PM")
        UserDefaults.standard.removeObject(forKey: "01:15PM")
        UserDefaults.standard.removeObject(forKey: "01:30PM")
        UserDefaults.standard.removeObject(forKey: "01:45PM")
        UserDefaults.standard.removeObject(forKey: "02:00PM")
        UserDefaults.standard.removeObject(forKey: "02:15PM")
        UserDefaults.standard.removeObject(forKey: "02:30PM")
        UserDefaults.standard.removeObject(forKey: "02:45PM")
        UserDefaults.standard.removeObject(forKey: "03:00PM")
        UserDefaults.standard.removeObject(forKey: "03:15PM")
        UserDefaults.standard.removeObject(forKey: "03:30PM")
        UserDefaults.standard.removeObject(forKey: "03:45PM")
        UserDefaults.standard.removeObject(forKey: "04:00PM")
        UserDefaults.standard.removeObject(forKey: "04:15PM")
        UserDefaults.standard.removeObject(forKey: "04:30PM")
        UserDefaults.standard.removeObject(forKey: "04:45PM")
        UserDefaults.standard.removeObject(forKey: "05:00PM")
        UserDefaults.standard.removeObject(forKey: "05:15PM")
        UserDefaults.standard.removeObject(forKey: "05:30PM")
        UserDefaults.standard.removeObject(forKey: "05:45PM")
        UserDefaults.standard.removeObject(forKey: "06:00PM")
        UserDefaults.standard.removeObject(forKey: "06:15PM")
        UserDefaults.standard.removeObject(forKey: "06:30PM")
        UserDefaults.standard.removeObject(forKey: "06:45PM")
        UserDefaults.standard.removeObject(forKey: "07:00PM")
        UserDefaults.standard.removeObject(forKey: "07:15PM")
        UserDefaults.standard.removeObject(forKey: "07:30PM")
        UserDefaults.standard.removeObject(forKey: "07:45PM")
        UserDefaults.standard.removeObject(forKey: "08:00PM")
        UserDefaults.standard.removeObject(forKey: "08:15PM")
        UserDefaults.standard.removeObject(forKey: "08:30PM")
        UserDefaults.standard.removeObject(forKey: "08:45PM")
        UserDefaults.standard.removeObject(forKey: "09:00PM")
        UserDefaults.standard.removeObject(forKey: "09:15PM")
        UserDefaults.standard.removeObject(forKey: "09:30PM")
        UserDefaults.standard.removeObject(forKey: "09:45PM")
        UserDefaults.standard.removeObject(forKey: "10:00PM")
        UserDefaults.standard.removeObject(forKey: "10:15PM")
        UserDefaults.standard.removeObject(forKey: "10:30PM")
        UserDefaults.standard.removeObject(forKey: "10:45PM")
        UserDefaults.standard.removeObject(forKey: "11:00PM")
        UserDefaults.standard.removeObject(forKey: "11:15PM")
        UserDefaults.standard.removeObject(forKey: "11:30PM")
        UserDefaults.standard.removeObject(forKey: "11:45PM")
        UserDefaults.standard.removeObject(forKey: "12:00AM")
        UserDefaults.standard.removeObject(forKey: "12:15AM")
        UserDefaults.standard.removeObject(forKey: "12:30AM")
        UserDefaults.standard.removeObject(forKey: "12:45AM")
        UserDefaults.standard.removeObject(forKey: "01:00AM")
        UserDefaults.standard.removeObject(forKey: "01:15AM")
        UserDefaults.standard.removeObject(forKey: "01:30AM")
        UserDefaults.standard.removeObject(forKey: "01:45AM")
        UserDefaults.standard.removeObject(forKey: "02:00AM")
        UserDefaults.standard.removeObject(forKey: "02:15AM")
        UserDefaults.standard.removeObject(forKey: "02:30AM")
        UserDefaults.standard.removeObject(forKey: "02:45AM")
        UserDefaults.standard.removeObject(forKey: "03:00AM")
        UserDefaults.standard.removeObject(forKey: "03:15AM")
        UserDefaults.standard.removeObject(forKey: "03:30AM")
        UserDefaults.standard.removeObject(forKey: "03:45AM")
        
        
        let date = Foundation.Date()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy"
        
        let strDate = formater.string(from: date)
        UserDefaults.standard.setValue(strDate, forKey: "year")
        formater.dateFormat = "MM"
        
        let strDate1 = formater.string(from: date)
        UserDefaults.standard.setValue(strDate1, forKey: "month")
        formater.dateFormat = "dd"
        
        let strDate2 = formater.string(from: date)
        UserDefaults.standard.setValue(strDate2, forKey: "day")
        formater.dateFormat = "yyyy-MM-dd"
        
        let selecteddate = formater.string(from: date)
        print(selecteddate)
        formater.dateFormat = "dd MMM yyyy"
        
        let selecteddate1 = formater.string(from: date)
        UserDefaults.standard.setValue(selecteddate1, forKey: "selecteddate1")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.setValue(selecteddate, forKey: "selecteddate")
        UserDefaults.standard.synchronize()
        
        if(UIApplication.instancesRespond(to: #selector(UIApplication.registerUserNotificationSettings(_:)))) {
            
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            
            if let options = launchOptions {
                
                if let notification = options[UIApplicationLaunchOptionsKey.localNotification] as? UILocalNotification {
                    if let userInfo = notification.userInfo {
            
                        let customField1 = userInfo["CustomField1"] as! String
                        // do something neat here
                    }
                }
            }
        }

        return true
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
        
        if DBManager.shared.createDatabase() {
            DBManager.shared.createTithiTable()
            DBManager.shared.createUserTable()
            DBManager.shared.createTodoListTable()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func showMessage(_ message: String) {
        let alertController = UIAlertController(title: "Birthdays", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
        }
        
        alertController.addAction(dismissAction)
        
        let pushedViewControllers = (self.window?.rootViewController as! UINavigationController).viewControllers
        let presentedViewController = pushedViewControllers[pushedViewControllers.count - 1]
        
        presentedViewController.present(alertController, animated: true, completion: nil)
    }
    
    
    func requestForAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        if #available(iOS 9.0, *) {
            let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            switch authorizationStatus {
            case .authorized:
                completionHandler(true)
                
            case .denied, .notDetermined:
                self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                    if access {
                        completionHandler(access)
                    }
                    else {
                        if authorizationStatus == CNAuthorizationStatus.denied {
                            DispatchQueue.main.async(execute: { () -> Void in
                                let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                                self.showMessage(message)
                            })
                        }
                    }
                })
                
            default:
                completionHandler(false)
            }
            
        }
        else {
            // Fallback on earlier versions
        }
        
    }
    
    
    func currentDateString() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormat.string(from: NSDate() as Date)
        return strDate
    }
}


extension NSDate {
    func isBetweeen(date date1: NSDate, andDate date2: NSDate) -> Bool {
        return date1.compare(self as Date) == self.compare(date2 as Date)
    }
}
extension Date {
        
        func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
            return date1.timeIntervalSince1970 < self.timeIntervalSince1970 && date2.timeIntervalSince1970 > self.timeIntervalSince1970
        }
        
    }
