//
//  MainViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 11/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import CVCalendar
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate {
 
    var DotDate = [String]()
    var duplicate = [String]()
    var TableData:Array< String > = Array < String >()
    var date:Array< String > = Array < String >()
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var apptableView: UITableView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    let alertForOffline = UIAlertController()
    var event : Event!
    
    var month = String()
    var year = String()
    
    var shouldShowDaysOut = true
    var animationFinished = true
    var ABC = String()

    var maildate = String()
    var time = String()
    var discription = String()
    
    var descriptionArr = [String]()
    var timingArr = [String]()
    var selectionArr = [String]()
    var eventData = [Event]()
    var valueID = Int()
    var selDate = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadLoginView()
        
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        view.addSubview(activityindicator)
        self.activityindicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        
        let date = Foundation.Date()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let selecteddate = formater.string(from: date)
        selDate = selecteddate
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd MMM, yyyy"
        let final = dateFormatter2.string(from: date)
        print("date: \(final)")
        
        dateFormatter2.dateFormat = "MM"
        month = dateFormatter2.string(from: date)
        formater.dateFormat = "yyyy"
        year = formater.string(from: date)

        //self.loadOffline(year: year, month: month)
        
        UserDefaults.standard.setValue(final, forKey: "selecteddate2")
        UserDefaults.standard.setValue(selecteddate, forKey: "selecteddate")
        UserDefaults.standard.synchronize()
        Reach().monitorReachabilityChanges()
        
        let status = Reach().connectionStatus()

        switch status {

        case .unknown, .offline:
            
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
       //     self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            })
            )
            UserDefaults.standard.set(false, forKey: "isConnected");
            self.selDate = selecteddate
            self.loadOffline(query: "tdate='\(self.selDate)'")
           
        case .online(.wwan):
            print("Connected via WWAN")
            UserDefaults.standard.set(true, forKey: "isConnected");
        case .online(.wiFi):
            print("Connected via WiFi")
            UserDefaults.standard.set(true, forKey: "isConnected");
        }

       
        
