//
//  MonthViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 27/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
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


class MonthViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate {
    var TableData:Array< String > = Array < String >()
    var date:Array< String > = Array < String >()
    var exdate = Foundation.Date()
    var item = NSMutableSet()
    var currentDate:String = ""
    var ABC = String()
    var xyz = String()
    var number = Int()
    var hours = Int()
    var month = String()
    var Titlename = ""
    var year = String()
    var se_date = String()
    var maildate = String()
    var time = String()
    var discription = String()
    let MyURL = Connection.open.Service
    var counter = 0
    var eventData = [Event]()
    var valueID = Int()
    var duplicate = [String]()
    
    @IBOutlet weak var lblmonth: UILabel!
    @IBOutlet weak var monthview: UITableView!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(MonthViewController.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        
        Reach().monitorReachabilityChanges()
        
        let button = UIButton(type: UIButtonType.custom) as UIButton?
        button?.setImage(UIImage(named: "Addicon"), for: UIControlState())
        button?.addTarget(self, action:#selector(MonthViewController.callMethod), for: UIControlEvents.touchUpInside)
        button?.frame=CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button!)
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
        
        self.se_date = "\(dateGet)       \(data[0].pmonth!) \(data[0].tithi!) \(data[0].vaar!)"

        self.servicecall()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.servicecall()
    }
    func today_date_and_tithi()
    {
        let tdate = Foundation.Date()
        let formet = DateFormatter()
        
        formet.dateFormat = "yyyy-MM-dd"
        let sssdate = formet.string(from: tdate)
        
        formet.dateFormat = "dd-MM-yyyy"
        let todaydate = formet.string(from: tdate)
  //      let postString = "ok=getTithi&db_date=\(sssdate)";
        var data = [Tithi]()
        data = DBManager.shared.loadSelectTithi(withID: sssdate)
        let tithi = "\(data[0].pmonth!) \(data[0].tithi!) \(data[0].vaar!)"
        print(tithi)

//        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
//            
//            DispatchQueue.main.async {
//                
//                print("After Queue Response : \(response)")
        
//                let json = JSON(data: response.data!)
//                let tithi = json["tithi"].stringValue
                
                UserDefaults.standard.setValue(tithi, forKey: "tithi")
                UserDefaults.standard.synchronize()
                self.se_date = todaydate + "       " + tithi
                print(self.se_date)
//            }
//        }
    }
    func networkStatusChanged(_ notification: Notification) {
        let userInfo = notification.userInfo
        print(userInfo!)
    }
    func update()
    {
        if se_date == "" || TableData.count == 0
        {
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MonthViewController.wait02sec), userInfo: nil, repeats: false)
        }
        else
        {
            for check in TableData
            {
                if se_date == check
                {
                    let p = TableData.index(of: se_date)
                    print(p)
                    let indexPath = IndexPath(row: p!, section: 0);
                    self.monthview.scrollToRow(at: indexPath, at: .top, animated: true)
                    self.activityindicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func callMethod()
    {
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "AddMonthview", sender: self)
    }
    override func viewDidAppear(_ animated: Bool)
    {
        view.addSubview(activityindicator)
        
//        self.activityindicator.startAnimating()
//        self.view.isUserInteractionEnabled = false
//        TableData.removeAll()
        if calclick.monthincriment_click == 1
        {
            
//            let formater = DateFormatter()
//            formater.dateFormat = "MM"
//            month = formater.string(from: exdate)
//            formater.dateFormat = "yyyy"
//            year = formater.string(from: exdate)
//            formater.dateFormat = "MMMM, yyyy"
//            let selecteddate = formater.string(from: exdate)
//            lblmonth.text = selecteddate
            
            
        }
        
      //  self.servicecall()
        
        
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
            today_date_and_tithi()
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MonthViewController.update), userInfo: nil, repeats: false)
        }
    }
    func servicecall()
    {
        if calclick.monthincriment_click != 1
        {
            let date = Foundation.Date()
            let formater = DateFormatter()
            formater.dateFormat = "MM"
            month = formater.string(from: date)
            formater.dateFormat = "yyyy"
            year = formater.string(from: date)
            formater.dateFormat = "MMMM, yyyy"
            let selecteddate = formater.string(from: date)
            lblmonth.text = selecteddate
        }
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
      //      self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            }))
        case .online(.wwan):
            print("Connected via WWAN")
        case .online(.wiFi):
            print("Connected via WiFi")
        }
        UserDefaults.standard.removeObject(forKey: "tithi")
        
        self.loadOffline(year: year, month: month)
    }
    func loadOffline(year : String, month : String){

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
            let formatedDate = dateFormatter.date(from: tithis[i].date!)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateGetStart = dateFormatter.string(from: formatedDate!)
            let tithi = "\(tithis[i].pmonth!) \(tithis[i].tithi!) \(tithis[i].vaar!)"
 //           print(tithi)
            
            added = DBManager.shared.loadEventsWithParam(queryString: "tdate='\(tithis[i].date!)'")
            self.date.append(dateGetStart + "       " + tithi)
            self.TableData.append(dateGetStart + "       " + tithi)
            self.duplicate.append(dateGetStart + "       " + tithi)
            
        //    print("\(added[i].eventID)")
            
            if added.count > 0 {
            
                for j in 0 ..< added.count{
//                    print("\(added[j].descriptionDetail!)")
//                    print("\(added[j].eventID)")
                    self.TableData.append(added[j].timing + "   " + added[j].descriptionDetail)
                    self.duplicate.append("\(added[j].eventID!)")
                    
                    let event = Event(eventID: added[j].eventID, followUp: added[j].followUp, followUpType: added[j].followUpType, descriptionDetail: added[j].descriptionDetail, tithiDate: added[j].tithiDate, timing: added[j].timing, tithi: added[j].tithi, toDate: added[j].toDate, toTime: added[j].toTime,updateStamp: added[j].updateStamp, isSync: added[j].isSync, liveDBId: added[j].liveDBId, operationAction: added[j].operationAction)

                    eventData.append(event)
//                    print(eventData[j].eventID)
             //       print(self.ids)
                    
                    
                    
/*                    if self.currentDate != added[j].tithiDate
                    {
                        self.currentDate = added[j].tithiDate
                        self.date.append(self.currentDate + "       " + added[j].tithi)
                        self.TableData.append(self.currentDate + "       " + added[j].tithi)
                    }
                    if added[j].descriptionDetail != "" && added[j].tithiDate != ""
                    {
                        self.TableData.append("  " + added[j].timing + "   " + added[j].descriptionDetail)
                    }*/


                }
            }
        }
        monthview.reloadData()
        update()
    }

    func do_table_refresh()
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.monthview.reloadData()
            
            if calclick.monthincriment_click == 1
            {
//                self.view.isUserInteractionEnabled = true
//                self.activityindicator.stopAnimating()
            }
            else
            {
//                self.view.isUserInteractionEnabled = true
//                self.activityindicator.stopAnimating()
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MonthViewController.wait02sec), userInfo: nil, repeats: false)
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "MonthViewCell", for: indexPath) as! MonthViewCell
         
                cell.btndate_tithi.setTitle(TableData[indexPath.row], for: UIControlState())
                cell.btndate_tithi.tag = indexPath.row
