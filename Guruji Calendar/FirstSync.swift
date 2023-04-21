//
//  FirstSync.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 31/03/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class FirstSync: UIViewController {
    var eventData = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    override func viewDidAppear(_ animated: Bool) {
        
        eventData = DBManager.shared.loadEvents()
        let isSync = UserDefaults.standard.bool(forKey: "isSync")
        if(!isSync){
            addTithiForOffline()
        }
    }
    func getDataFromServer()
    {
        let alert = UIAlertController(title: "", message: "Please wait.....", preferredStyle: UIAlertControllerStyle.alert)
        //        self.present(alert, animated: true, completion: nil)
        
        
        let postString = "ok=syncFromServer"
        print(postString)
        Alamofire.request("\(Connection.open.Service)?ok=syncFromServer", method: .post, parameters: [:], encoding: "", headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
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
                    //      let is_sync = json["all_data"][i]["is_sync"].stringValue
                    let live_db_id = json["all_data"][i]["id"].stringValue
                    //      let opr_action = json["all_data"][i]["opr_action"].stringValue
                    
                    
                    var event : Event!
                    event = Event(eventID: "", followUp: Appo_Follow_Up, followUpType: Appo_Follow_Up_Type, descriptionDetail: description, tithiDate: tDate, timing: timing, tithi: tithi, toDate: todate, toTime: totime,updateStamp: "", isSync: "1", liveDBId: live_db_id, operationAction: "i")
                    DBManager.shared.insertData(data: event)
                    
                }
                self.syncServerIds()
                self.dismiss(animated: true, completion: nil)
            }
        }
        //    self.dismiss(animated: true, completion: nil)
        
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
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(true, forKey: "isSync")

    }
    func addTithiForOffline(){
        DBManager.shared.deleteAllEvents()
        let alert = UIAlertController(title: "", message: "Tithi is being downloading for offline use please wait.", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
        
        let postString = "ok=listAllTithi"
        print(postString)
        
        Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
            
            DispatchQueue.main.async {
                
                var tithis : Tithi!
                let json = JSON(data: response.data!)
                for i in 0 ..< json.count{
                    
                    let tithi = json[i]["tithi"].stringValue
                    let vaar = json[i]["vaar"].stringValue
                    let tdate = json[i]["tdate"].stringValue
                    let pmonth = json[i]["p_month"].stringValue
                    let amonth = json[i]["a_month"].stringValue
                    print(tithi)
                    tithis = Tithi(tithiID: "", tithi: tithi, date: tdate, amonth: amonth, pmonth: pmonth, vaar: vaar)
                    DBManager.shared.insertTithi(data: tithis)
                    
                }
                UserDefaults.standard.set(true, forKey: "isTithiStored");
                UserDefaults.standard.synchronize();
                self.dismiss(animated: true, completion: nil)
                print(json)
                self.getDataFromServer()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
