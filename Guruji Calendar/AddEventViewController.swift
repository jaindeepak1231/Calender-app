
//  AddEventViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 11/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI
import Alamofire
import SwiftyJSON

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
 
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}
class AddEventViewController: UIViewController,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate {

    var picker = UIPickerView()
    var datePicker: UIDatePicker!
    var pickerData  = NSArray()
    var selectedtype = String()
    var selectedtiming = String()
    var min_num = Int()
    var type: NSMutableArray =  NSMutableArray()
    var timing: NSMutableArray =  NSMutableArray()
    var remindertiming: NSMutableArray =  NSMutableArray()
    var actionView: UIView = UIView()
    var window: UIWindow? = nil
    var abc : String = String()
    var hours = Int()
    var number = Int()
    var Maildata:Array< String > = Array < String >()
    var postString = String()
    var maildiscription = String()
    var bool : Bool!
    var strScreenFrom = ""
    var strselectedDate = ""
    
    @IBOutlet weak var fromTimingTxt: UITextField!
    @IBOutlet weak var dateTxt: UITextField!
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var toTimingTxt: UITextField!
    @IBOutlet weak var eventTypeTxt: UITextField!
    @IBOutlet weak var repeatDateTxt: UITextField!
    @IBOutlet weak var reminderTimeDuration: UITextField!
    @IBOutlet weak var notesTxtView: UITextView!
    @IBOutlet weak var repeatSwtc: UISwitch!
    @IBOutlet weak var reminderSwtc: UISwitch!
    @IBOutlet weak var saveBtn : UIButton!
    @IBOutlet weak var cancelBtn : UIButton!
    @IBOutlet weak var invitesBtn : UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        dateTxt.text = ""
        fromTimingTxt.text = ""
        repeatDateTxt.text = ""
        reminderTimeDuration.text = ""
        toTimingTxt.text = ""
        eventTypeTxt.text = ""
        
        textFieldAndButtonConfigure()
        
        calclick.Mailarray.removeAllObjects()
        calclick.Data.removeAllObjects()
        calclick.Emailarray.removeAllObjects()
        calclick.SMSarray.removeAllObjects()
        
        self.notesTxtView.keyboardType = UIKeyboardType.default
        NotificationCenter.default.addObserver(self, selector: #selector(AddEventViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        reminderTimeDuration.isHidden = true
     //   dateTxt.isHidden = true
        
        super.viewDidLoad()
        
        let delegate = UIApplication.shared
        var myWindow: UIWindow? = delegate.keyWindow
        let myWindow2: NSArray = delegate.windows as NSArray
        
        if let myWindow: UIWindow = UIApplication.shared.keyWindow {
            window = myWindow
        }
        else {
            window = myWindow2[0] as? UIWindow
        }
        let delegate1 = UIApplication.shared
        var myWindow3: UIWindow? = delegate1.keyWindow
        let myWindow4: NSArray = delegate1.windows as NSArray
        
        if let myWindow3: UIWindow = UIApplication.shared.keyWindow {
            window = myWindow3
        }
        else
        {
            window = myWindow4[0] as? UIWindow
        }
        picker.backgroundColor = UIColor.yellow
        repeatDateTxt.isHidden = true
        actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 260.0)
        
        type = ["Critical Appointment","VIP Appointment","Regular Appointment","Sick Leave","Funeral","Vacation","Follow up"]
        
        timing = ["12:00 AM","12:15 AM","12:30 AM","12:45 AM","01:00 AM","01:15 AM","01:30 AM","01:45 AM","02:00 AM","02:15 AM","02:30 AM","02:45 AM","03:00 AM","03:15 AM","03:30 AM","03:45 AM","04:00 AM","04:15 AM","04:30 AM","04:45 AM","05:00 AM","05:15 AM","05:30 AM","05:45 AM","06:00 AM","06:15 AM","06:30 AM","06:45 AM","07:00 AM","07:15 AM","07:30 AM","07:45 AM","08:00 AM","08:15 AM","08:30 AM","08:45 AM","09:00 AM","09:15 AM","09:30 AM","09:45 AM","10:00 AM","10:15 AM","10:30 AM","10:45 AM","11:00 AM","11:15 AM","11:30 AM","11:45 AM","12:00 PM","12:15 PM","12:30 PM","12:45 PM","01:00 PM","01:15 PM","01:30 PM","01:45 PM","02:00 PM","02:15 PM","02:30 PM","02:45 PM","03:00 PM","03:15 PM","03:30 PM","03:45 PM","04:00 PM","04:15 PM","04:30 PM","04:45 PM","05:00 PM","05:15 PM","05:30 PM","05:45 PM","06:00 PM","06:15 PM","06:30 PM","06:45 PM","07:00 PM","07:15 PM","07:30 PM","07:45 PM","08:00 PM","08:15 PM","08:30 PM","08:45 PM","09:00 PM","09:15 PM","09:30 PM","09:45 PM","10:00 PM","10:15 PM","10:30 PM","10:45 PM","11:00 PM","11:15 PM","11:30 PM","11:45 PM"]
        remindertiming = ["15:00 Min","30:00 Min","45:00 Min","01:00 Hour","02:00 Hours",]
        
