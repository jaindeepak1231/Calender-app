//
//  SyncController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 27/03/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SyncController: UIViewController {
    var eventData = [Event]()
    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet weak var backBtn : UIButton!
    /*
     let field_ID = "id"
     let field_follow_up = "Appo_Follow_Up"
     let field_Follow_Up_Type = "Appo_Follow_Up_Type"
     let field_description = "description"
     let field_tithiDate = "tDate"
     let field_timing = "timing"
     let field_tithi = "tithi"
     let field_to_date = "todate"
     let field_to_time = "totime"
     let field_update_stamp = "update_stamp"
     let field_sync = "is_sync"
     let field_live_db_id = "live_db_id"
     let field_operation_action = "opr_action"

     */
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    override func viewWillAppear(_ animated: Bool) {

        eventData = DBManager.shared.loadEventsSync()
        if eventData.count > 0 {
            sendDataToServer()
        }
        else{
            dissmiss()
        }
    }
    func sendDataToServer()
    {
        for i in 0 ..< eventData.count{
            
            print("\(eventData[i].operationAction!)")
            
            let postString = "ok=syncFromPhone&Appo_Follow_Up=\(eventData[i].followUp!)&Appo_Follow_Up_Type=\(eventData[i].followUpType!)&description=\(eventData[i].descriptionDetail!)&tdate=\(eventData[i].tithiDate!)&timing=\(eventData[i].timing!)&tithi=\(eventData[i].tithi!)&todate=\(eventData[i].toDate!)&totime=\(eventData[i].toTime!)&update_stamp=\(eventData[i].updateStamp!)&is_sync=\(eventData[i].isSync!)&live_db_id=\(eventData[i].liveDBId!)&opr_action=\(eventData[i].operationAction!)"
            print(postString)
            Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
                
                DispatchQueue.main.async {
                    
                    print("After Queue Response : \(response)")
                    let json = JSON(data: response.data!)
                    let liveDBId = json["live_db_id"].stringValue
                    
                    print(liveDBId)
                    var event : Event!
                    
                    var strDeleteUpdate = "u"
                    let strDorNot = "\(self.eventData[i].operationAction!)"
                    if strDorNot == "d" {
                        strDeleteUpdate = "d"
                    }
                    
                    event = Event(eventID: self.eventData[i].eventID, followUp: self.eventData[i].followUp, followUpType: self.eventData[i].followUpType, descriptionDetail: self.eventData[i].descriptionDetail, tithiDate: self.eventData[i].tithiDate, timing: self.eventData[i].timing, tithi: self.eventData[i].tithi, toDate: self.eventData[i].toDate, toTime: self.eventData[i].toTime,updateStamp: "", isSync: "1", liveDBId: liveDBId, operationAction: strDeleteUpdate)
                    DBManager.shared.updateEvent(withID: Int(self.eventData[i].eventID)!, data: event)
                    
                }
            }
        }
        getDataFromServer()
    }
    func getDataFromServer()
    {
            Alamofire.request("http://guruji.krishnapranami.org/web_services/index.php?ok=syncFromServer", method: .post, parameters: [:], encoding: "", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
                
                DispatchQueue.main.async {
                    
                    print("After Queue Response : \(response)")
                    let json = JSON(data: response.data!)
                    
                    for i in 0 ..< json["all_data"].count{
                    
                    let description = json["all_data"][i]["description"].stringValue
                    let timing = json["all_data"][i]["timing"].stringValue
                    let Appo_Follow_Up = json["all_data"][i]["Appo_Follow_Up"].stringValue
                    let todate = json["all_data"][i]["todate"].stringValue
                    let Appo_Follow_Up_Type = json["all_data"][i]["Appo_Follow_Up_Type"].stringValue
                    let tithi = json["all_data"][i]["tithi"].stringValue
                    let tDate = json["all_data"][i]["tdate"].stringValue
                    let totime = json["all_data"][i]["totime"].stringValue
                    let live_db_id = json["all_data"][i]["id"].stringValue
                    
                    var event : Event!
                    event = Event(eventID: "", followUp: Appo_Follow_Up, followUpType: Appo_Follow_Up_Type, descriptionDetail: description, tithiDate: tDate, timing: timing, tithi: tithi, toDate: todate, toTime: totime,updateStamp: "", isSync: "1", liveDBId: live_db_id, operationAction: "i")
                    DBManager.shared.insertData(data: event)
                }
            }
        }
        self.syncServerIds()
    }
    func syncServerIds(){
        
        for i in 0 ..< eventData.count {
            
            let postString = "ok=syncServerId&id=\(eventData[i].eventID!)&live_db_id=\(eventData[i].liveDBId!)"
            print(postString)
            Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                print("After Queue Response : \(response)")
                let json = JSON(data: response.data!)
                print(json)
                }
            }
            
        }
        dissmiss()
    }
    func dissmiss(){
       // backBtn.isHidden = true

        let alert = UIAlertController(title: "Sync", message: "Syncing data with server is done....", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "backToHome", sender: self)
            })
        })
        )
    }
}