//                cell.btndate_tithi.addTarget(self, action: #selector(MonthViewController.getinfo(_:)), for: UIControlEvents.touchUpInside)
                cell.isUserInteractionEnabled = true
                tableView.rowHeight = 40
                
                // Single Tap
                let SingleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(sender:)))
                SingleTap.numberOfTapsRequired = 1
                cell.addGestureRecognizer(SingleTap)
                
                let SingTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(sender:)))
                SingTap.numberOfTapsRequired = 1
                cell.btndate_tithi.addGestureRecognizer(SingTap)
                
                // Double Tap
                let doubleTap: UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(sender:)))
                doubleTap.numberOfTapsRequired = 2
                cell.btndate_tithi.addGestureRecognizer(doubleTap)
                
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TithiMonthCell", for: indexPath) as! TithiMonthCell
        tableView.rowHeight = 40
        cell.titleLbl?.text = TableData[indexPath.row]
        cell.idGet?.text = duplicate[indexPath.row]
        return cell

    }
    
    
    
    func handleSingleTap(sender: AnyObject?) {
        print("Single Tap!")
        print(sender?.tag ?? 0)
        
    }
    
    
    func handleDoubleTap(sender: UITapGestureRecognizer) {
        print("Double Tap!")
        let tapDouble = sender.location(in: self.monthview)
        let indexPath = self.monthview.indexPathForRow(at: tapDouble)
        let Selectedcell = self.monthview.cellForRow(at: indexPath!) as! MonthViewCell!
        let strText = Selectedcell?.btndate_tithi.titleLabel?.text
        let arrSep = strText?.components(separatedBy: " ")
        let firstText = arrSep?.first
        print(firstText ?? 0)
        
        let formater = DateFormatter()
        formater.dateFormat = "dd-MM-yyyy"
        let date = formater.date(from: firstText!)
        print(date ?? 0)
        formater.dateFormat = "dd MMM, yyyy"
        let selecteddate = formater.string(from: date!)
        print(selecteddate)
        
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "totiming")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.synchronize()
        
        let objAddEvent = self.storyboard?.instantiateViewController(withIdentifier: "AddEventViewController") as! AddEventViewController
        objAddEvent.strScreenFrom = "DoubleTap"
        objAddEvent.strselectedDate = selecteddate
        self.navigationController?.pushViewController(objAddEvent, animated: true)
        
        //            lblmonth.text = selecteddate
        
        
    }
    
    func getinfo(_ sender: UIButton)
    {
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "tithi")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.removeObject(forKey: "Type")
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "selecteddate")
        UserDefaults.standard.removeObject(forKey: "selecteddate1")
        let title123 = sender.titleLabel?.text
        print(title123!)
        self.performSegue(withIdentifier: "AddMonthview", sender: self)
        var myStringArr = title123!.components(separatedBy: "    ")
        let spldate = myStringArr[0].characters.split(separator: "-").map(String.init)
        let selecteddate = spldate[2] + "-" + spldate[1] + "-" + spldate[0]
        print(selecteddate)
        let monthnum = spldate[1]
        print(selecteddate)
        if monthnum == "01"
        {
            self.xyz = "Jan"
        }
        else if monthnum == "02"
        {
            self.xyz = "Feb"
        }
        else if monthnum == "03"
        {
            self.xyz = "Mar"
        }
        else if monthnum == "04"
        {
            self.xyz = "Apr"
        }
        else if monthnum == "05"
        {
            self.xyz = "May"
        }
        else if monthnum == "06"
        {
            self.xyz = "Jun"
        }
        else if monthnum == "07"
        {
            self.xyz = "Jul"
        }
        else if monthnum == "08"
        {
            self.xyz = "Aug"
        }
        else if monthnum == "09"
        {
            self.xyz = "Sep"
        }
        else if monthnum == "10"
        {
            self.xyz = "Oct"
        }
        else if monthnum == "11"
        {
            self.xyz = "Nav"
        }
        else if monthnum == "12"
        {
            self.xyz = "Dec"
        }
        let selecteddate1 = spldate[0] + " \(self.xyz)" + " " + spldate[2]
        UserDefaults.standard.setValue(selecteddate, forKey: "selecteddate")
        UserDefaults.standard.setValue(selecteddate1, forKey: "selecteddate1")
        print(selecteddate1)
        self.currenttime()
    }
    func currenttime()
    {
        let todaysDate:Foundation.Date = Foundation.Date()
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm a"
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
            else{
                let timing = "0" + selectedhour + ":" + myString + " " + spldate1[1]
                print(timing)
                UserDefaults.standard.setValue(timing, forKey: "timing")
            }
        }
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
        self.loadOffline(year: year, month: month)
    //    loadOffline(query: year)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
        clearPrefrences()
     //   let indexPath2 = self.monthview.indexPathForSelectedRow
        let cell2 = self.monthview.cellForRow(at: indexPath) as! TithiMonthCell!
        
        Titlename = (cell2?.idGet?.text!)!
        
        print("Did selected ID : \(Titlename)")
        
        for i in 0 ..< eventData.count {
            
            if eventData[i].eventID == Titlename {
            
//            print("\(eventData[indexPath.row].eventID)")
            valueID = Int(eventData[i].eventID)!
            //print(valueID)

            UserDefaults.standard.setValue(valueID, forKey: "id")
            UserDefaults.standard.setValue(eventData[i].descriptionDetail, forKey: "description1")
            UserDefaults.standard.setValue(eventData[i].followUpType, forKey: "Type")
            UserDefaults.standard.setValue(eventData[i].toTime ,forKey: "totiming")
            UserDefaults.standard.setValue(eventData[i].timing,forKey: "timing")
            UserDefaults.standard.setValue(eventData[i].liveDBId,forKey: "liveDB")

                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "yyyy-MM-dd"
                let formatedDate2 = dateFormatter2.date(from: eventData[i].tithiDate!)
                dateFormatter2.dateFormat = "dd MMM, yyyy"
                let starting = dateFormatter2.string(from:formatedDate2!)
//                print("date: \(starting)")
    
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
                self.performSegue(withIdentifier: "AddMonthview", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDeleteOffline))
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
            
//            alert.addAction(UIAlertAction(title: "Invite", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
//                print("Invite !!")
//                let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS" )
//                actionSheet.show(in: self.view)
//            }))

            self.present(alert, animated: true, completion: {
                
                print("completion block")
            })
            }
        }
            //    return
 //       }
 /*       else{
        

        
        
        view.addSubview(activityindicator)
//        self.activityindicator.startAnimating()
//        self.view.isUserInteractionEnabled = false
        UserDefaults.standard.removeObject(forKey: "id")
        UserDefaults.standard.removeObject(forKey: "tithi")
        UserDefaults.standard.removeObject(forKey: "timing")
        UserDefaults.standard.removeObject(forKey: "type")
        UserDefaults.standard.removeObject(forKey: "description1")
        UserDefaults.standard.removeObject(forKey: "selecteddate")
        UserDefaults.standard.removeObject(forKey: "selecteddate1")
        UserDefaults.standard.removeObject(forKey: "month")
        UserDefaults.standard.removeObject(forKey: "year")
        let indexPath = self.monthview.indexPathForSelectedRow
        let cell = self.monthview.cellForRow(at: indexPath!) as! TithiMonthCell!
        Titlename = (cell?.titleLbl?.text!)!
        print(Titlename)
        let spldate = Titlename.characters.split(separator: " ").map(String.init)
        discription = spldate[3]
        time = "\(spldate[0]) \(spldate[1]) \(spldate[2])"
        if calclick.monthincriment_click != 1
        {
            let date = Foundation.Date()
            let formater = DateFormatter()
            formater.dateFormat = "MM"
            month = formater.string(from: date)
            formater.dateFormat = "yyyy"
            year = formater.string(from: date)
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
            didselected_service()
        case .online(.wiFi):
            print("Connected via WiFi")
            didselected_service()
        }
    }*/
    }
    func didselected_service()
    {
        let myURL = URL(string: MyURL);
        let request = NSMutableURLRequest(url:myURL!);
        request.httpMethod="POST";
        let postString = "ok=listEvent&m=\(month)&y=\(year)";
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
                                        if let tdate = obj["tdate"] as? String
                                        {
                                            if let timing1 = obj["timing"] as? String
                                            {
                                                let time = "  " + timing1 + "   " + description
                                                if self.Titlename == time
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
                                                    let newDate1 = tdate
                                                    let spldate = newDate1.characters.split(separator: "-").map(String.init)
                                                    let selecteddate = spldate[2] + "-" + spldate[1] + "-" + spldate[0]
                                                    let monthnum = spldate[1]
                                                    let yearnum = spldate[2]
                                                    UserDefaults.standard.setValue(yearnum, forKey: "year")
                                                    UserDefaults.standard.setValue(monthnum, forKey: "month")
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
                                                        self.performSegue(withIdentifier: "AddMonthview", sender: self)
                                                    }))
                                                    alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDelete))
                                                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
                                                    self.present(alert, animated: true, completion: {
                                                        print("completion block")
                                                        self.view.isUserInteractionEnabled = true
                                                        self.activityindicator.stopAnimating()
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
    func handleDelete(_ alertView: UIAlertAction!)
    {
        let alert = UIAlertController(title: "Are you Sure???", message:
            "Do you Wants to Delete Data???", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: self.handleCancel))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive,handler: self.FinalhandleDelete))
        self.present(alert, animated: true, completion: nil)
        print("Deleted !!")
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
    func FinalhandleDelete(_ alertView: UIAlertAction!)
    {
        view.addSubview(activityindicator)
//        self.view.isUserInteractionEnabled = false
//        self.activityindicator.startAnimating()
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
     //       self.present(alert, animated: true, completion: nil)
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
            if let parseJSON = json as AnyObject?{
                
                let resultValue:String = parseJSON["status"] as! String!;
                print("result; \(resultValue)")
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var date_decrement_by_one: UIButton!
    @IBAction func date_decrement_by_one(_ sender: AnyObject) {
        counter -= 1
        print(counter)
        view.addSubview(activityindicator)
//        self.view.isUserInteractionEnabled = false
//        self.activityindicator.startAnimating()
        TableData.removeAll()
        calclick.monthincriment_click = 1
       if exdate != nil
        {
            print(exdate)
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .month, value: counter, to: today)

            print(tomorrow!)
            let formater = DateFormatter()
            formater.dateFormat = "MMMM, yyyy"
            let selecteddate = formater.string(from: tomorrow!)
            UserDefaults.standard.setValue(selecteddate, forKey: "date")
            UserDefaults.standard.synchronize()
            lblmonth.text = selecteddate
            formater.dateFormat = "MM"
            month = formater.string(from: tomorrow!)
            print(month)
            formater.dateFormat = "yyyy"
            year = formater.string(from: tomorrow!)
            print(year)
            UserDefaults.standard.setValue(year, forKey: "year")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(month, forKey: "month")
            UserDefaults.standard.synchronize()
            
        }
        print("\(month) \(year)")
//        let status = Reach().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
//       //     self.present(alert, animated: true, completion: nil)
//            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
//            }))
//        case .online(.wwan):
//            print("Connected via WWAN")
//            inc_dec_service()
//        case .online(.wiFi):
//            print("Connected via WiFi")
//            inc_dec_service()
//        }
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
//            self.loadOffline(query: "\(year)-\(month)")
        self.loadOffline(year: year, month: month)
//        }
//        else{
//            inc_dec_service()
//        }
    }
    @IBAction func date_increment_by_one(_ sender: AnyObject) {
        counter += 1
        print(counter)
        view.addSubview(activityindicator)
   //     self.view.isUserInteractionEnabled = false
//        self.activityindicator.startAnimating()
        TableData.removeAll()
        calclick.monthincriment_click = 1
        print(exdate)
        if exdate != nil
        {
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .month, value: counter, to: today)

            print(tomorrow)
            let formater = DateFormatter()
            formater.dateFormat = "MMMM, yyyy"
            let selecteddate = formater.string(from: tomorrow!)
            lblmonth.text = selecteddate
            UserDefaults.standard.setValue(selecteddate, forKey: "date")
            UserDefaults.standard.synchronize()
            formater.dateFormat = "MM"
            month = formater.string(from: tomorrow!)
            print(month)
            formater.dateFormat = "yyyy"
            year = formater.string(from: tomorrow!)
            print(year)
            UserDefaults.standard.setValue(year, forKey: "year")
            UserDefaults.standard.synchronize()
            UserDefaults.standard.setValue(month, forKey: "month")
            UserDefaults.standard.synchronize()
            calclick.monthincriment_click = +1
            
        }
        print("\(month) \(year)")
//        let status = Reach().connectionStatus()
//        switch status {
//        case .unknown, .offline:
//            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
//         //   alert.show()
//        case .online(.wwan):
//            print("Connected via WWAN")
//            inc_dec_service()
//        case .online(.wiFi):
//            print("Connected via WiFi")
//            inc_dec_service()
//        }
//        
//        let isConnected = UserDefaults.standard.bool(forKey: "isConnected")
//        if(!isConnected){
//            self.loadOffline(query: "\(year)-\(month)")
        self.loadOffline(year: year, month: month)
//        }
//        else{
//            inc_dec_service()
//        }
    }
    @IBOutlet weak var date_increment_by_one: UIButton!
    func inc_dec_service()
    {
        let myURL1 = URL(string: MyURL);
        let request1 = NSMutableURLRequest(url:myURL1!);
        request1.httpMethod="POST";
        let postString1 = "ok=listEvent&m=\(month)&y=\(year)";
        request1.httpBody = postString1.data(using: String.Encoding.utf8);
        
        let task1 = URLSession.shared.dataTask(with: request1 as URLRequest) {
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
}