        loadDataOnView()
        
    }
    override func viewDidDisappear(_ animated: Bool) {
//        dateTxt.text = ""
//        fromTimingTxt.text = ""
//        repeatDateTxt.text = ""
//        reminderTimeDuration.text = ""
//        toTimingTxt.text = ""
//        eventTypeTxt.text = ""
        
        
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "id")

        
    }
    func textFieldAndButtonConfigure(){
        
        fromTimingTxt.setBottomBorder()
        repeatDateTxt.setBottomBorder()
        reminderTimeDuration.setBottomBorder()
        dateTxt.setBottomBorder()
        toTimingTxt.setBottomBorder()
        eventTypeTxt.setBottomBorder()
    //    notesTxtView.setBottomBorder()
        notesTxtView.layer.borderWidth = 1.0
        notesTxtView.layer.borderColor = UIColor(red:0.00, green:0.75, blue:0.87, alpha:1.0).cgColor
        saveBtn.layer.cornerRadius = saveBtn.frame.size.height / 2
        saveBtn.clipsToBounds = true
        
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.height / 2
        cancelBtn.clipsToBounds = true
        
        invitesBtn.layer.cornerRadius = invitesBtn.frame.size.height / 2
        invitesBtn.clipsToBounds = true
        
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.dateTxt.frame.height))
        dateTxt.leftView = paddingView
        dateTxt.leftViewMode = UITextFieldViewMode.always
        
        let paddingView4 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.repeatDateTxt.frame.height))
        repeatDateTxt.leftView = paddingView4
        repeatDateTxt.leftViewMode = UITextFieldViewMode.always
        
        let paddingView1 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.fromTimingTxt.frame.height))
        fromTimingTxt.leftView = paddingView1
        fromTimingTxt.leftViewMode = UITextFieldViewMode.always
        
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.toTimingTxt.frame.height))
        toTimingTxt.leftView = paddingView3
        toTimingTxt.leftViewMode = UITextFieldViewMode.always
        
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.eventTypeTxt.frame.height))
        eventTypeTxt.leftView = paddingView2
        eventTypeTxt.leftViewMode = UITextFieldViewMode.always
        
        
        let paddingView5 = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.reminderTimeDuration.frame.height))
        reminderTimeDuration.leftView = paddingView5
        reminderTimeDuration.leftViewMode = UITextFieldViewMode.always
        
        eventTypeTxt.attributedPlaceholder = NSAttributedString(string:"Type",attributes:[NSForegroundColorAttributeName: UIColor.lightGray])
     //   notesTxtView.textContainerInset = UIEdgeInsetsMake(15, 15,15, 0)
        self.notesTxtView.delegate = self
        
        if notesTxtView.text.isEmpty {
            notesTxtView.text = "Note text here..."
            notesTxtView.textColor = UIColor.lightGray
        }
        
    }
    @IBAction func saveBtnClicked (_ sender: AnyObject) {
        
        print(calclick.Mailarray)
        view.addSubview(activityIndicator)
        
        self.activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let status = Reach().connectionStatus()
        
        switch status {
        case .unknown, .offline:
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
//            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                
            }))
            UserDefaults.standard.set(true, forKey: "isConnected");
        case .online(.wwan):
            print("Connected via WWAN")
            UserDefaults.standard.set(true, forKey: "isConnected");
        case .online(.wiFi):
            print("Connected via WiFi")
            UserDefaults.standard.set(true, forKey: "isConnected");
        }
        let notes = notesTxtView.text
        let pref = UserDefaults.standard
        let date = pref.string(forKey: "selecteddate")
        var todate = pref.string(forKey: "repeatdate")
        let timing = pref.string(forKey: "timing")
        let totiming = pref.string(forKey: "totiming")
        let id = pref.string(forKey: "id")
        
        let type = pref.string(forKey: "type")
        let Type = pref.string(forKey: "Type")
        
        if type != nil
        {
            if type == "Critical Appointment"
            {
                abc = "C"
            }
            else if type == "VIP Appointment"
            {
                abc = "V"
            }
            else if type == "Regular Appointment"
            {
                abc = "R"
            }
            else if type == "Sick Leave"
            {
                abc = "S"
            }
            else if type == "Funeral"
            {
                abc = "Fu"
            }
            else if type == "Vacation"
            {
                abc = "Va"
            }
            else if type == "Follow up"
            {
                abc = "F"
            }
        }
        else
        {
            if Type == "C"
            {
                abc = "C"
            }
            else if Type == "V"
            {
                abc = "V"
            }
            else if Type == "R"
            {
                abc = "R"
            }
            else if Type == "S"
            {
                abc = "S"
            }
            else if Type == "Fu"
            {
                abc = "Fu"
            }
            else if Type == "Va"
            {
                abc = "V"
            }
            else if Type == "F"
            {
                abc = "F"
            }
        }
        
        if totiming == nil || notes == "Notes"
        {
            let alert = UIAlertController(title: "Error", message: "You must have fill all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
        else
        {
            if repeatSwtc.isOn{
                if id == nil
                {
                    if (!(repeatDateTxt.text?.isEmpty)!) {
                        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
                        if(isConnected){
                            
                        let dateForStart = DateFormatter()
                        dateForStart.dateFormat = "dd MMM, yyyy"
                        let starting = dateForStart.date(from:dateTxt.text!)
                        print("date: \(starting!)")
                        
                        
                        let finalStart = DateFormatter()
                        finalStart.dateFormat = "yyyy-MM-dd"
                        
                        let startDate = finalStart.string(from: starting!)
                        print(startDate)
                        
                        
                        let dateForEnd = DateFormatter()
                        dateForEnd.dateFormat = "dd MMM yyyy"
                        let ending = dateForEnd.date(from:repeatDateTxt.text!)
                        print("date: \(ending!)")
                        
                        
                        let finalEnd = DateFormatter()
                        finalEnd.dateFormat = "yyyy-MM-dd"
                        
                        let endDate = finalStart.string(from: ending!)
                        print(endDate)
                        
                        
                        let startDates: Date = finalStart.date(from: startDate)!
                        let endDates: Date = finalEnd.date(from: endDate)!
                        
                        let formatter = DateComponentsFormatter()
                        formatter.unitsStyle = .full
                        formatter.allowedUnits = [.day]
                        formatter.maximumUnitCount = 2
                        
                        
                        let days = formatter.string(from: startDates, to: endDates)
                        print(days!)
                        
                        let replaced = (days! as String).replacingOccurrences(of: " days", with: "")
                        print(replaced)
                        var total = NSInteger()
                        total = Int(replaced)!
                        
                        for i in 0 ..< total + 1 {
                            
                            let tomorrow = Calendar.current.date(byAdding: .day, value: i, to: startDates)
                            
                            let finalEnd = DateFormatter()
                            finalEnd.dateFormat = "yyyy-MM-dd"
                            
                            let endDate = finalStart.string(from: tomorrow!)
                            print(endDate)
                            
                            postString = "ok=addDesc&Appo_Follow_Up_Type=\(abc)&desc=\(notes!)&db_date=\(endDate)&timing=\(timing!)&totime=\(totiming!)&todate=\(todate!)";
                            print(postString)
                            
                            Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
                                
                                DispatchQueue.main.async {
                                    
                                    print("After Queue Response : \(response)")
                                }
                            }
                        }
                        
                    }
                    }
                }
                else
                {
                    postString = "ok=addDesc&Appo_Follow_Up_Type=\(abc)&desc=\(notes!)&db_date=\(date!)&timing=\(timing!)&id=\(id!)&totime=\(totiming!)&todate=\(todate!)";
                    print(postString)
                }
            }
            else
            {
                repeatDateTxt.text = ""
                todate = date
                if id == nil
                {
                    postString = "ok=addDesc&Appo_Follow_Up_Type=\(abc)&desc=\(notes!)&db_date=\(date!)&timing=\(timing!)&totime=\(totiming!)&todate=\(todate!)";
                    print(postString)
                }
                else
                {
                    postString = "ok=addDesc&Appo_Follow_Up_Type=\(abc)&desc=\(notes!)&db_date=\(date!)&timing=\(timing!)&id=\(id!)&totime=\(totiming!)&todate=\(todate!)";
                    print(postString)
                }
              
            }
        }
           /* event = Event(eventID: "1", followUp: "sfdsf", followUpType: "ssdas", descriptionDetail: "Not Update", tithiDate: "sfsfdsfds", timing: "sfsdfdsds", tithi: "SFSDFDSFSD", toDate: "sdfsdfsd", toTime: "sdfsdfsd")

            DBManager.shared.updateEvent(withID: 1, data: event) */
        
        
        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
        if(isConnected){
            todate = date
            if id == nil{
            var data = [Tithi]()
            data = DBManager.shared.loadSelectTithi(withID: todate!)
            let tithi = "\(data[0].pmonth!) \(data[0].tithi!) \(data[0].vaar!)"
            print(tithi)
            
            var event : Event!
                if (toTimingTxt.text?.isEmpty)!
                {
                    let alert = UIAlertController(title: "Caution", message: "You must have fill To Timing.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                 
                }
                else {
                if (!(repeatDateTxt.text?.isEmpty)!){
                    
                    
                    let dateForStart = DateFormatter()
                    dateForStart.dateFormat = "dd MMM, yyyy"
                    let starting = dateForStart.date(from:dateTxt.text!)
                    print("date: \(starting!)")
                
                    
                    let finalStart = DateFormatter()
                    finalStart.dateFormat = "yyyy-MM-dd"
                    
                    let startDate = finalStart.string(from: starting!)
                    print(startDate)
                    
                    
                    let dateForEnd = DateFormatter()
                    dateForEnd.dateFormat = "dd MMM yyyy"
                    let ending = dateForEnd.date(from:repeatDateTxt.text!)
                    print("date: \(ending!)")
                    
                    
                    let finalEnd = DateFormatter()
                    finalEnd.dateFormat = "yyyy-MM-dd"
                    
                    let endDate = finalStart.string(from: ending!)
                    print(endDate)
                    
                    
                    let startDates: Date = finalStart.date(from: startDate)!
                    let endDates: Date = finalEnd.date(from: endDate)!
                    
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .full
                    formatter.allowedUnits = [.day]
                    formatter.maximumUnitCount = 2
                    
                    
                    let days = formatter.string(from: startDates, to: endDates)
                    print(days!)
                    
                    let replaced = (days! as String).replacingOccurrences(of: " days", with: "")
                    print(replaced)
                    var total = NSInteger()
                    total = Int(replaced)!
                    
                    for i in 0 ..< total + 1 {
                        
                        let tomorrow = Calendar.current.date(byAdding: .day, value: i, to: startDates)
                        
                        let finalEnd = DateFormatter()
                        finalEnd.dateFormat = "yyyy-MM-dd"
                        
                        let endDate = finalStart.string(from: tomorrow!)
                        print(endDate)
                        event = Event(eventID: "", followUp: "A", followUpType: abc, descriptionDetail: notes!, tithiDate: endDate, timing: timing!, tithi: tithi, toDate: todate!, toTime: totiming!,updateStamp: "", isSync: "0", liveDBId: "", operationAction: "i")
                        DBManager.shared.insertData(data: event)

                    }
//                    event = Event(eventID: "", followUp: "A", followUpType: abc, descriptionDetail: notes!, tithiDate: date!, timing: timing!, tithi: tithi, toDate: todate!, toTime: totiming!,updateStamp: "", isSync: "0", liveDBId: "", operationAction: "i")
//                    DBManager.shared.insertData(data: event)

                }
                else{
                    print(abc)
                    print(date ?? 0)
                    print(notes ?? 0)
                    print(totiming ?? 0)
                    print("\(date!) \(abc) \(notes!) \(totiming!)")
                    
                    event = Event(eventID: "", followUp: "A", followUpType: abc, descriptionDetail: notes!, tithiDate: date!, timing: timing!, tithi: tithi, toDate: todate!, toTime: totiming!,updateStamp: "", isSync: "0", liveDBId: "", operationAction: "i")
                    DBManager.shared.insertData(data: event)
                    
                }
            
            }
            }
            else {
                var data = [Tithi]()
                data = DBManager.shared.loadSelectTithi(withID: todate!)
                let tithi = "\(data[0].pmonth!) \(data[0].tithi!) \(data[0].vaar!)"
                print(tithi)
                var event : Event!
                let live_db = UserDefaults.standard.string(forKey: "liveDB")

                event = Event(eventID: id, followUp: "A", followUpType: abc, descriptionDetail: notes!, tithiDate: date!, timing: timing!, tithi: tithi, toDate: todate!, toTime: totiming!,updateStamp: "", isSync: "0", liveDBId: live_db, operationAction: "u")
                DBManager.shared.updateEvent(withID: Int(id!)!, data: event)
                print("Print ID \(live_db)")
            }
            _ = navigationController?.popViewController(animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        else{
            todate = date
            if id == nil{
                var data = [Tithi]()
                data = DBManager.shared.loadSelectTithi(withID: todate!)
                let tithi = "\(data[0].pmonth!) \(data[0].tithi!) \(data[0].vaar!)"
                print(tithi)
                
                var event : Event!
                event = Event(eventID: "", followUp: "A", followUpType: abc, descriptionDetail: notes!, tithiDate: date!, timing: timing!, tithi: tithi, toDate: todate!, toTime: totiming!,updateStamp: "", isSync: "0", liveDBId: "", operationAction: "i")
                DBManager.shared.insertData(data: event)
            }
            else {
                var data = [Tithi]()
                data = DBManager.shared.loadSelectTithi(withID: todate!)
                let tithi = "\(data[0].pmonth!) \(data[0].tithi!) \(data[0].vaar!)"
                print(tithi)
                let live_db = UserDefaults.standard.value(forKey: "liveDB")
                var event : Event!
                event = Event(eventID: id, followUp: "A", followUpType: abc, descriptionDetail: notes!, tithiDate: date!, timing: timing!, tithi: tithi, toDate: todate!, toTime: totiming!,updateStamp: "", isSync: "0", liveDBId: live_db as! String!, operationAction: "u")
                DBManager.shared.updateEvent(withID: Int(id!)!, data: event)
                
            }
        if(isConnected){
            if (!(repeatDateTxt.text?.isEmpty)!) {
        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                let json = JSON(data: response.data!)
                let status = json["status"].stringValue
                if status == "Success" {

                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AddEventViewController.sendemail), userInfo: nil, repeats: false)
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AddEventViewController.sendSMS), userInfo: nil, repeats: false)
                    self.navigationController?.popToRootViewController(animated:
                    true)
                    
                        }
                    }
                }
            }
            }
        }
        if reminderSwtc.isOn
        {
            let remindtime = pref.string(forKey: "remindertiming")
            if remindtime == "15:00 Min"
            {
                min_num = 15
            }
            else if remindtime == "30:00 Min"
            {
                min_num = 30
            }
            else if remindtime == "45:00 Min"
            {
                min_num = 45
            }
            else if remindtime == "01:00 Hour"
            {
                min_num = 60
            }
            else if remindtime == "02:00 Hours"
            {
                min_num = 120
            }
            let formatter = DateFormatter()
            let time_date = "\(date!) \(timing!)"
            print(time_date)
            
            let localeStr = "us" // this will succeed
            formatter.locale = Locale(identifier: localeStr)
            formatter.dateFormat = "yyyy-MM-dd hh:mm a"
            
            let da1 = formatter.date(from: time_date)
            print(da1)
            
            let calendar = Calendar.current
            let date1 = (calendar as NSCalendar).date(byAdding: .minute, value: -(min_num), to: da1!, options: [])
            print(date1)
            
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let da2 = formatter.string(from: date1!)
            print(da2)
            
            let settings = UIApplication.shared.currentUserNotificationSettings
            
            if settings!.types == UIUserNotificationType() {
                
                let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
                return
            }
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let da = formatter.date(from: da2)
            print(da!)
            
            let notification = UILocalNotification()
            notification.fireDate = Foundation.Date(timeInterval: 1, since: da!)
            notification.alertBody = notesTxtView.text
            notification.alertAction = "Show Events"
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.userInfo = ["CustomField1": "w00t"]
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    func sendSMS()
    {
        let pref = UserDefaults.standard
        let notes = notesTxtView.text
        let date = pref.string(forKey: "selecteddate")
        let timing = pref.string(forKey: "timing")
        let totiming = pref.string(forKey: "totiming")
        let time = "\(timing!)-\(totiming!)"
        
        let addressString = calclick.Data.map{String(describing: $0)}.joined(separator: ",")
        print(addressString)
        
        let postStringSMS = "ok=sendsms&sms=\(addressString)&date=\(date!)&events=\(notes!)&timing=\(time)"
        
        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postStringSMS, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                let json = JSON(data: response.data!)
                let status = json["status"].stringValue
                
                if status == "Success" {
                    print("SMS send Sucsessfully..")
                    calclick.SMSarray.removeAllObjects()
                    calclick.Data.removeAllObjects()
                    calclick.Mailarray.removeAllObjects()
                    
                }
            }
        }
    }
    func sendemail()
    {
        let pref = UserDefaults.standard
        let notes = notesTxtView.text
        let date = pref.string(forKey: "selecteddate")
        let timing = pref.string(forKey: "timing")
        let totiming = pref.string(forKey: "totiming")
        let time = "\(timing!)-\(totiming!)"
        
        let stringRepresentation = calclick.Emailarray.map{String(describing: $0)}.joined(separator: ",")
        print(stringRepresentation)
        
        let postStringEmail = "ok=sendemails&emails=\(stringRepresentation)&date=\(date!)&events=\(notes!)&timing=\(time)"
        print(postStringEmail)
        
        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postStringEmail, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                let json = JSON(data: response.data!)
                let status = json["status"].stringValue
                
                if status == "Success" {
                    
                    print("Email send Sucsessfully..")
                    calclick.Emailarray.removeAllObjects()
                    calclick.Mailarray.removeAllObjects()
                }
            }
        }
    }
    @IBAction func cancelBtnClicked(_ sender: AnyObject) {
        
        calclick.Mailarray.removeAllObjects()
        calclick.Data.removeAllObjects()
        calclick.Emailarray.removeAllObjects()
        calclick.SMSarray.removeAllObjects()
        
       _ = navigationController?.popViewController(animated: true)
        //self.navigationController?.popViewController(animated: true)
        

        
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "selecteddate2")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "liveDB")
    }
    func networkStatusChanged(_ notification: Notification) {
        let userInfo = notification.userInfo
        print(userInfo)
    }
    func loadDataOnView()
    {
        
        
        var current = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        var starting = dateFormatter.string(from:current)
        print("date: \(starting)")

        let pref = UserDefaults.standard
        let date = pref.string(forKey: "selecteddate2")
        let id = pref.string(forKey: "id")
        
        
        if strScreenFrom == "DoubleTap" {
            print(strselectedDate)
            dateTxt.text = strselectedDate
            dateFormatter.dateFormat = "dd-MM-yyyy"
            current = dateFormatter.date(from: strselectedDate)!
            dateFormatter.dateFormat = "yyyy-MM-dd"
            starting = dateFormatter.string(from: current)
            print(starting)
            UserDefaults.standard.setValue(starting, forKey: "selecteddate")
            UserDefaults.standard.synchronize()
            
        }
        else {
            if date != nil && date != starting {
                dateTxt.text = date
            }
            else {
                dateTxt.text = starting
            }
            
            if id != nil {
                dateTxt.text = date
            }
        }
        
        
        let test = pref.string(forKey: "selecteddate1")
        print("\(date) && \(test)")
        
        
        
        let selectedtiming = pref.string(forKey: "timing")
        print(selectedtiming)
        
        if selectedtiming == nil
        {
            self.currenttime()
            let pref = UserDefaults.standard
            let selectedtiming = pref.string(forKey: "timing")
            fromTimingTxt.text = selectedtiming
        }
        else
        {
            fromTimingTxt.text = selectedtiming
        }
        let totiming = pref.string(forKey: "totiming")
        toTimingTxt.text = totiming
        
        let Appo_Follow_Up_Type = pref.string(forKey: "Type")
        
        if Appo_Follow_Up_Type != nil
        {
            if Appo_Follow_Up_Type == "C"
            {
                eventTypeTxt.text = "Critical Appointment"
            }
            else if Appo_Follow_Up_Type == "V"
            {
                eventTypeTxt.text = "VIP Appointment"
            }
            else if Appo_Follow_Up_Type == "R"
            {
                eventTypeTxt.text = "Regular Appointment"
            }
            else if Appo_Follow_Up_Type == "S"
            {
                eventTypeTxt.text = "Sick Leave"
            }
            else if Appo_Follow_Up_Type == "Fu"
            {
                eventTypeTxt.text = "Funeral"
            }
            else if Appo_Follow_Up_Type == "Va"
            {
                eventTypeTxt.text = "Vacation"
            }
            else if Appo_Follow_Up_Type == "F"
            {
                eventTypeTxt.text = "Follow up"
            }
        }
        else
        {
            eventTypeTxt.text = ""
        }
        
        let description1 = pref.string(forKey: "description1")
        print(description1)
        
        if description1 != nil
        {
            self.notesTxtView.text = description1
            notesTxtView.textColor = UIColor.black
        }
        else
        {
            self.notesTxtView.text = ""
        }
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        notesTxtView.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        cancelevent()
        dateTxt.resignFirstResponder()
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            notesTxtView.resignFirstResponder()
            cancelevent()
            return false
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        eventTypeTxt.resignFirstResponder()
        dateTxt.resignFirstResponder()
        repeatDateTxt.resignFirstResponder()
        fromTimingTxt.resignFirstResponder()
        toTimingTxt.resignFirstResponder()
        notesTxtView.resignFirstResponder()
        reminderTimeDuration.resignFirstResponder()
        cancelevent()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        cancelevent()
        // popSrollview.setContentOffset(CGPointMake(0, 100), animated: true)
        if notesTxtView.textColor == UIColor.lightGray {
            notesTxtView.text = nil
            notesTxtView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        //popSrollview.setContentOffset(CGPointMake(0, 0), animated: true)
        if notesTxtView.text.isEmpty {
            notesTxtView.text = "Notes"
            notesTxtView.textColor = UIColor.lightGray
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row] as? String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("\(pickerData[row])")
    }
    @IBAction func reminderOn(_ sender: AnyObject)
    {
        if reminderSwtc.isOn {
            reminderTimeDuration.isHidden = false
            reminderSwtc.setOn(true, animated:true)
        } else {
            reminderTimeDuration.isHidden = true
            reminderSwtc.setOn(false, animated:true)
        }
    }
    @IBAction func repeatOn(_ sender: AnyObject)
    {
        if repeatSwtc.isOn {
            repeatDateTxt.isHidden = false
        //    dateTxt.isHidden = false
            repeatSwtc.setOn(true, animated:true)
        } else {
        //    dateTxt.isHidden = true
            repeatDateTxt.isHidden = true
            repeatSwtc.setOn(false, animated:true)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fromTimingTxt
        {
            fromTimingTxt.resignFirstResponder()
            
            let kSCREEN_WIDTH  =    UIScreen.main.bounds.size.width
            self.view.endEditing(true)
            
            picker.frame = CGRect(x: 0.0, y: 44.0,width: kSCREEN_WIDTH, height: 216.0)
            picker.dataSource = self
            picker.delegate = self
            picker.showsSelectionIndicator = true;
            picker.backgroundColor = UIColor.white
            
            let pickerDateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 44))
            pickerDateToolbar.barStyle = UIBarStyle.blackOpaque
            pickerDateToolbar.barTintColor = UIColor.cyan
            pickerDateToolbar.isTranslucent = true
            
            let barItems = NSMutableArray()
            let labelCancel = UILabel()
            labelCancel.text = "    Cancel"
            
            let titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddEventViewController.cancelPickerSelectionButtonClicked(_:)))
            barItems.add(titleCancel)
            
            var flexSpace: UIBarButtonItem
            flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            flexSpace.width = 230
            barItems.add(flexSpace)
            pickerData = timing
            
            let pref = UserDefaults.standard
            let selected_timing = pref.string(forKey: "timing")
            print(selected_timing)
            
            if selected_timing != nil
            {
                if let swiftarray = timing as NSArray as? [String]
                {
                    let index = swiftarray.index(of: selected_timing!)
                    print(index)
                    picker.selectRow(index!, inComponent: 0, animated: false)
                }
            }
            else
            {
                picker.selectRow(0, inComponent: 0, animated: false)
            }
            let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEventViewController.countryDoneClicked(_:)))
            barItems.add(doneBtn)
            pickerDateToolbar.setItems([titleCancel, flexSpace, doneBtn], animated: false)
            
            actionView.addSubview(pickerDateToolbar)
            actionView.addSubview(picker)
            
            if ((window) != nil) {
                window!.addSubview(actionView)
            }
            else {
                self.view.addSubview(actionView)
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 260.0, width: UIScreen.main.bounds.size.width, height: 260.0)
            })
        }
        else if textField == toTimingTxt
        {
            toTimingTxt.resignFirstResponder()
            let kSCREEN_WIDTH  =    UIScreen.main.bounds.size.width
            self.view.endEditing(true)
            picker.frame = CGRect(x: 0.0, y: 44.0,width: kSCREEN_WIDTH, height: 216.0)
            picker.dataSource = self
            picker.delegate = self
            picker.showsSelectionIndicator = true;
            picker.backgroundColor = UIColor.white
            
            let pickerDateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 44))
            pickerDateToolbar.barStyle = UIBarStyle.blackOpaque
            pickerDateToolbar.barTintColor = UIColor.cyan
            pickerDateToolbar.isTranslucent = true
            
            let barItems = NSMutableArray()
            let labelCancel = UILabel()
            labelCancel.text = "   Cancel"
            
            let titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddEventViewController.cancelPickerSelectionButtonClicked(_:)))
            barItems.add(titleCancel)
            
            var flexSpace: UIBarButtonItem
            flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            flexSpace.width = 230
            barItems.add(flexSpace)
            pickerData = timing
            
            let pref = UserDefaults.standard
            let selected_timing = pref.string(forKey: "totiming")
            print(selected_timing)
            if selected_timing != nil
            {
                if let swiftarray = timing as NSArray as? [String]
                {
                    let index = swiftarray.index(of: selected_timing!)
                    print(index)
                    picker.selectRow(index!, inComponent: 0, animated: false)
                }
            }
            else
            {
                let selected_timing = pref.string(forKey: "timing")
                if let swiftarray = timing as NSArray as? [String]
                {
                    let index = swiftarray.index(of: selected_timing!)
                    print(index)
                    picker.selectRow(index!, inComponent: 0, animated: false)
                }
                //picker.selectRow(0, inComponent: 0, animated: false)
            }
            let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEventViewController.countryDoneClicked2(_:)))
            barItems.add(doneBtn)
            pickerDateToolbar.setItems([titleCancel, flexSpace, doneBtn], animated: false)
            actionView.addSubview(pickerDateToolbar)
            actionView.addSubview(picker)
            
            if ((window) != nil) {
                window!.addSubview(actionView)
            }
            else
            {
                self.view.addSubview(actionView)
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 260.0, width: UIScreen.main.bounds.size.width, height: 260.0)
            })
        }
        else if textField == reminderTimeDuration
        {
            reminderTimeDuration.resignFirstResponder()
            let kSCREEN_WIDTH  =    UIScreen.main.bounds.size.width
            self.view.endEditing(true)
            
            picker.frame = CGRect(x: 0.0, y: 44.0,width: kSCREEN_WIDTH, height: 216.0)
            picker.dataSource = self
            picker.delegate = self
            picker.showsSelectionIndicator = true;
            picker.backgroundColor = UIColor.white
            
            let pickerDateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 44))
            pickerDateToolbar.barStyle = UIBarStyle.blackOpaque
            pickerDateToolbar.barTintColor = UIColor.cyan
            pickerDateToolbar.isTranslucent = true
            
            let barItems = NSMutableArray()
            let labelCancel = UILabel()
            labelCancel.text = "   Cancel"
            
            let titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddEventViewController.cancelPickerSelectionButtonClicked(_:)))
            barItems.add(titleCancel)
            
            var flexSpace: UIBarButtonItem
            flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            flexSpace.width = 230
            barItems.add(flexSpace)
            
            pickerData = remindertiming
            let pref = UserDefaults.standard
            let selected_timing = pref.string(forKey: "remindertiming")
            print(selected_timing)
            
            if selected_timing != nil
            {
                if let swiftarray = remindertiming as NSArray as? [String]
                {
                    let index = swiftarray.index(of: selected_timing!)
                    print(index)
                    picker.selectRow(index!, inComponent: 0, animated: false)
                }
            }
            else
            {
                picker.selectRow(0, inComponent: 0, animated: false)
            }
            let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEventViewController.ReminderDoneClicked(_:)))
            
            barItems.add(doneBtn)
            pickerDateToolbar.setItems([titleCancel, flexSpace, doneBtn], animated: false)
            
            actionView.addSubview(pickerDateToolbar)
            actionView.addSubview(picker)
            
            if ((window) != nil) {
                window!.addSubview(actionView)
            }
            else
            {
                self.view.addSubview(actionView)
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 260.0, width: UIScreen.main.bounds.size.width, height: 260.0)
            })
        }
        else if textField == eventTypeTxt
        {
            eventTypeTxt.resignFirstResponder()
            let kSCREEN_WIDTH = UIScreen.main.bounds.size.width
            self.view.endEditing(true)
            
            picker.frame = CGRect(x: 0.0, y: 44.0,width: kSCREEN_WIDTH, height: 216.0)
            picker.dataSource = self
            picker.delegate = self
            picker.showsSelectionIndicator = true;
            picker.backgroundColor = UIColor.white
            
            let pickerDateToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 44))
            pickerDateToolbar.barStyle = UIBarStyle.blackOpaque
            pickerDateToolbar.barTintColor = UIColor.cyan
            pickerDateToolbar.isTranslucent = true
            
            let barItems = NSMutableArray()
            let labelCancel = UILabel()
            labelCancel.text = "   Cancel"
            
            let titleCancel = UIBarButtonItem(title: labelCancel.text, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddEventViewController.cancelPickerSelectionButtonClicked(_:)))
            
            barItems.add(titleCancel)
            
            var flexSpace: UIBarButtonItem
            flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: self, action: nil)
            flexSpace.width = 230
            barItems.add(flexSpace)
            
            pickerData = type
            let pref = UserDefaults.standard
            let selectedtype1 = pref.string(forKey: "Type")
            
            if selectedtype1 != nil && selectedtype1 != ""
            {
                if selectedtype1 == "C"
                {
                    selectedtype = "Critical Appointment"
                }
                else if selectedtype1 == "V"
                {
                    selectedtype = "VIP Appointment"
                }
                else if selectedtype1 == "R"
                {
                    selectedtype = "Regular Appointment"
                }
                else if selectedtype1 == "S"
                {
                    selectedtype = "Sick Leave"
                }
                else if selectedtype1 == "Fu"
                {
                    selectedtype = "Funeral"
                }
                else if selectedtype1 == "Va"
                {
                    selectedtype = "Vacation"
                }
                else if selectedtype1 == "F"
                {
                    selectedtype = "Follow up"
                }
                if let swiftArray = type as NSArray as? [String] {
                    let index = swiftArray.index(of: selectedtype)
                    print(index)
                    picker.selectRow(index!, inComponent: 0, animated: false)
                }
            }
            else
            {
                picker.selectRow(0, inComponent: 0, animated: false)
            }
            let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddEventViewController.DoneClicked(_:)))
            
            barItems.add(doneBtn)
            pickerDateToolbar.setItems([titleCancel, flexSpace, doneBtn], animated: false)
            
            actionView.addSubview(pickerDateToolbar)
            actionView.addSubview(picker)
            
            if ((window) != nil) {
                window!.addSubview(actionView)
            }
            else
            {
                self.view.addSubview(actionView)
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 260.0, width: UIScreen.main.bounds.size.width, height: 260.0)
            })
        }
        else if textField == dateTxt
        {
            
            let customView:UIView = UIView(frame: CGRect(x: 0, y: 100, width: 414, height: 200))
            customView.backgroundColor = UIColor.clear
            
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 414, height: 200))
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
            customView.addSubview(datePicker)
            
            let pref1 = UserDefaults.standard
            let selecteddate = pref1.string(forKey: "selecteddate")
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            
            let selecteddate1 = formater.date(from: selecteddate!)
            
            if selecteddate != nil
            {
                datePicker.setDate(selecteddate1!, animated: false)
            }
            
            dateTxt.inputView = customView
            
            let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44))
            doneButton.setTitle("Done", for: UIControlState())
            doneButton.addTarget(self, action: #selector(AddEventViewController.datePickerChanged), for: UIControlEvents.touchUpInside)
            doneButton.backgroundColor = UIColor.black
            dateTxt.inputAccessoryView = doneButton
            
            return true
        }
        else if textField == repeatDateTxt
        {
            let customView:UIView = UIView(frame: CGRect(x: 0, y: 100, width: 414, height: 200))
            customView.backgroundColor = UIColor.clear
            datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 414, height: 200))
            datePicker.datePickerMode = UIDatePickerMode.date
            datePicker.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
            customView.addSubview(datePicker)
            
            let pref1 = UserDefaults.standard
            let selecteddate = pref1.string(forKey: "selecteddate")
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            
            let selecteddate1 = formater.date(from: selecteddate!)
            if (!(selecteddate?.isEmpty)!) {
                datePicker.setDate(selecteddate1!, animated: false)
            }
            repeatDateTxt.inputView = customView
            
            let doneButton:UIButton = UIButton (frame: CGRect(x: 100, y: 100, width: 100, height: 44))
            doneButton.setTitle("Done", for: UIControlState())
            
            doneButton.addTarget(self, action: #selector(AddEventViewController.Repeattimingdone), for: UIControlEvents.touchUpInside)
            doneButton.backgroundColor = UIColor.black
            repeatDateTxt.inputAccessoryView = doneButton
            return true
        }
        return false
    }
    func cancelPickerSelectionButtonClicked(_ sender: UIBarButtonItem) {
        cancelevent()
    }
    func countryDoneClicked(_ sender: UIBarButtonItem) {
        
        let myRow = picker.selectedRow(inComponent: 0)
        fromTimingTxt.text = pickerData.object(at: myRow) as! NSString as String
        
        let type1 = pickerData.object(at: myRow) as! NSString as String
        UserDefaults.standard.setValue(type1, forKey: "timing")
        UserDefaults.standard.synchronize()
        eventTypeTxt.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 260.0)
        }, completion: { _ in
            for obj: AnyObject in self.actionView.subviews {
                if let view = obj as? UIView
                {
                    view.removeFromSuperview()
                }
            }
        })
    }
    func countryDoneClicked2(_ sender: UIBarButtonItem) {
        
        let myRow = picker.selectedRow(inComponent: 0)
        toTimingTxt.text = pickerData.object(at: myRow) as! NSString as String
        
        let type1 = pickerData.object(at: myRow) as! NSString as String
        UserDefaults.standard.setValue(type1, forKey: "totiming")
        UserDefaults.standard.synchronize()
        eventTypeTxt.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 260.0)
        }, completion: { _ in
            for obj: AnyObject in self.actionView.subviews {
                if let view = obj as? UIView
                {
                    view.removeFromSuperview()
                }
            }
        })
    }
    func ReminderDoneClicked(_ sender: UIBarButtonItem)
    {
        let myRow = picker.selectedRow(inComponent: 0)
        reminderTimeDuration.text = pickerData.object(at: myRow) as! NSString as String
        
        let type1 = pickerData.object(at: myRow) as! NSString as String
        print(type1)
        
        UserDefaults.standard.setValue(type1, forKey: "remindertiming")
        UserDefaults.standard.synchronize()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 260.0)
        }, completion: { _ in
            for obj: AnyObject in self.actionView.subviews {
                if let view = obj as? UIView
                {
                    view.removeFromSuperview()
                }
            }
        })
    }
    func DoneClicked(_ sender: UIBarButtonItem) {
        
        let myRow = picker.selectedRow(inComponent: 0)
        eventTypeTxt.text = pickerData.object(at: myRow) as! NSString as String
        
        let type1 = pickerData.object(at: myRow) as! NSString as String
        UserDefaults.standard.setValue(type1, forKey: "type")
        UserDefaults.standard.synchronize()
        eventTypeTxt.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 260.0)
        }, completion: { _ in
            for obj: AnyObject in self.actionView.subviews {
                if let view = obj as? UIView
                {
                    view.removeFromSuperview()
                }
            }
        })
    }
    func datePickerChanged()
    {
        var a = Foundation.Date()
        a = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let selecteddate1 = dateFormatter.string(from: a)
        UserDefaults.standard.setValue(selecteddate1, forKey: "selecteddate1")
        UserDefaults.standard.synchronize()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let selecteddate = dateFormatter.string(from: a)
        UserDefaults.standard.setValue(selecteddate, forKey: "selecteddate")
        UserDefaults.standard.synchronize()
        dateTxt.text = selecteddate1
        dateTxt.resignFirstResponder()
    }
    func Repeattimingdone()
    {
        var a = Foundation.Date()
        a = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let selecteddate1 = dateFormatter.string(from: a)
        UserDefaults.standard.setValue(selecteddate1, forKey: "repeatdate1")
        UserDefaults.standard.synchronize()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let selecteddate = dateFormatter.string(from: a)
        UserDefaults.standard.setValue(selecteddate, forKey: "repeatdate")
        UserDefaults.standard.synchronize()
        repeatDateTxt.text = selecteddate1
        repeatDateTxt.resignFirstResponder()
    }
    func cancelevent()
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.actionView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 260.0)
        }, completion: { _ in
            for obj: AnyObject in self.actionView.subviews {
                if let view = obj as? UIView
                {
                    view.removeFromSuperview()
                }
            }
        })
    }
    func currenttime()
    {
        let todaysDate:Foundation.Date = Foundation.Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let DateInFormat:String = dateFormatter.string(from: todaysDate)
        print(DateInFormat)
        
        let localeStr = "us" // this will succeed
        dateFormatter.locale = Locale(identifier: localeStr)
        dateFormatter.dateFormat = "hh:mm a"
        
        let stringFromDate = dateFormatter.string(from: todaysDate)
        print(stringFromDate)   // "Monday, August
        
        var spldate1 = stringFromDate.components(separatedBy: " ")
        let a = spldate1[0]
        var myStringArr2 = a.components(separatedBy: ":")
        let minute = Int(myStringArr2[1])
        let hour = Int(myStringArr2[0])
        
        if hour == 13
        {
            hours = 01
        }
        else if hour == 14
        {
            hours = 02
        }
        else if hour == 15
        {
            hours = 03
        }
        else if hour == 16
        {
            hours = 04
        }
        else if hour == 17
        {
            hours = 05
        }
        else if hour == 18
        {
            hours = 06
        }
        else if hour == 19
        {
            hours = 07
        }
        else if hour == 20
        {
            hours = 08
        }
        else if hour == 21
        {
            hours = 09
        }
        else if hour == 22
        {
            hours = 10
        }
        else if hour == 23
        {
            hours = 11
        }
        else if hour == 24
        {
            hours = 12
        }
        else
        {
            hours = hour!
        }
        if minute <= 15
        {
            number = 15
        }
        else if minute >= 16 && minute <= 30
        {
            number = 30
        }
        else if minute >= 31 && minute <= 45
        {
            number = 45
        }
        else if minute >= 46 && minute <= 60
        {
            number = 00
            let num1 = Int(myStringArr2[0])
            var increment_value = num1! + 1
            
            if increment_value == 13
            {
                increment_value = 1
            }
            
            hours = increment_value
            let newvalue = String(increment_value)
            myStringArr2[0] = newvalue
            
        }
        let selectedhour = String(hours)
        let myString = String(number)
        print(myString)
        
        if myString == "0"
        {
            if selectedhour == "10"
            {
                let timing = selectedhour + ":" + "00" + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
            else if selectedhour == "11"
            {
                let timing = selectedhour + ":" + "00" + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
            else if selectedhour == "12"
            {
                let timing = selectedhour + ":" + "00" + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
            else{
                let timing = "0" + selectedhour + ":" + "00" + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
        }
        else
        {
            if selectedhour == "10"
            {
                let timing = selectedhour + ":" + myString + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
            else if selectedhour == "11"
            {
                let timing = selectedhour + ":" + myString + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
            else if selectedhour == "12"
            {
                let timing = selectedhour + ":" + myString + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
            else
            {
                let timing = "0" + selectedhour + ":" + myString + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
        }
    }
    
    @IBAction func Invite_by_Email(_ sender: AnyObject)
    {
        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS" )
        actionSheet.show(in: self.view)
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print("\(buttonIndex)")
        switch (buttonIndex){
        case 0:
            print("Send Email")
            calclick.invite_click = 1
            calclick.emailflag = true
            calclick.smsflag = false
            
            self.performSegue(withIdentifier: "event_invites", sender: self)
        case 1:
            print("Cancel")
        case 2:
            print("Send SMS")
            calclick.invite_click = 0
            calclick.emailflag = false
            calclick.smsflag = true
            self.performSegue(withIdentifier: "event_invites", sender: self)
        default:
            print("Default")
        }
    }
    
    
    
}
