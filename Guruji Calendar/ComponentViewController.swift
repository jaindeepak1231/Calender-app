//
//  ComponentViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 22/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Alamofire
import SwiftyJSON
struct TodayEvents {
    
    var followUpType : String
    var description : String
    var timing : String
    var tithi : String
    
    init(followType : String, description : String, timing : String, tithi : String) {
        self.followUpType = followType
        self.description = description
        self.timing = timing
        self.tithi = tithi
    }
}
struct calclick {
    static var checkclick = 0
    static var clickbtn = 0
    static var monthincriment_click = 0
    static var year_inc_dec_click = 0
    static var day_inc_dec_click = 0
    static var Day_click = 0
    static var invite_click = 0
    static var select_number_page = 0
    static var Mailarray = NSMutableArray()
    static var SMSarray = NSMutableArray()
    static var Emailarray = NSMutableArray()
    static var Data = NSMutableArray()
    static var selectednumber = NSMutableArray()
    static var num_name_data = NSMutableArray()
    static var emailflag = true
    static var smsflag = true
}

class ComponentViewController: UIViewController,CNContactPickerDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var lblbirthday: UILabel!
    @IBOutlet weak var btntithi: UIButton!
    @IBOutlet weak var lbltithi: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblview: UILabel!
    @IBOutlet weak var apptableView: UITableView!
    @IBOutlet weak var btnbirthday: UIButton!
    @IBOutlet weak var lblpersonname: UILabel!
    @IBOutlet weak var Activityindicater: UIActivityIndicatorView!
    
    var todayEvents = [Event]()
    var TableData:Array< String > = Array < String >()
    var Timing:Array< String > = Array < String >()
    var Followuptype:Array< String > = Array < String >()
    var item = NSMutableSet()
    var exdate = Foundation.Date()
    var sel_date = String()
    var sel_date1 = String()
    var bdate = String()
    var birthday_st = String()
    var B_string:Array< String > = Array < String >()
    var index_inc = Int()
    var P_name = String()
    var currentDate:String = ""
    var contacts = [CNContact]()
    var maildata = String()
    var discription = String()
    var time = String()
    var timer = Timer()
    let MyURL = Connection.open.Service
    var counter = 0
    var valueID = Int()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        let date = Foundation.Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd"
        bdate = formater.string(from: date)
        
        
        self.todayEvents = []
        TableData.removeAll()
        Timing.removeAll()
        Followuptype.removeAll()
        B_string.removeAll()
        lblview.text = "TODAY VIEW"
        self.getbirthdayinfo()
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ComponentViewController.storearray), userInfo: nil, repeats: false)
        UINavigationBar.appearance().tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "Addicon"), for: UIControlState())
        button.addTarget(self, action:#selector(ComponentViewController.Addevent), for: UIControlEvents.touchUpInside)
        button.frame=CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton

    }
    override func viewWillAppear(_ animated: Bool) {
        segmentedControl.selectedSegmentIndex = 0
         ApiCall()
        gettithi()
    }
    @IBAction func indexChanged(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            print("Sewa For India")
            self.performSegue(withIdentifier: "dayView", sender: self)
            
        case 2:
            print("Sewa For USA")
            self.performSegue(withIdentifier: "yearView", sender: self)
            
        default:
            break;
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        calclick.monthincriment_click = 0
        calclick.year_inc_dec_click = 0
//        view.addSubview(Activityindicater)
//        self.Activityindicater.startAnimating()
//        self.view.isUserInteractionEnabled = false
      //  gettithi()
      //  ApiCall()
    }
    func storearray()
    {
        index_inc = 0
        for contact in self.contacts {
            if let birthday = contact.birthday
            {
                let formatter = CNContactFormatter()
                formatter.style = .fullName
                let a = formatter.string(from: contact)
                _ = getDateStringFromComponents(birthday)
                if self.bdate == self.birthday_st
                {
                    self.B_string.append(a!)
                }
            }
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ComponentViewController.setbday), userInfo: nil, repeats: false)
    }
    func setbday()
    {
        if B_string.count != 0
        {
            let count = String(B_string.count)
            btnbirthday.setTitle("Wish \(count) Person", for: UIControlState())
        }
        else
        {
            btnbirthday.setTitle("No Birthday Available Today", for: UIControlState())
        }
    }
    @IBAction func gotobirthdaypage(_ sender: AnyObject)
    {
        performSegue(withIdentifier: "birthday", sender: self)
    }
    func ApiCall()
    {
//        view.addSubview(Activityindicater)
//        self.Activityindicater.startAnimating()
//        self.view.isUserInteractionEnabled = false
        self.todayEvents.removeAll()
        TableData.removeAll()
        Timing.removeAll()
        Followuptype.removeAll()
        self.todayEvents = []
        if calclick.day_inc_dec_click != 1
        {
            let date = Foundation.Date()
            exdate = date
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            sel_date = formater.string(from: date)
            formater.dateFormat = "dd MMM yyyy"
            sel_date1 = formater.string(from: date)
            formater.dateFormat = "dd-MM-yyyy"
            let todaydate = formater.string(from: date)
            UserDefaults.standard.setValue(todaydate, forKey: "todaydate")
            UserDefaults.standard.synchronize()
            lbldate.text = sel_date1
            print("Date clean or not \(sel_date1) & \(sel_date)")
        }
        
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
            self.loadOffline(query: "tdate='\(sel_date)'")

//        }
//        else{
//        let postString = "ok=listEvent&date=\(sel_date)"
//        print(postString)
//        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
//            
//            DispatchQueue.main.async {
//                
//                print("After Queue Response : \(response)")
//                
//                let json = JSON(data: response.data!)
//                var event : Event!
//                for i in 0 ..< json["all_data"].count{
//                    
//                    let description = json["all_data"][i]["description"].stringValue
//                    let timing = json["all_data"][i]["timing"].stringValue
//                    let tithi = json["all_data"][i]["tithi"].stringValue
//                    let followUpType = json["all_data"][i]["Appo_Follow_Up_Type"].stringValue
//                    
//                    
//                    event = Event(eventID: "", followUp: "", followUpType: followUpType, descriptionDetail: description, tithiDate: "", timing: timing, tithi: tithi, toDate: "", toTime: "",updateStamp: "", isSync: "", liveDBId: "", operationAction: "")
//                    
//                    self.todayEvents.append(event)
//
//                    UserDefaults.standard.setValue(tithi, forKey: "tithi")
//                    UserDefaults.standard.synchronize()
//                }
//           //     print(self.todayEvents[0].description ," ", self.todayEvents[0].tithi)
//                self.refreshDataInTable()
//            }
//        }
//        }
    }
    func gettithi()
    {
        if calclick.day_inc_dec_click != 1
        {
            let date = Date()
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            sel_date = formater.string(from: date)
            formater.dateFormat = "dd MMM yyyy"
            sel_date1 = formater.string(from: date)
        }
        
        
        print(self.sel_date)
        print([Tithi]())
        
        var tithi = ""
        if !(self.sel_date == "") {
            var data = [Tithi]()
            data = DBManager.shared.loadSelectTithi(withID: self.sel_date)
            tithi = "\(data[0].pmonth!) \(data[0].tithi!) \(data[0].vaar!)"
            
        }
        
        

//        let postString = "ok=getTithi&db_date=\(sel_date)";
//        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
//            
//            DispatchQueue.main.async {
//                
//                print("After Queue Response : \(response)")
//                
//                let json = JSON(data: response.data!)
//                let tithi = json["tithi"].stringValue
                if (!tithi.isEmpty) {
                    self.lbltithi.text = "Tithi: \(tithi)"
                    UserDefaults.standard.setValue(tithi, forKey: "tithi")
                    UserDefaults.standard.synchronize()
                }
//            }
//        }
    }
    func refreshDataInTable()
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.apptableView.reloadData()
            self.Activityindicater.stopAnimating()
            self.view.isUserInteractionEnabled = true
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ListTithiCell
        
        cell?.titleLbl?.text = todayEvents[indexPath.row].descriptionDetail
        cell?.timingLbl?.text = todayEvents[indexPath.row].timing
        cell?.alphaLetter?.layer.cornerRadius = (cell?.alphaLetter?.frame.size.height)! / 2
        cell?.alphaLetter?.clipsToBounds = true
        
        if todayEvents[indexPath.row].followUpType == ""{
            cell?.alphaLetter?.text = "R"
        } else {
            cell?.alphaLetter?.text = todayEvents[indexPath.row].followUpType
        }
        return cell!
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
        self.loadOffline(query: "tdate='\(sel_date)'")
        
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clearPrefrences()
   //     let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
            valueID = Int(todayEvents[indexPath.row].eventID)!
            UserDefaults.standard.setValue(valueID, forKey: "id")
            UserDefaults.standard.setValue(todayEvents[indexPath.row].descriptionDetail, forKey: "description1")
            UserDefaults.standard.setValue(todayEvents[indexPath.row].followUpType, forKey: "Type")
            UserDefaults.standard.setValue(todayEvents[indexPath.row].toTime ,forKey: "totiming")
            UserDefaults.standard.setValue(todayEvents[indexPath.row].timing,forKey: "timing")
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let formatedDate2 = dateFormatter2.date(from: todayEvents[indexPath.row].tithiDate!)
        dateFormatter2.dateFormat = "dd MMM, yyyy"
        let starting = dateFormatter2.string(from:formatedDate2!)
        print("date: \(starting)")
        
        UserDefaults.standard.setValue(starting,forKey: "selecteddate2")
        UserDefaults.standard.synchronize()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedDate = dateFormatter.date(from: todayEvents[indexPath.row].tithiDate!)
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateGetStart = dateFormatter.string(from: formatedDate!)

        
            let alert = UIAlertController(title: "\(todayEvents[indexPath.row].descriptionDetail!)", message: "\(dateGetStart) \(todayEvents[indexPath.row].timing!)", preferredStyle: UIAlertControllerStyle.alert)
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
 //       }
  /*      else{

        view.addSubview(Activityindicater)
        self.Activityindicater.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "tithi")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "selecteddate")
        UserDefaults.standard.removeObject(forKey: "selecteddate1")
        
        let indexPath = self.apptableView.indexPathForSelectedRow
        let cell = self.apptableView.cellForRow(at: indexPath!) as! ListTithiCell!
        
        let Titlename = cell?.titleLbl?.text
        let Subtitlename = cell?.timingLbl?.text
        
        print(Titlename!)
        print(Subtitlename!)
        discription = Titlename!
        time = Subtitlename!
        if calclick.day_inc_dec_click != 1
        {
            let date = Foundation.Date()
            let formater = DateFormatter()
            formater.dateFormat = "yyyy-MM-dd"
            sel_date = formater.string(from: date)
            formater.dateFormat = "dd MMM yyyy"
            sel_date1 = formater.string(from: date)
            
        }
        // connection.checkinternet()
        let myURL = URL(string: MyURL);
        let request = NSMutableURLRequest(url:myURL!);
        request.httpMethod="POST";
        let postString = "ok=listEvent&date=\(sel_date)";
        print(postString)
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
                
                if err == nil
                {
                    for i in 0 ..< resultValue.count
                    {
                        
                        if  let obj = resultValue[i] as? NSDictionary
                        {
                            if let Type = obj["Appo_Follow_Up_Type"] as? String
                            {
                                if let description = obj["description"] as? String
                                {
                                    if let id = obj["id"] as? String
                                    {
                                        if let timing1 = obj["timing"] as? String
                                        {
                                            if let tdate = obj["tdate"] as? String
                                            {
                                                print(self.time)
                                                print(timing1)
                                                if self.time == timing1
                                                {
                                                    self.maildata = tdate
                                                    print("@@@@@@@@@@@@@@@@")
                                                    UserDefaults.standard.setValue(description, forKey: "description1")
                                                    UserDefaults.standard.setValue(id, forKey: "id")
                                                    UserDefaults.standard.setValue(Type, forKey: "Type")
                                                    let spldate1 = timing1.characters.split(separator: "-").map(String.init)
                                                    print(spldate1.count)
                                                    if spldate1.count == 2
                                                    {
                                                        UserDefaults.standard.setValue(spldate1[1], forKey: "totiming")
                                                    }
                                                    UserDefaults.standard.setValue(spldate1[0], forKey: "timing")
                                                    UserDefaults.standard.setValue(self.sel_date, forKey: "selecteddate")
                                                    UserDefaults.standard.setValue(self.sel_date1, forKey: "selecteddate1")
                                                    UserDefaults.standard.synchronize()
                                                    let alert = UIAlertController(title: "\(timing1)", message: "\(description)", preferredStyle: UIAlertControllerStyle.alert)
                                                    alert.addAction(UIAlertAction(title: "Invite", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                                                        print("Invite !!")
                                                        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS" )
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
                                                        self.Activityindicater.stopAnimating()
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
        }
 */
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
        //NSUserDefaults.standardUserDefaults().removeObjectForKey("selecteddate")
        // NSUserDefaults.standardUserDefaults().removeObjectForKey("selecteddate1")
        
    }
    func handleDelete(_ alertView: UIAlertAction!)
    {
        let alert = UIAlertController(title: "Are you Sure???", message:
            "Do you Wants to Delete Data???", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: self.handleCancel))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive,handler: self.FinalhandleDelete))
        self.present(alert, animated: true, completion: nil)
    }
    func FinalhandleDelete(_ alertView: UIAlertAction!)
    {
        view.addSubview(Activityindicater)
        self.Activityindicater.startAnimating()
        self.view.isUserInteractionEnabled = false
        // connection.checkinternet()
        let pref = UserDefaults.standard
        let id = pref.string(forKey: "id")
        let myURL = URL(string:self.MyURL);
        let request = NSMutableURLRequest(url:myURL!);
        request.httpMethod="POST";
        
        let postString = "ok=delRec&id=\(id!)";
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            let err: NSError?
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            } catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                json = nil
            } catch {
                fatalError()
            }
            print(json)
            if let parseJSON:AnyObject = json as AnyObject?{
                let resultValue:String = parseJSON["status"] as! String!;
                print("result; \(resultValue)")
                if(resultValue == "Success")
                {
                    self.Timing.removeAll()
                    self.Followuptype.removeAll()
                    self.TableData.removeAll()
                    
                    //self.viewWillAppear(true)
                    self.viewDidAppear(true)
                    self.refreshDataInTable();
                    
                }
            }
            self.refreshDataInTable();
        }
        
        task.resume()
        
    }
    @IBAction func Todayview(_ sender: AnyObject) {
        lbltithi.text = ""
        TableData.removeAll()
        Timing.removeAll()
        Followuptype.removeAll()
        calclick.day_inc_dec_click = 0
        B_string.removeAll()
        self.todayEvents = []
        let date = Foundation.Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd"
        bdate = formater.string(from: date)
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ComponentViewController.storearray), userInfo: nil, repeats: false)
        ApiCall()
        gettithi()
    }
    @IBAction func Addevent(_ sender: AnyObject) {
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.synchronize()
        DispatchQueue.main.async(execute: {
            self.performSegue(withIdentifier: "addEvent", sender: self)
        })
    }
    @IBAction func decrement_by_one(_ sender: AnyObject)
    {
        view.addSubview(Activityindicater)
        self.Activityindicater.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        lbltithi.text = ""
        TableData.removeAll()
        Timing.removeAll()
        Followuptype.removeAll()
        self.todayEvents.removeAll()
        calclick.day_inc_dec_click = 1
        if exdate != nil
        {
            counter -= 1
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: counter, to: today)

//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(-1, forComponent:NSCalendar.Unit.day);
//            exdate = (Calendar.current as NSCalendar).date(byAdding: components, to: exdate, options: NSCalendar.Options(rawValue: 0))!
            print(exdate)
            let formater = DateFormatter()
            formater.dateFormat = "dd MMM yyyy"
            sel_date1 = formater.string(from: tomorrow!)
            lbldate.text = sel_date1
            formater.dateFormat = "yyyy-MM-dd"
            sel_date = formater.string(from: tomorrow!)
            print(sel_date)
            formater.dateFormat = "MM-dd"
            bdate = formater.string(from: tomorrow!)
            
        }
