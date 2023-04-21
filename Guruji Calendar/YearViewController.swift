//
//  YearViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 27/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class YearViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate {
    var TableData:Array< String > = Array < String >()
    var date:Array< String > = Array < String >()
    var exdate = Date()
    var item = NSMutableSet()
    var currentDate:String = ""
    var ABC = String()
    let MyURL = Connection.open.Service
    var year = String()
    var se_date = String()
    var time_desc = String()
    var maildate = String()
    var time = String()
    var discription = String()
    var eventData = [Event]()
    var valueID = Int()
    var duplicate = [String]()
    var Titlename = ""
    
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    @IBOutlet weak var lblyear: UILabel!
    @IBOutlet weak var yearview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(YearViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "Addicon"), for: UIControlState())
        button.addTarget(self, action:#selector(YearViewController.callMethod), for: UIControlEvents.touchUpInside)
        button.frame=CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        let presentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateGetStart = dateFormatter.string(from: presentDate)

        self.se_date = dateGetStart
        
        print(se_date)
        var data = [Tithi]()
        data = DBManager.shared.loadSelectTithiByQuery(query: "SELECT * FROM Tithi_table WHERE tdate='\(dateGetStart)'")
        print(data[0].tithi)
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateGet = dateFormatter.string(from: presentDate)
        
        self.se_date = "\(dateGet)      \(data[0].pmonth!) \(data[0].tithi!)  \(data[0].vaar!)"
    }
    func networkStatusChanged(_ notification: Notification) {
        let userInfo = notification.userInfo
        print(userInfo!)
    }
    func update()
    {
        if se_date == "" || TableData.count == 0
        {
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(YearViewController.wait02sec), userInfo: nil, repeats: false)
        }
        else
        {
            
            for check in TableData
            {
                print("\(se_date) &&& \(check)")
                if se_date == check
                {
                    
                    let p = TableData.index(of: se_date)
                    
                    let indexPath = IndexPath(row: p!, section: 0);
                    self.yearview.scrollToRow(at: indexPath, at: .top, animated: true)
                    self.activityindicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    func getdate()
    {
        let myURL = URL(string: MyURL);
        let request = NSMutableURLRequest(url:myURL!);
        request.httpMethod="POST";
        let postString = "ok=getCurrentData&y=\(year)";
        print(postString)
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request as URLRequest)  {
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
                let alert = UIAlertController(title: "Opss", message: "Data not Available....", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityindicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                json = nil
            }catch {
                fatalError()
            }
            if let parseJSON: AnyObject = json as AnyObject?{
                print("result; \(parseJSON)")
                if err == nil
                {
                    if let curdate = parseJSON["curdate"] as? String
                    {
                        self.se_date = curdate
                        
                    }
                }
            }
        }
        task.resume()
    }
    func callMethod()
    {
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "AddYearview", sender: self)
    }
    override func viewDidAppear(_ animated: Bool) {
        view.addSubview(activityindicator)
//        self.view.isUserInteractionEnabled = false
//        self.activityindicator.startAnimating()
        TableData.removeAll()
        if calclick.year_inc_dec_click == 1
        {
            let formater = DateFormatter()
            formater.dateFormat = "yyyy"
            year = formater.string(from: exdate as Date)
            lblyear.text = year
        }
        self.servicecall()
        
    }
    func wait02sec()
    {
        if TableData.count == 0
        {
            viewDidAppear(true)
        }
        else
        {
            view.addSubview(activityindicator)
//            self.activityindicator.startAnimating()
//            self.view.isUserInteractionEnabled = false
            getdate()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(YearViewController.update), userInfo: nil, repeats: false)
        }
    }
    func loadOffline(query : String){
        
        eventData = []
        TableData = []
        self.date = []
        duplicate = []

        var added = [Event]()
        var tithis = [Tithi]()
        
        print("\(eventData.count) && \(TableData.count) && \(self.date.count)")
        tithis = DBManager.shared.loadSelectTithiByQuery(query: "SELECT * FROM Tithi_table WHERE strftime('%Y', tdate)  = '\(year)'")
        
        for i in 0 ..< tithis.count {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formatedDate = dateFormatter.date(from: tithis[i].date!)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateGetStart = dateFormatter.string(from: formatedDate!)
            let tithi = "\(tithis[i].pmonth!) \(tithis[i].tithi!) \(tithis[i].vaar!)"
            //           print(tithi)
            
            added = DBManager.shared.loadEventsWithParam(queryString: "tdate='\(tithis[i].date!)'")
            self.date.append(dateGetStart + "       " + tithi)
            self.TableData.append(dateGetStart + "       " + tithi)
            self.duplicate.append(dateGetStart + "       " + tithi)
            
            if added.count > 0 {
                for j in 0 ..< added.count{
                    print("\(added[j].descriptionDetail!)")
                    print("\(added[j].eventID)")
                    self.TableData.append(added[j].timing + "   " + added[j].descriptionDetail)
                    self.duplicate.append("\(added[j].eventID!)")
                    
                    let event = Event(eventID: added[j].eventID, followUp: added[j].followUp, followUpType: added[j].followUpType, descriptionDetail: added[j].descriptionDetail, tithiDate: added[j].tithiDate, timing: added[j].timing, tithi: added[j].tithi, toDate: added[j].toDate, toTime: added[j].toTime,updateStamp: added[j].updateStamp, isSync: added[j].isSync, liveDBId: added[j].liveDBId, operationAction: added[j].operationAction)
                    
                    eventData.append(event)
                }
            }
        
   /*
        
        eventData = []
        eventData = DBManager.shared.loadEventsByQuery(query: "select * from Guruji   WHERE strftime('%Y', tdate)  = '\(query)'")
        
        for i in 0 ..< eventData.count{
//            let yearGet = String(eventData[i].toDate.characters.prefix(4))
//            print(yearGet)
//            if(yearGet == query){
            
            print(eventData[i].descriptionDetail)
            
            self.item.add(eventData[i].tithiDate)
            if self.currentDate != eventData[i].tithiDate
            {
                
                self.currentDate = eventData[i].tithiDate
                self.date.append(self.currentDate + "       " + eventData[i].tithi)
                self.TableData.append(self.currentDate + "       " + eventData[i].tithi)
                let event = Event(eventID: eventData[i].eventID, followUp: eventData[i].followUp, followUpType: eventData[i].followUpType, descriptionDetail: eventData[i].descriptionDetail, tithiDate: eventData[i].tithiDate, timing: eventData[i].timing, tithi: eventData[i].tithi, toDate: eventData[i].toDate, toTime: eventData[i].toTime,updateStamp: eventData[i].updateStamp, isSync: eventData[i].isSync, liveDBId: eventData[i].liveDBId, operationAction: eventData[i].operationAction)
                    eventData.append(event)
            }
            if description != "" && eventData[i].tithiDate != ""
            {
                self.TableData.append("  " + eventData[i].timing + "   " + eventData[i].descriptionDetail)
            }
        }*/
        }
     
        self.yearview.reloadData()
        self.view.isUserInteractionEnabled = true;
        self.update()
    
    }
    func servicecall()
    {
        view.addSubview(activityindicator)
//        self.view.isUserInteractionEnabled = false
//        self.activityindicator.startAnimating()
        currentDate = ""
        UserDefaults.standard.removeObject(forKey: "tithi")
        if calclick.year_inc_dec_click != 1
        {
            let date = Foundation.Date()
            let formater = DateFormatter()
            formater.dateFormat = "yyyy"
            year = formater.string(from: date)
            lblyear.text = year
        }
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
         //   self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
            UserDefaults.standard.set(false, forKey: "isConnected")
        case .online(.wwan):
            print("Connected via WWAN")
            UserDefaults.standard.set(true, forKey: "isConnected")
        case .online(.wiFi):
            print("Connected via WiFi")
            UserDefaults.standard.set(true, forKey: "isConnected")
        }
        loadOffline(query: year)
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
//            loadOffline(query: year)
//        }else{
//            
//        let myURL1 = URL(string: MyURL);
//        let request1 = NSMutableURLRequest(url:myURL1!);
//        request1.httpMethod="POST";
//        let postString1 = "ok=listEvent&y=\(year)";
//        print(postString1)
//        request1.httpBody = postString1.data(using: String.Encoding.utf8);
//        let task1 = URLSession.shared.dataTask(with: request1 as URLRequest) {
//            data, response, error in
//            if error != nil
//            {
//                print("error=\(error)")
//                return
//            }
//            var err: NSError?
//            
//            let json: Any?
//            
//            do {
//                json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//                
//            }catch let error as NSError {
//                
//                print("json error: \(error.localizedDescription)")
//                json = nil
//                
//            }catch {
//                
//                fatalError()
//            }
//            if let parseJSON: AnyObject = json as AnyObject?{
//                let resultValue:NSArray = parseJSON["all_data"] as! NSArray;
//                if err == nil
//                {
//                    for i in 0 ..< resultValue.count
//                    {
//                        if  let obj = resultValue[i] as? NSDictionary
//                        {
//                            if let description = obj["description"] as? String
//                            {
//                                if let timing = obj["timing"] as? String
//                                {
//                                    if let tithi = obj["tithi"] as? String
//                                    {
//                                        if let tdate = obj["tdate"] as? String
//                                        {
//                                            self.item.add(tdate)
//                                            if self.currentDate != tdate
//                                            {
//                                                self.currentDate = tdate
//                                                self.date.append(self.currentDate + "       " + tithi)
//                                                self.TableData.append(self.currentDate + "       " + tithi)
//                                            }
//                                            if description != "" && tdate != ""
//                                            {
//                                                self.TableData.append("  " + timing + "   " + description)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            self.do_table_refresh();
//        }
//        
//        task1.resume()
//        }
    }
    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.yearview.reloadData()
            if calclick.year_inc_dec_click == 1
            {
//                self.view.isUserInteractionEnabled = true
//                self.activityindicator.stopAnimating()
            }
            else
            {
//                self.view.isUserInteractionEnabled = true
//                self.activityindicator.stopAnimating()
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(YearViewController.wait02sec), userInfo: nil, repeats: false)
            }
            
            
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        for arydate in date
        {
            if (TableData[indexPath.row] == arydate)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
                cell.textLabel?.textColor = UIColor(red: 63/255, green: 175/255, blue: 239/255, alpha: 1.0)
                cell.textLabel?.text = TableData[indexPath.row]
                cell.isUserInteractionEnabled = false
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "timecell", for: indexPath) as! YearDescriptionCell
        cell.descriptionLbl?.text = TableData[indexPath.row]
        cell.idGet?.text = duplicate[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.blue
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
        loadOffline(query: year)
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
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(isConnected){
        let indexPath2 = self.yearview.indexPathForSelectedRow
        let cell2 = self.yearview.cellForRow(at: indexPath) as! YearDescriptionCell!
        
        Titlename = (cell2?.idGet?.text!)!
        
        print("Did selected ID : \(Titlename)")
        
        for i in 0 ..< eventData.count {
            
            if eventData[i].eventID == Titlename {
                print("\(eventData[indexPath.row].eventID)")
                valueID = Int(eventData[i].eventID)!
                print(valueID)
                
                UserDefaults.standard.setValue(valueID, forKey: "id")
                UserDefaults.standard.setValue(eventData[i].descriptionDetail, forKey: "description1")
                UserDefaults.standard.setValue(eventData[i].followUpType, forKey: "Type")
                UserDefaults.standard.setValue(eventData[i].toTime ,forKey: "totiming")
                UserDefaults.standard.setValue(eventData[i].timing,forKey: "timing")
                UserDefaults.standard.setValue(eventData[i].liveDBId,forKey: "liveDB")

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
                let formatedDate = dateFormatter.date(from: eventData[i].tithiDate!)
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let dateGetStart = dateFormatter.string(from: formatedDate!)

                let alert = UIAlertController(title: "\(eventData[i].descriptionDetail!)", message: "\(dateGetStart) \(eventData[i].timing!)", preferredStyle: UIAlertControllerStyle.alert)
                
            alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                print("Done !!")
                self.performSegue(withIdentifier: "AddYearview", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDeleteOffline))
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
            self.present(alert, animated: true, completion: {
                
                print("completion block")
            })
            }
        }
            //    return
//        }
//        else{
//        }
//        view.addSubview(activityindicator)
////        self.activityindicator.startAnimating()
////        self.view.isUserInteractionEnabled = false
//        UserDefaults.standard.removeObject(forKey: "id")
//        UserDefaults.standard.removeObject(forKey: "tithi")
//        UserDefaults.standard.removeObject(forKey: "timing")
//        UserDefaults.standard.removeObject(forKey: "description1")
//        UserDefaults.standard.removeObject(forKey: "selecteddate")
//        UserDefaults.standard.removeObject(forKey: "selecteddate1")
//
//        let indexpath = self.yearview.indexPathForSelectedRow
//        let cell = self.yearview.cellForRow(at: indexpath!) as? YearDescriptionCell
//        time_desc = (cell?.descriptionLbl?.text)!
//        
//        let spldate = time_desc.characters.split(separator: " ").map(String.init)
//        discription = spldate[3]
//        time = "\(spldate[0]) \(spldate[1]) \(spldate[2])"
//        print(discription)
//        print(time)
//        if calclick.year_inc_dec_click != 1
//        {
//            let date = Foundation.Date()
//            let formater = DateFormatter()
//            formater.dateFormat = "yyyy"
//            year = formater.string(from: date)
//        }
//        let status = Reach().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
//     //       self.present(alert, animated: true, completion: nil)
//            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
//            }))
//        case .online(.wwan):
//            print("Connected via WWAN")
//            didselect_service()
//        case .online(.wiFi):
//            print("Connected via WiFi")
//            didselect_service()
//        }
    }
    func didselect_service()
    {
        let myURL1 = URL(string: MyURL);
        let request1 = NSMutableURLRequest(url:myURL1!);
        request1.httpMethod="POST";
        let postString1 = "ok=listEvent&y=\(year)";
        request1.httpBody = postString1.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request1 as URLRequest) {
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
                    for i in 0  ..< resultValue.count
                    {
                        if  let obj = resultValue[i] as? NSDictionary
                        {
                            if let Type = obj["Appo_Follow_Up_Type"] as? String
                            {
                                if let description = obj["description"] as? String
                                {
                                    if let id = obj["id"] as? String
                                    {
                                        if let tdate = obj["tdate"] as? String
                                        {
                                            if let timing1 = obj["timing"] as? String
                                            {
                                                let time = "  " + timing1 + "   " + description
                                                if self.time_desc == time
                                                {
                                                    self.maildate = tdate
                                                    print("@@@@@@@@@@@@@@@@")
                                                    UserDefaults.standard.setValue(description, forKey: "description1")
                                                    UserDefaults.standard.setValue(id, forKey: "id")
                                                    UserDefaults.standard.setValue(Type, forKey: "Type")
                                                    let spldate1 = timing1.characters.split(separator: "-").map(String.init)
                                                    if spldate1.count == 2
                                                    {
                                                        UserDefaults.standard.setValue(spldate1[1], forKey: "totiming")
                                                    }
                                                    UserDefaults.standard.setValue(spldate1[0], forKey: "timing")
                                                    //                                                    let newDate = tdate.stringByReplacingOccurrencesOfString("-", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
                                                    let newDate1 = tdate
                                                    let spldate = newDate1.characters.split(separator: "-").map(String.init)
                                                    let selecteddate = spldate[2] + "-" + spldate[1] + "-" + spldate[0]
                                                    let monthnum = spldate[1]
                                                    print(selecteddate)
                                                    if monthnum == "01"
                                                    {
                                                        self.ABC = "Jan"
                                                    }
                                                    else if monthnum == "02"
                                                    {
                                                        self.ABC = "Feb"
                                                    }
                                                    else if monthnum == "03"
                                                    {
                                                        self.ABC = "Mar"
                                                    }
                                                    else if monthnum == "04"
                                                    {
                                                        self.ABC = "Apr"
                                                    }
                                                    else if monthnum == "05"
                                                    {
                                                        self.ABC = "May"
                                                    }
                                                    else if monthnum == "06"
                                                    {
                                                        self.ABC = "Jun"
                                                    }
                                                    else if monthnum == "07"
                                                    {
                                                        self.ABC = "Jul"
                                                    }
                                                    else if monthnum == "08"
                                                    {
                                                        self.ABC = "Aug"
                                                    }
                                                    else if monthnum == "09"
                                                    {
                                                        self.ABC = "Sep"
                                                    }
                                                    else if monthnum == "10"
                                                    {
                                                        self.ABC = "Oct"
                                                    }
                                                    else if monthnum == "11"
                                                    {
                                                        self.ABC = "Nav"
                                                    }
                                                    else if monthnum == "12"
                                                    {
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
                                                        let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS" )
                                                        actionSheet.show(in: self.view)
                                                    }))
                                                    alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                                                        self.performSegue(withIdentifier: "AddYearview", sender: self)
                                                    }))
                                                    alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDelete))
                                                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
                                                    self.present(alert, animated: true, completion: {
                                                        print("completion block")
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
            self.do_table_refresh();
        }
        
        task.resume()
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
        let alert = UIAlertController(title: "Are you Sure???", message:
            "Do you Wants to Delete Data???", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: self.handleCancel))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive,handler: self.FinalhandleDelete))
        self.present(alert, animated: true, completion: nil)
        print("Deleted !!")
    }
    func FinalhandleDelete(_ alertView: UIAlertAction!)
    {
        view.addSubview(activityindicator)
//        self.activityindicator.startAnimating()
//        self.view.isUserInteractionEnabled = false
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
       //     self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
        case .online(.wwan):
            print("Connected via WWAN")
            delete_service()
        case .online(.wiFi):
            print("Connected via WiFi")
            delete_service()
        }
    }
    func delete_service()
    {
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
            var err: NSError = NSError()
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
                let resultValue:String = parseJSON["status"] as! String!;
                if(resultValue == "Success")
                {
                    self.viewDidAppear(true)
                    self.do_table_refresh();
                }
            }
            self.do_table_refresh();
        }
        
        task.resume()
    }
    @IBAction func Year_Decrement_by_one(_ sender: AnyObject) {
        view.addSubview(activityindicator)
//        self.activityindicator.startAnimating()
//        self.view.isUserInteractionEnabled = false
        TableData.removeAll()
        calclick.year_inc_dec_click = 1
        let addYear = Int(year)! - 1
        year = String(addYear)
        lblyear.text = year
        print(year)
        UserDefaults.standard.setValue(year, forKey: "year")
        UserDefaults.standard.synchronize()
        
//        if exdate != nil
//        {
//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(-1, forComponent:NSCalendar.Unit.year);
//            exdate = ((Calendar.current as NSCalendar).date(byAdding: components, to: exdate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate) as Date
//            print(exdate)
//            let formater = DateFormatter()
//            formater.dateFormat = "yyyy"
//            let selecteddate = formater.string(from: exdate as Date)
//            lblyear.text = selecteddate
//            formater.dateFormat = "yyyy"
//            year = formater.string(from: exdate as Date)
//            print(year)
//            UserDefaults.standard.setValue(selecteddate, forKey: "year")
//            UserDefaults.standard.synchronize()
//        }
//        else if exdate == nil
//        {
//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(-1, forComponent: NSCalendar.Unit.year);
//            let date: Foundation.Date = Foundation.Date()
//            exdate = ((Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))! as NSDate) as Date
//            let formater = DateFormatter()
//            formater.dateFormat = "yyyy"
//            let selecteddate = formater.string(from: exdate as Date)
//            lblyear.text = selecteddate
//            formater.dateFormat = "yyyy"
//            year = formater.string(from: exdate as Date)
//            UserDefaults.standard.setValue(selecteddate, forKey: "year")
//            UserDefaults.standard.synchronize()
//        print(year,exdate)
//        }
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
            loadOffline(query: year)
//        }else{
   //     servicecall2(yearAdd: year)
  //      }
    }
    @IBAction func Year_Increment_by_one(_ sender: AnyObject) {
        view.addSubview(activityindicator)
//        self.activityindicator.startAnimating()
//        self.view.isUserInteractionEnabled = false
        TableData.removeAll()
        
        calclick.year_inc_dec_click = 1
        let addYear = Int(year)! + 1
        year = String(addYear)
        lblyear.text = year
        print(year)
        UserDefaults.standard.setValue(year, forKey: "year")
        UserDefaults.standard.synchronize()
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
            loadOffline(query: year)
//        }else{
//        servicecall2(yearAdd: year)
//        }
//        if exdate != nil
//        {
//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(1, forComponent:NSCalendar.Unit.year);
//            exdate = ((Calendar.current as NSCalendar).date(byAdding: components, to: exdate as Date, options: NSCalendar.Options(rawValue: 0))! as NSDate) as Date
//            print(exdate)
//            let formater = DateFormatter()
//            formater.dateFormat = "yyyy"
//            let selecteddate = formater.string(from: exdate as Date)
//            lblyear.text = selecteddate
//            formater.dateFormat = "yyyy"
//            year = formater.string(from: exdate as Date)
//            print(year)
//            UserDefaults.standard.setValue(selecteddate, forKey: "year")
//            UserDefaults.standard.synchronize()
//        }
//        else if exdate == nil
//        {
//            let components: DateComponents = DateComponents()
//            (components as NSDateComponents).setValue(1, forComponent: NSCalendar.Unit.year);
//            let date: Foundation.Date = Foundation.Date()
//            exdate = ((Calendar.current as NSCalendar).date(byAdding: components, to: date, options: NSCalendar.Options(rawValue: 0))! as NSDate) as Date
//            print(exdate)
//            let formater = DateFormatter()
//            formater.dateFormat = "yyyy"
//            let selecteddate = formater.string(from: exdate as Date)
//            lblyear.text = selecteddate
//            formater.dateFormat = "yyyy"
//            year = formater.string(from: exdate as Date)
//            print(year)
//            UserDefaults.standard.setValue(selecteddate, forKey: "year")
//            UserDefaults.standard.synchronize()
//        }
//        service()
    }
    func service()
    {
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
        //    self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
        case .online(.wwan):
            print("Connected via WWAN")
            inc_dec_service()
        case .online(.wiFi):
            print("Connected via WiFi")
            inc_dec_service()
        }
    }
    func inc_dec_service()
    {
        let myURL1 = URL(string: MyURL);
        let request1 = NSMutableURLRequest(url:myURL1!);
        request1.httpMethod="POST";
        let postString1 = "ok=listEvent&y=\(year)";
        print(postString1)
        request1.httpBody = postString1.data(using: String.Encoding.utf8);
        let task1 = URLSession.shared.dataTask(with: request1 as URLRequest) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            var err: NSError = NSError()
            let json: Any?
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            }catch let error as NSError {
                print("json error: \(error.localizedDescription)")
                
//                self.view.isUserInteractionEnabled = true
//                self.activityindicator.stopAnimating()
                
                let alert = UIAlertController(title: "Opss", message: "Data not Available....", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                json = nil


            }catch {
                fatalError()
            }
            if let parseJSON: AnyObject = json as AnyObject?{
                let resultValue:NSArray = parseJSON["all_data"] as! NSArray;
                if err == nil
                {
                   for i in 0  ..< resultValue.count
                    {
                        if  let obj = resultValue[i] as? NSDictionary
                        {
                            if let description = obj["description"] as? String
                            {
                                if let timing = obj["timing"] as? String
                                {
                                    if let tithi = obj["tithi"] as? String
                                    {
                                        if let tdate = obj["tdate"] as? String
                                        {
                                            self.item.add(tdate)
                                            if self.currentDate != tdate
                                            {
                                                self.currentDate = tdate
                                                self.date.append(self.currentDate + "       " + tithi)
                                                self.TableData.append(self.currentDate + "       " + tithi)
                                            }
                                            self.TableData.append("  " + timing + "   " + description)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.do_table_refresh();
        }
        
        task1.resume()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "invite")
        {
            if #available(iOS 9.0, *) {
                let viewController = segue.destination as! AddInviteesController
                viewController.maildata = maildate
                viewController.discription = discription
                viewController.time = time
            } else {
                // Fallback on earlier versions
            }
        }
    }
    func servicecall2(yearAdd : String)
    {
        view.addSubview(activityindicator)
//        self.view.isUserInteractionEnabled = false
//        self.activityindicator.startAnimating()
        currentDate = ""
        UserDefaults.standard.removeObject(forKey: "tithi")
        if calclick.year_inc_dec_click != 1
        {
            let date = Foundation.Date()
            let formater = DateFormatter()
            formater.dateFormat = "yyyy"
            year = formater.string(from: date)
            lblyear.text = year
        }
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
         //   self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
        case .online(.wwan):
            print("Connected via WWAN")
        case .online(.wiFi):
            print("Connected via WiFi")
        }
        let myURL1 = URL(string: MyURL);
        let request1 = NSMutableURLRequest(url:myURL1!);
        request1.httpMethod="POST";
        let postString1 = "ok=listEvent&y=\(yearAdd)";
        print(postString1)
        request1.httpBody = postString1.data(using: String.Encoding.utf8);
        let task1 = URLSession.shared.dataTask(with: request1 as URLRequest) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            var err : NSError?
            
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
                if err == nil
                {
                    for i in 0 ..< resultValue.count
                    {
                        if  let obj = resultValue[i] as? NSDictionary
                        {
                            if let description = obj["description"] as? String
                            {
                                if let timing = obj["timing"] as? String
                                {
                                    if let tithi = obj["tithi"] as? String
                                    {
                                        if let tdate = obj["tdate"] as? String
                                        {
                                            self.item.add(tdate)
                                            if self.currentDate != tdate
                                            {
                                                self.currentDate = tdate
                                                self.date.append(self.currentDate + "       " + tithi)
                                                self.TableData.append(self.currentDate + "       " + tithi)
                                            }
                                            if description != "" && tdate != ""
                                            {
                                                self.TableData.append("  " + timing + "   " + description)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.do_table_refresh();
            
        }
        
        task1.resume()
    }

}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