//        let postString = "ok=listEvent&date=\(selecteddate)"
//        print(postString)
//
//        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
//            
//            DispatchQueue.main.async {
//                
//                print("After Queue Response : \(response)")
//                
//            let json = JSON(data: response.data!)
//            
//            for i in 0 ..< json["all_data"].count{
//                
//                let description = json["all_data"][i]["description"].stringValue
//                let timing = json["all_data"][i]["timing"].stringValue
//                
//                let event = Event(eventID: "", followUp: "", followUpType: "", descriptionDetail: description, tithiDate: "", timing: timing, tithi: "", toDate: "", toTime: "",updateStamp: "", isSync: "", liveDBId: "", operationAction: "")
//
//                print("Description : \(description) & Timing : \(timing)")
//
//                
//                self.selectionArr.append(event.timing + "   " + event.descriptionDetail)
//                
//                self.descriptionArr.append(event.descriptionDetail)
//                self.timingArr.append(event.timing)
//                
//                self.descriptionArr.sort()
//                self.timingArr.sort()
//                self.selectionArr.sort()
//                }
//            }
//            self.refreshTableData()
//
//        }

        print(CVDate(date: Foundation.Date(), calendar: NSCalendar.current).globalDescription)
        
        let lblDate = CVDate(date: Foundation.Date(),calendar: NSCalendar.current).globalDescription
        let newString = lblDate.replacingOccurrences(of: " ,", with: ", ", options: NSString.CompareOptions.literal, range: nil)
        monthLabel.text = newString
        
    }
    override func viewWillAppear(_ animated: Bool) {
        

    }
    
    
    func loadOffline(year : String, month : String){
        
        print(month)
        print(year)
        
        eventData = []
        TableData = []
        self.date = []
        duplicate = []
        var added = [Event]()
        var tithis = [Tithi]()
        
        //     print("\(eventData.count) && \(TableData.count) && \(self.date.count)")
        tithis = DBManager.shared.loadSelectTithiByQuery(query: "SELECT * FROM Tithi_table WHERE strftime('%m', tdate)  = '\(month)' AND strftime('%Y', tdate)  = '\(year)' ")
        
        for i in 0 ..< tithis.count {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let tithi = "\(tithis[i].pmonth!) \(tithis[i].tithi!) \(tithis[i].vaar!)"
            print(tithi)
            
            added = DBManager.shared.loadEventsWithParam(queryString: "tdate='\(tithis[i].date!)'")
            
            if added.count > 0 {
                
                for j in 0 ..< added.count{
                    print("\(added[j].descriptionDetail!)")
                    print("\(added[j].eventID)")
                    print(added[j].toDate)
                    let strdotday = added[j].toDate
                    let arrDate = strdotday?.components(separatedBy: "-")
                    let DotDay = arrDate?.last
                    let DotMonth = arrDate?[1]
                    let totalDate = DotDay! + "-" + DotMonth!
                    
                    if !(DotDate.contains(totalDate)) {
                        DotDate.append(totalDate)
                    }
                    
                    print(DotDate)
                }
            }
        }
        print(DotDate)
        
        viewDidLayoutSubviews()
        
        //============================================================//
        self.calendarView.calendarAppearanceDelegate = self
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
    }
    
    
    
    
    func loadOffline(query : String){
        descriptionArr = []
        timingArr = []
        selectionArr = []
        eventData = []
        
        eventData = DBManager.shared.loadEventsWithParam(queryString: query)
        for i in 0 ..< eventData.count{
            print(eventData[i].descriptionDetail)
            self.selectionArr.append(eventData[i].timing + "   " + eventData[i].descriptionDetail)
            
            self.descriptionArr.append(eventData[i].descriptionDetail)
            self.timingArr.append(eventData[i].timing)
        }
        self.refreshTableData()
    }
    func networkStatusChanged(_ notification: Notification) {
        let userInfo = notification.userInfo
        print(userInfo!)
    }
    func reloadViewDataCall()
    {
        
        view.addSubview(activityindicator)
        self.activityindicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let date = Foundation.Date()
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        
        var selecteddate = formater.string(from: date)
        if calclick.checkclick == 1
        {
            selecteddate = formater.string(from: date)
        }
        else{
            if calclick.clickbtn == 1
            {
                calclick.clickbtn = 0
                calclick.checkclick = 0
                let pref = UserDefaults.standard
                selecteddate = pref.string(forKey: "selecteddate")!
            }
            else{
                selecteddate = formater.string(from: date)
            }
        }
        let postString = "ok=listEvent&date=\(selecteddate)"
        
        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                let json = JSON(data: response.data!)
                
                for i in 0 ..< json["all_data"].count{
                    
                    let description = json["all_data"][i]["description"].stringValue
                    let timing = json["all_data"][i]["timing"].stringValue
                    
                    self.selectionArr.append(timing + "   " + description)
                    
                    self.descriptionArr.append(description)
                    self.timingArr.append(timing)
                    
                    self.descriptionArr.sort()
                    self.timingArr.sort()
                    self.selectionArr.sort()
                    let event = Event(eventID: "", followUp: "", followUpType: "", descriptionDetail: description, tithiDate: "", timing: timing, tithi: "", toDate: "", toTime: "",updateStamp: "", isSync: "", liveDBId: "", operationAction: "")
                    self.eventData.append(event)
                    print(self.eventData[i].descriptionDetail)
                    print("Description : \(description) & Timing : \(timing)")
                    
                }
            }
            self.refreshTableData()
        }
    }
    @IBAction func addEventClick()
    {
        self.performSegue(withIdentifier: "addEvent", sender: self)
    }
    func loadLoginView (){
        
        let isuserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if(!isuserLoggedIn){
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        let isTithiStored = UserDefaults.standard.bool(forKey: "isTithiStored")
        if(!isTithiStored){
            self.performSegue(withIdentifier: "firstSync", sender: self)
            print("call")
        }
        else {
            let isSync = UserDefaults.standard.bool(forKey: "isSync")
            if(isSync){
                //Get Month and Year for set Dot
                var dated = Foundation.Date()
                let formaterrrr = DateFormatter()
                formaterrrr.dateFormat = "MM"
                month = formaterrrr.string(from: dated)
                formaterrrr.dateFormat = "yyyy"
                year = formaterrrr.string(from: dated)
                self.loadOffline(year: year, month: month)
                for _ in 0 ..< 36 {
                    dated = Calendar.current.date(byAdding: .month, value: 1, to: dated)!
                    formaterrrr.dateFormat = "MM"
                    month = formaterrrr.string(from: dated)
                    formaterrrr.dateFormat = "yyyy"
                    year = formaterrrr.string(from: dated)
                    self.loadOffline(year: year, month: month)
                }
            }
        }
        let appear = UserDefaults.standard.value(forKey: "selecteddate") as! String
        
        if (!appear.isEmpty){
            print(appear)
            self.loadOffline(query: "tdate='\(appear)'")
        }else{
            self.loadOffline(query: "tdate='\(self.selDate)'")
        }
        

        
//        let status = Reach().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
//            
//        case .online(.wwan):
//            print("Connected via WWAN")
//        case .online(.wiFi):
//            print("Connected via WiFi")
//        }
    //  self.reloadViewDataCall()
    }
    override func viewDidDisappear(_ animated: Bool) {

        descriptionArr = []
        timingArr = []
        selectionArr = []
        
        
    }
    func clearPrefrences(){
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "selecteddate2")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.synchronize()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return descriptionArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = descriptionArr[indexPath.row]
        
            cell.detailTextLabel?.text = timingArr[indexPath.row]
        
        return cell
    }
    func handleDeleteOffline(_ alertView: UIAlertAction!)
    {
        let alert = UIAlertController(title: "Are you sure?", message:
            "Are you sure that you want to delete this event?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: self.handleCancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive,handler: self.Delete))
        
        self.present(alert, animated: true, completion: nil)
        print("Deleted !!")
    }
    func Delete(_ alertView: UIAlertAction!){
        DBManager.shared.deleteEvents(withID: valueID)
        self.loadOffline(query: "tDate='\(self.selDate)'")
        let selected =  UserDefaults.standard.value(forKey: "selecteddate") as! String
        if selected != self.selDate {
            self.loadOffline(query: "tDate='\(selected)'")
        }else{
            self.loadOffline(query: "tDate='\(self.selDate)'")
        }

     
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        clearPrefrences()
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
            valueID = Int(eventData[indexPath.row].eventID)!
            UserDefaults.standard.setValue(valueID, forKey: "id")
            UserDefaults.standard.setValue(eventData[indexPath.row].descriptionDetail, forKey: "description1")
            UserDefaults.standard.setValue(eventData[indexPath.row].followUpType, forKey: "Type")
            UserDefaults.standard.setValue(eventData[indexPath.row].toTime ,forKey: "totiming")
            UserDefaults.standard.setValue(eventData[indexPath.row].timing,forKey: "timing")
            UserDefaults.standard.setValue(eventData[indexPath.row].liveDBId,forKey: "liveDB")


        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let formatedDate2 = dateFormatter2.date(from: eventData[indexPath.row].tithiDate!)
        dateFormatter2.dateFormat = "dd MMM, yyyy"
        let starting = dateFormatter2.string(from:formatedDate2!)
        print("date: \(starting)")
        
        UserDefaults.standard.setValue(starting,forKey: "selecteddate2")
        UserDefaults.standard.synchronize()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedDate = dateFormatter.date(from: eventData[indexPath.row].tithiDate!)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateGetStart = dateFormatter.string(from: formatedDate!)
        
            let alert = UIAlertController(title: "\(descriptionArr[indexPath.row])", message: "\(dateGetStart) \(timingArr[indexPath.row])", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("Done !!")
                self.performSegue(withIdentifier: "addEvent", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDeleteOffline))
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
            self.present(alert, animated: true, completion: {
                
                print("completion block")
            })
        //    return
 /*       }
        else{
        view.addSubview(activityindicator)
        self.activityindicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let title = "\(selectionArr[indexPath.row])"
        let spldate = title.characters.split(separator: " ").map(String.init)
        
        let postString = "ok=listEvent"
        let serviceURL = URL(string: Connection.open.Service)
        let request = NSMutableURLRequest(url:serviceURL!)
        
        request.httpMethod="POST"
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
        
            if error != nil
            {
                print("error=\(error)")
                return
            }
            var err: NSError?
        
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        
            }catch let error as NSError {
        
                print("json error: \(error.localizedDescription)")
                json = nil
        
            }catch {
        
                fatalError()
            }
            if let parseJSON: AnyObject = json as AnyObject?{
        
                let resultValue:NSArray = parseJSON["all_data"] as! NSArray;
                print("result; \(resultValue)")
        
                if err == nil {
                    for i in 0 ..< resultValue.count {
        
                        if  let obj = resultValue[i] as? NSDictionary {
        
                            if let Type = obj["Appo_Follow_Up_Type"] as? String {
        
                                if let description = obj["description"] as? String {
        
                                    if let id = obj["id"] as? String {
        
                                        if let tdate = obj["tdate"] as? String {
        
                                            if let timing1 = obj["timing"] as? String {
        
                                                let time = timing1 + "   " + description
                                                print("\(title) & \(tdate)")
                                                if title == time {
                                                    self.maildate = tdate

                                                    UserDefaults.standard.setValue(description, forKey: "description1")
                                                    UserDefaults.standard.setValue(id, forKey: "id")
                                                    UserDefaults.standard.setValue(Type, forKey: "Type")
        
                                                    let spldate1 = timing1.characters.split(separator: "-").map(String.init)
                                                    if spldate1.count == 2 {
                                                        UserDefaults.standard.setValue(spldate1[1], forKey: "totiming")
                                                    }
        
                                                    UserDefaults.standard.setValue(spldate1[0], forKey: "timing")
                                                    let newDate1 = tdate
                                                    let spldate = newDate1.characters.split(separator: "-").map(String.init)
        
                                                    let selecteddate = spldate[2] + "-" + spldate[1] + "-" + spldate[0]
        
        
                                                    let monthnum = spldate[1]
                                                    print(selecteddate)
        
                                                    if monthnum == "01"{
                                                        self.ABC = "Jan"
                                                    }
                                                    else if monthnum == "02" {
                                                        self.ABC = "Feb"
                                                    }
                                                    else if monthnum == "03" {
                                                        self.ABC = "Mar"
                                                    }
                                                    else if monthnum == "04" {
                                                        self.ABC = "Apr"
                                                    }
                                                    else if monthnum == "05" {
                                                        self.ABC = "May"
                                                    }
                                                    else if monthnum == "06" {
                                                        self.ABC = "Jun"
                                                    }
                                                    else if monthnum == "07" {
                                                        self.ABC = "Jul"
                                                    }
                                                    else if monthnum == "08" {
                                                        self.ABC = "Aug"
                                                    }
                                                    else if monthnum == "09" {
                                                        self.ABC = "Sep"
                                                    }
                                                    else if monthnum == "10" {
                                                        self.ABC = "Oct"
                                                    }
                                                    else if monthnum == "11" {
                                                        self.ABC = "Nav"
                                                    }
                                                    else if monthnum == "12" {
                                                        self.ABC = "Dec"
                                                    }
        
                                                    let selecteddate1 = spldate[0] + " \(self.ABC)" + " " + spldate[2]
                                                    print(selecteddate1)
                                                    UserDefaults.standard.setValue(selecteddate, forKey: "selecteddate")
                                                    UserDefaults.standard.setValue(selecteddate1, forKey: "selecteddate1")
                                                    UserDefaults.standard.synchronize()
        
                                                    let alert = UIAlertController(title: "\(tdate)", message: "\(time)", preferredStyle: UIAlertControllerStyle.alert)
        
                                                    alert.addAction(UIAlertAction(title: "Invite", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                                                        print("Invite !!")
        
                                                        let actionSheet = UIActionSheet(title: "Choose your option for invitation", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS" )
                                                        actionSheet.show(in: self.view)
                                                    }))
        
                                                    alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                                                        print("Done !!")
                                                        self.performSegue(withIdentifier: "addEvent", sender: self)
                                                    }))
        
                                                    alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDelete))
                                                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
                                                    self.present(alert, animated: true, completion: {
                                                        
                                                        print("completion block")
                                                        self.activityindicator.stopAnimating()
                                                        self.view.isUserInteractionEnabled = true
                                                    })
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        task.resume()
        }*/
    }
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        print("\(buttonIndex)")
        
        switch (buttonIndex){
        case 0:
            print("Send Email")
            calclick.invite_click = 1
            self.performSegue(withIdentifier: "invite", sender: self)
        case 1:
            print("Cancel")
        case 2:
            print("Send SMS")
            calclick.invite_click = 0
            self.performSegue(withIdentifier: "invite", sender: self)
        default:
            print("Default")
        }
    }
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancelled !!")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "tithi")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "month")
        UserDefaults.standard.removeObject(forKey: "year")
        UserDefaults.standard.removeObject(forKey: "description1")
    }
    func handleDelete(_ alertView: UIAlertAction!)
    {
        let alert = UIAlertController(title: "Are you sure?", message:
            "Are you sure that you want to delete this event?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: self.handleCancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive,handler: self.FinalhandleDelete))
        
        self.present(alert, animated: true, completion: nil)
        print("Deleted !!")
    }
    func FinalhandleDelete(_ alertView: UIAlertAction!)
    {
        view.addSubview(activityindicator)
        self.activityindicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
        
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
        //    self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
            
        case .online(.wwan):
            print("Connected via WWAN")
        case .online(.wiFi):
            print("Connected via WiFi")
        }
        
        let pref = UserDefaults.standard
        let id = pref.string(forKey: "id")
        let postString = "ok=delRec&id=\(id!)"
        
        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                
                let json = JSON(data: response.data!)
                let status = json["status"].stringValue
                
                if status == "Success" {
                    self.viewDidAppear(true)
                    self.refreshTableData();
                }
                self.refreshTableData()
            }
        }
    }
    func callMethod()
    {
        let status = Reach().connectionStatus()
        
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
       //     self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
            
        case .online(.wwan):
            print("Connected via WWAN")
        case .online(.wiFi):
            print("Connected via WiFi")
        }
        calclick.clickbtn = 1
        
        if calclick.checkclick == 1 {
            calclick.checkclick = 0
        }
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "Addview", sender: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
}
extension MainViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    //.................... selected date.................................................................
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {

        print("\(calendarView.presentedDate.commonDescription) is selected!")
        print("Clicked date \(dayView.date.commonDescription)")
        
        
        
        view.addSubview(activityindicator)
        self.activityindicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        let selecteddate = dayView.date.commonDescription
        print(selecteddate)
            
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "dd MMM, yyyy"
            let date2 = dateFormatter2.date(from:selecteddate)
            print("date: \(date2!)")
        let dateString = dateFormatter2.string(from:date2!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateS = dateFormatter.string(from: date2!)
        print(dateS)
        
//        let date = dateFormatter.date(from: date2!)
//        print(date)
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let selecteddate1 = dateFormatter.string(from: date2!)
        dateFormatter.dateFormat = "yyyy"
        
        let strDate = dateFormatter.string(from: date2!)
        UserDefaults.standard.setValue(strDate, forKey: "year")
        dateFormatter.dateFormat = "MM"
        
        let strDate1 = dateFormatter.string(from: date2!)
        UserDefaults.standard.setValue(strDate1, forKey: "month")
        dateFormatter.dateFormat = "dd"
        
        let strDate2 = dateFormatter.string(from: date2!)
        UserDefaults.standard.setValue(strDate2, forKey: "day")
        print(selecteddate1)
        
        UserDefaults.standard.setValue(dateString, forKey: "selecteddate2")
        UserDefaults.standard.setValue(dateS, forKey: "selecteddate")
        UserDefaults.standard.synchronize()
        UserDefaults.standard.setValue(selecteddate1, forKey: "selecteddate1")
        UserDefaults.standard.synchronize()
        eventData.removeAll()
        selectionArr.removeAll()
        descriptionArr.removeAll()
        timingArr.removeAll()
        
//        eventData = DBManager.shared.loadEventsWithParam(queryString: "tDate='\(selecteddate1)'")
//        print(eventData)
        
        
        let status = Reach().connectionStatus()
        
        switch status {
        
        case .unknown, .offline:
        
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
        //    self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
        }))
            UserDefaults.standard.set(false, forKey: "isConnected");
        case .online(.wwan):
            print("Connected via WWAN")
            UserDefaults.standard.set(false, forKey: "isConnected");
        case .online(.wiFi):
            print("Connected via WiFi")
            UserDefaults.standard.set(false, forKey: "isConnected");
        }
        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
        if(!isConnected){
            self.loadOffline(query: "tdate='\(selecteddate1)'")
            return
        }
        let serviceURL = URL(string:Connection.open.Service)
        let request = NSMutableURLRequest(url:serviceURL!)
        
        request.httpMethod="POST";
        let postString = "ok=listEvent&date=\(selecteddate1)";
        
            Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
                
                DispatchQueue.main.async {
                    
                    print("After Queue Response : \(response)")
                    
                    let json = JSON(data: response.data!)
                    
                    for i in 0 ..< json["all_data"].count{
                        
                        let description = json["all_data"][i]["description"].stringValue
                        let timing = json["all_data"][i]["timing"].stringValue
                        
                        self.selectionArr.append(timing + "   " + description)
                        
                        self.descriptionArr.append(description)
                        self.timingArr.append(timing)
                        
                        self.descriptionArr.sort()
                        self.timingArr.sort()
                        self.selectionArr.sort()
                        let event = Event(eventID: "", followUp: "", followUpType: "", descriptionDetail: description, tithiDate: "", timing: timing, tithi: "", toDate: "", toTime: "",updateStamp: "", isSync: "", liveDBId: "", operationAction: "")
                        self.eventData.append(event)
                        
                        print(self.eventData[i].descriptionDetail)

                        print("Description : \(description) & Timing : \(timing)")
                        
                    }
                }
                self.refreshTableData()
            }
        
    }
    func refreshTableData()
    {
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.apptableView.reloadData()
            self.activityindicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        })
    }
    func presentedDateUpdated(_ date: CVDate) {

        if monthLabel.text != date.globalDescription && self.animationFinished {
            
            let updatedMonthLabel = UILabel()
            
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
              
                let newString = updatedMonthLabel.text!.replacingOccurrences(of: " ,", with: ", ", options: NSString.CompareOptions.literal, range: nil)
                
                self.monthLabel.text = newString
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        var date = String(dayView.date.day)
        var month = String(dayView.date.month)
        if date.characters.count == 1 {
            date = "0" + date
        }
        if month.characters.count == 1 {
            month = "0" + month
        }
        let strDatedo = date + "-" + month
        print(DotDate)
        if DotDate.count == 0 {
            return false
        }
        else {
            print(DotDate)
            print(strDatedo)
            if DotDate.contains(strDatedo) {
                return true
            }
        }
        return false
    }

    

    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date
        print(day ?? 0)
        //let randomDay = Int(arc4random_uniform(31))
        //if day == randomDay {
        //   return true
        //}
        print(eventData)
        if eventData.count == 0 {
            return false
        }
        else {
           // print(DotDate)
           // print(day)
           // if DotDate.contains(day) {
           //     return true
           // }
        }
        
        return false
    }
    
    
}
extension MainViewController{
   
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.circle)
        circleView.fillColor = UIColor.clear
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        let π = M_PI
        
        let ringSpacing: CGFloat = 3.0
        let ringInsetWidth: CGFloat = 1.0
        let ringVerticalOffset: CGFloat = 1.0
        var ringLayer: CAShapeLayer!
        let ringLineWidth: CGFloat = 4.0
        //let ringLineColour: UIColor = .blueColor()
        
        let newView = UIView(frame: dayView.bounds)
        
        let diameter: CGFloat = (newView.bounds.width) - ringSpacing
        let radius: CGFloat = diameter / 2.0
        
        let rect = CGRect(x: newView.frame.midX-radius, y: newView.frame.midY-radius-ringVerticalOffset, width: diameter, height: diameter)
        
        ringLayer = CAShapeLayer()
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        // ringLayer.strokeColor = ringLineColour.CGColor
        
        let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
        let ringRect: CGRect = rect.insetBy(dx: ringLineWidthInset, dy: ringLineWidthInset)
        let centrePoint: CGPoint = CGPoint(x: ringRect.midX, y: ringRect.midY)
        let startAngle: CGFloat = CGFloat(-π/2.0)
        let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
        let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (Int(arc4random_uniform(3)) == 1) {
            return true
        }
        
        return false
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension MainViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension MainViewController {
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(_ sender: AnyObject) {
        calendarView.changeMode(.weekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(_ sender: AnyObject) {
        calendarView.changeMode(.monthView)
    }
    
    @IBAction func loadPrevious(_ sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(_ sender: AnyObject) {
        calendarView.loadNextView()
    }
}

// MARK: - Convenience API Demo

extension MainViewController {
    func toggleMonthViewWithMonthOffset(_ offset: Int) {
        let calendar = Calendar.current
        _ = calendarView.manager
        var components = Manager.componentsForDate(Foundation.Date(),calendar: NSCalendar.current) // from today
        
        components.month = components.month! + offset
        
        let resultDate = calendar.date(from: components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
}
//extension CVCalendarView {
//    func didSelectDayView(dayView: CVCalendarDayView) {
//        if let controller = contentController {
//            presentedDate = dayView.date
//            
//            controller.performedDayViewSelection(dayView) // TODO: Update to range selection
//        }
//    }
//}
//



/*
 
 
 
 
 
 
 */