//        else if exdate == nil
//        {
//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(-1, forComponent: NSCalendar.Unit.day);
//            let date: Foundation.Date = Foundation.Date()
//            exdate = (Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))!
//            print(exdate)
//            
//            let formater = DateFormatter()
//            formater.dateFormat = "dd MMM yyyy"
//            sel_date1 = formater.string(from: exdate)
//            lbldate.text = sel_date1
//            formater.dateFormat = "yyyy-MM-dd"
//            sel_date = formater.string(from: exdate)
//            print(sel_date)
//            formater.dateFormat = "MM-dd"
//            bdate = formater.string(from: exdate)
//        }
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
            self.loadOffline(query: "tdate='\(sel_date)'")
//            
//        }
//        else{
//
        self.gettithi()
        
        
        B_string.removeAll()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ComponentViewController.storearray), userInfo: nil, repeats: false)
//        let postString = "ok=listEvent&date=\(sel_date)"
//        
//        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
//            
//            DispatchQueue.main.async {
//                
//                print("After Queue Response : \(response)")
//                
//                let json = JSON(data: response.data!)
//                var event : Event!
//                for i in 0 ..< json["all_data"].count{
//                    
//                    let description = json["all_data"][i]["description"].stringValue
//                    let timing = json["all_data"][i]["timing"].stringValue
//                    let tithi = json["all_data"][i]["tithi"].stringValue
//                    let followUpType = json["all_data"][i]["Appo_Follow_Up_Type"].stringValue
//                    
//                    event = Event(eventID: "", followUp: "", followUpType: followUpType, descriptionDetail: description, tithiDate: "", timing: timing, tithi: tithi, toDate: "", toTime: "",updateStamp: "", isSync: "", liveDBId: "", operationAction: "")
//                    
//                    self.todayEvents.append(event)
//                    
//                    UserDefaults.standard.setValue(tithi, forKey: "tithi")
//                    UserDefaults.standard.synchronize()
//                }
//                self.refreshDataInTable()
//            }
//        }
        }
    
    @IBAction func increment_by_one(_ sender: AnyObject)
    {
        view.addSubview(Activityindicater)
        self.Activityindicater.startAnimating()
        self.view.isUserInteractionEnabled = false
        lbltithi.text = ""
        Timing.removeAll()
        Followuptype.removeAll()
        TableData.removeAll()
        todayEvents=[]
        calclick.day_inc_dec_click = 1
        if exdate != nil
        {
//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(1, forComponent:NSCalendar.Unit.day);
//            exdate = (Calendar.current as NSCalendar).date(byAdding: components, to: exdate, options: NSCalendar.Options(rawValue: 0))!
            counter += 1
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: counter, to: today)

            print(exdate)
            let formater = DateFormatter()
            formater.dateFormat = "dd MMM yyyy"
            sel_date1 = formater.string(from: tomorrow!)
            lbldate.text = sel_date1
            formater.dateFormat = "yyyy-MM-dd"
            sel_date = formater.string(from: tomorrow!)
            print(sel_date)
            formater.dateFormat = "MM-dd"
            bdate = formater.string(from: tomorrow!)
        }
