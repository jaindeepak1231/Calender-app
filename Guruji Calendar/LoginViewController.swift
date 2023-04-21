//
//  LoginViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 11/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var  emailTxt = UITextField()
    @IBOutlet weak var  passwordTxt = UITextField()
    @IBOutlet weak var  activityindicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    let paddingEmailView = UIView(frame:CGRect(x: 0,y: 0, width:10,height: 10))
    
        emailTxt?.leftView = paddingEmailView
        emailTxt?.leftViewMode = UITextFieldViewMode.always
        
    let paddingPasswordView = UIView(frame:CGRect(x: 0,y: 0, width:10,height: 10))
        
        passwordTxt?.leftView = paddingPasswordView
        passwordTxt?.leftViewMode = UITextFieldViewMode.always
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        
        Reach().monitorReachabilityChanges()
    }
    func networkStatusChanged(_ notification: Notification) {
     
        let userInfo = notification.userInfo
        print("\(userInfo)")
    }
    @IBAction func loginClicked () {

//        let status = Reach().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            
//        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
//     //   self.present(alert, animated: true, completion: nil)
//            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
//        }))
//            case .online(.wwan):
//                print("Connected via WWAN")
//                self.ServiceCall()
//            case .online(.wiFi):
//                print("Connected via WiFi")
//                self.ServiceCall()
//            }
        let userEmail = emailTxt?.text
        let userPassword = passwordTxt?.text
        var user = [User]()
        user = DBManager.shared.loadUser(username: userEmail!, password: userPassword!)
        if user.count > 0 {
            print("Username \(user[0].userName) & Password \(user[0].password)")
            self.dismiss(animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
        }
    }
    func ServiceCall(){
        
        view.addSubview(activityindicator)
        self.activityindicator.startAnimating()
        self.view.isUserInteractionEnabled = false

        let userEmail = emailTxt?.text
        let userPassword = passwordTxt?.text

        if (userPassword!.isEmpty && userEmail!.isEmpty)
        {
            let alert = UIAlertController(title: "Hello User", message: "Please enter Email ID and Password", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK!!", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            self.activityindicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            return
        }
        let postString = "ok=login&dEmail=\(userEmail!)&dPass=\(userPassword!)"
        
        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                let json = JSON(data: response.data!)
                let status = json["status"].stringValue
                
                if status == "Invalid Email And Password"
                {
                    let alert = UIAlertController(title: "Alert", message: "Invalid Email And Password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        
                        switch action.style{
                        case .default:
                            print("default")
                            self.activityindicator.stopAnimating()
                            self.view.isUserInteractionEnabled = true
                        case .cancel:
                            print("cancel")
                        case .destructive:
                            print("destructive")
                        }
                    }))
                }
                else
                {
                    let uname:String = json["uname"].stringValue
                    
                    UserDefaults.standard.setValue(uname, forKey: "uname")
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true, completion: nil);
                }
                if(status == "Success")
                {
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn");
                    UserDefaults.standard.synchronize();
                    
                    self.dismiss(animated: true, completion: nil);
                    self.activityindicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTxt?.resignFirstResponder()
        passwordTxt?.resignFirstResponder()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