//        else if exdate == nil
//        {
//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(1, forComponent: NSCalendar.Unit.day);
//            let date: Foundation.Date = Foundation.Date()
//            exdate = (Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))!
//            print(exdate)
//            
//            let formater = DateFormatter()
//            formater.dateFormat = "dd MMM yyyy"
//            sel_date1 = formater.string(from: exdate)
//            lbldate.text = sel_date1
//            formater.dateFormat = "yyyy-MM-dd"
//            sel_date = formater.string(from: exdate)
//            print(sel_date)
//            formater.dateFormat = "MM-dd"
//            bdate = formater.string(from: exdate)
//        }
//      
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
            self.loadOffline(query: "tdate='\(sel_date)'")
//            
//        }
//        else{
        self.gettithi()
//        
        B_string.removeAll()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ComponentViewController.storearray), userInfo: nil, repeats: false)
//        let postString = "ok=listEvent&date=\(sel_date)"
//        
//        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
//            
//            DispatchQueue.main.async {
//                
//                print("After Queue Response : \(response)")
//                
//                let json = JSON(data: response.data!)
//                var event : Event!
//                for i in 0 ..< json["all_data"].count{
//                    
//                    let description = json["all_data"][i]["description"].stringValue
//                    let timing = json["all_data"][i]["timing"].stringValue
//                    let tithi = json["all_data"][i]["tithi"].stringValue
//                    let followUpType = json["all_data"][i]["Appo_Follow_Up_Type"].stringValue
//                    
//                    event = Event(eventID: "", followUp: "", followUpType: followUpType, descriptionDetail: description, tithiDate: "", timing: timing, tithi: tithi, toDate: "", toTime: "",updateStamp: "", isSync: "", liveDBId: "", operationAction: "")
//                    
//                    self.todayEvents.append(event)
//                    
//                    UserDefaults.standard.setValue(tithi, forKey: "tithi")
//                    UserDefaults.standard.synchronize()
//                }
//                self.refreshDataInTable()
//            }
//        }
//        }
    }
    func loadOffline(query : String){
        var dateEvent = [Event]()
        self.todayEvents = []
        
        dateEvent = DBManager.shared.loadEventsWithParam(queryString: query)
        var event : Event!
        
        for i in 0 ..< dateEvent.count{
            event = Event(eventID: dateEvent[i].eventID, followUp: dateEvent[i].followUp, followUpType: dateEvent[i].followUpType, descriptionDetail: dateEvent[i].descriptionDetail, tithiDate: dateEvent[i].tithiDate, timing: dateEvent[i].timing, tithi: dateEvent[i].tithi, toDate: dateEvent[i].toDate, toTime: dateEvent[i].toTime,updateStamp: dateEvent[i].updateStamp, isSync: dateEvent[i].isSync, liveDBId: dateEvent[i].liveDBId, operationAction: dateEvent[i].operationAction)
            
            self.todayEvents.append(event)
            self.lbltithi.text = "\(self.todayEvents[i].tithi!)"
            UserDefaults.standard.setValue(self.todayEvents[i].tithi, forKey: "tithi")
            UserDefaults.standard.synchronize()
        }
        self.refreshDataInTable()
    }
    func getbirthdayinfo()
    {
        //let request = CNContactFetchRequest(keysToFetch: keys)
        do {
            if #available(iOS 9.0, *) {
                let contactsStore = AppDelegate.getAppDelegate().contactStore
                let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey,CNContactPhoneNumbersKey] as [Any]
                try contactsStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])) { (contact, pointer) -> Void in
                    self.contacts.append(contact)
                }
            } else {
                // Fallback on earlier versions
            }
        } catch {
            print(error)
        }
    }
    func getDateStringFromComponents(_ dateComponents: DateComponents) -> String! {
        if let date = Calendar.current.date(from: dateComponents) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "MM-dd"
            birthday_st = dateFormatter.string(from: date)
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let dateString = dateFormatter.string(from: date)
            return dateString
        }
        return nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "birthday") {
            let viewController = segue.destination as! BirthdayViewController
            viewController.contacts = contacts
            viewController.B_string = B_string
        }
        else if (segue.identifier == "invite")
        {
            let viewController = segue.destination as! AddInviteesController
            viewController.maildata = maildata
            viewController.discription = discription
            viewController.time = time
        }
    }
}
