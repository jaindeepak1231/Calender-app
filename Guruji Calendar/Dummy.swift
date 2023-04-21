//
//  Dummy.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 19/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import Foundation

//print(postString)
//request.httpBody = postString.data(using: String.Encoding.utf8);
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//let task = URLSession.shared.dataTask(with: request as URLRequest) {
//    data, response, error in
//    
//    if error != nil
//    {
//        print("error=\(error)")
//        return
//    }
//    var err: NSError?
//    
//    let json: Any?
//    do {
//        json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//    }catch let error as NSError {
//        print("json error: \(error.localizedDescription)")
//        json = nil
//    }catch {
//        fatalError()
//    }
//    
//    if let parseJSON : AnyObject = json as AnyObject {
//        let resultValue : NSArray = parseJSON["all_data"] as! NSArray;
//        print("result; \(resultValue)")
//        
//        if err == nil
//        {
//            for i in 0 ..< resultValue.count
//            {
//                
//                if  let obj = resultValue[i] as? NSDictionary
//                {
//                    if let description = obj["description"] as? String
//                    {
//                        if let timing = obj["timing"] as? String
//                        {
//                            self.TableData.append(timing + "   " + description )
//                            self.TableData.sort()
//                            
//                        }
//                    }
//                    
//                }
//                
//            }
//        }
//    }
//    self.do_table_refresh();
//}
//
//task.resume()






//let serviceURL = URL(string: Connection.open.Service)
//let request = NSMutableURLRequest(url:serviceURL!)
//request.httpMethod="POST"
//
//let postString = "ok=listEvent";
//request.httpBody = postString.data(using: String.Encoding.utf8);
//
//let task = URLSession.shared.dataTask(with: request as URLRequest) {
//    data, response, error in
//    
//    if error != nil
//    {
//        print("error=\(error)")
//        return
//    }
//    var err: NSError?
//    
//    let json: Any?
//    do {
//        json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//        
//    }catch let error as NSError {
//        
//        print("json error: \(error.localizedDescription)")
//        json = nil
//        
//    }catch {
//        
//        fatalError()
//    }
//    if let parseJSON: AnyObject = json as AnyObject?{
//        
//        let resultValue:NSArray = parseJSON["all_data"] as! NSArray;
//        print("result; \(resultValue)")
//        
//        if err == nil {
//            for i in 0 ..< resultValue.count {
//                
//                if  let obj = resultValue[i] as? NSDictionary {
//                    
//                    if let Type = obj["Appo_Follow_Up_Type"] as? String {
//                        
//                        if let description = obj["description"] as? String {
//                            
//                            if let id = obj["id"] as? String {
//                                
//                                if let tdate = obj["tdate"] as? String {
//                                    
//                                    if let timing1 = obj["timing"] as? String {
//                                        
//                                        let time = timing1 + "   " + description
//                                        
//                                        if title == time {
//                                            self.maildate = tdate
//                                            
//                                            print("@@@@@@@@@@@@@@@@")
//                                            UserDefaults.standard.setValue(description, forKey: "description1")
//                                            UserDefaults.standard.setValue(id, forKey: "id")
//                                            UserDefaults.standard.setValue(Type, forKey: "Type")
//                                            
//                                            let spldate1 = timing1.characters.split(separator: "-").map(String.init)
//                                            if spldate1.count == 2 {
//                                                UserDefaults.standard.setValue(spldate1[1], forKey: "totiming")
//                                            }
//                                            
//                                            UserDefaults.standard.setValue(spldate1[0], forKey: "timing")
//                                            let newDate1 = tdate
//                                            let spldate = newDate1.characters.split(separator: "-").map(String.init)
//                                            
//                                            let selecteddate = spldate[2] + "-" + spldate[1] + "-" + spldate[0]
//                                            
//                                            
//                                            let monthnum = spldate[1]
//                                            print(selecteddate)
//                                            
//                                            if monthnum == "01"{
//                                                self.ABC = "Jan"
//                                            }
//                                            else if monthnum == "02" {
//                                                self.ABC = "Feb"
//                                            }
//                                            else if monthnum == "03" {
//                                                self.ABC = "Mar"
//                                            }
//                                            else if monthnum == "04" {
//                                                self.ABC = "Apr"
//                                            }
//                                            else if monthnum == "05" {
//                                                self.ABC = "May"
//                                            }
//                                            else if monthnum == "06" {
//                                                self.ABC = "Jun"
//                                            }
//                                            else if monthnum == "07" {
//                                                self.ABC = "Jul"
//                                            }
//                                            else if monthnum == "08" {
//                                                self.ABC = "Aug"
//                                            }
//                                            else if monthnum == "09" {
//                                                self.ABC = "Sep"
//                                            }
//                                            else if monthnum == "10" {
//                                                self.ABC = "Oct"
//                                            }
//                                            else if monthnum == "11" {
//                                                self.ABC = "Nav"
//                                            }
//                                            else if monthnum == "12" {
//                                                self.ABC = "Dec"
//                                            }
//                                            
//                                            let selecteddate1 = spldate[0] + " \(self.ABC)" + " " + spldate[2]
//                                            print(selecteddate1)
//                                            UserDefaults.standard.setValue(selecteddate, forKey: "selecteddate")
//                                            UserDefaults.standard.setValue(selecteddate1, forKey: "selecteddate1")
//                                            UserDefaults.standard.synchronize()
//                                            
//                                            let alert = UIAlertController(title: "\(tdate)", message: "\(time)", preferredStyle: UIAlertControllerStyle.alert)
//                                            
//                                            alert.addAction(UIAlertAction(title: "Invite", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
//                                                print("Invite !!")
//                                                
//                                                let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS" )
//                                                actionSheet.show(in: self.view)
//                                            }))
//                                            
//                                            alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
//                                                print("Done !!")
//                                                self.performSegue(withIdentifier: "Addview", sender: self)
//                                            }))
//                                            
//                                            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDelete))
//                                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
//                                            self.present(alert, animated: true, completion: {
//                                                
//                                                print("completion block")
//                                                self.activityindicator.stopAnimating()
//                                                self.view.isUserInteractionEnabled = true
//                                            })
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//task.resume()
//







//Alamofire.request(Connection.open.Service, method: .post, parameters: [:], encoding: postString, headers: [:]).validate().responseJSON(queue: Connection.queue.utilityQueue) { response in
//    
//    DispatchQueue.main.async {
//        
//        print("After Queue Response : \(response)")
//        
//        let json = JSON(data: response.data!)
//        
//        for i in 0..<json["all_data"].count {
//            
//            let eventType = json["all_data"][i]["description"].stringValue
//            let description = json["all_data"][i]["description"].stringValue
//            let timing = json["all_data"][i]["timing"].stringValue
//            let dateString = json["all_data"][i]["tdate"].stringValue
//            let eventID = json["all_data"][i]["id"].stringValue
//            
//            print("Description : \(description) & Timing : \(timing) : Date : \(dateString) & Event ID : \(eventID)")
//            let time = dateString + "   " + description
//            
//            if title == time
//            {
//                self.maildate = dateString
//                
//                print("@@@@@@@@@@@@@@@@")
//                UserDefaults.standard.setValue(description, forKey: "description1")
//                UserDefaults.standard.setValue(eventID, forKey: "id")
//                UserDefaults.standard.setValue(eventType, forKey: "Type")
//                
//                let spldate1 = dateString.characters.split(separator: "-").map(String.init)
//                if spldate1.count == 2 {
//                    UserDefaults.standard.setValue(spldate1[1], forKey: "totiming")
//                }
//                
//                UserDefaults.standard.setValue(spldate1[0], forKey: "timing")
//                let newDate1 = dateString
//                let spldate = newDate1.characters.split(separator: "-").map(String.init)
//                
//                let selecteddate = spldate[2] + "-" + spldate[1] + "-" + spldate[0]
//                
//                
//                let monthnum = spldate[1]
//                print(selecteddate)
//                
//                if monthnum == "01"{
//                    self.ABC = "Jan"
//                }
//                else if monthnum == "02" {
//                    self.ABC = "Feb"
//                }
//                else if monthnum == "03" {
//                    self.ABC = "Mar"
//                }
//                else if monthnum == "04" {
//                    self.ABC = "Apr"
//                }
//                else if monthnum == "05" {
//                    self.ABC = "May"
//                }
//                else if monthnum == "06" {
//                    self.ABC = "Jun"
//                }
//                else if monthnum == "07" {
//                    self.ABC = "Jul"
//                }
//                else if monthnum == "08" {
//                    self.ABC = "Aug"
//                }
//                else if monthnum == "09" {
//                    self.ABC = "Sep"
//                }
//                else if monthnum == "10" {
//                    self.ABC = "Oct"
//                }
//                else if monthnum == "11" {
//                    self.ABC = "Nav"
//                }
//                else if monthnum == "12" {
//                    self.ABC = "Dec"
//                }
//                
//                let selecteddate1 = spldate[0] + " \(self.ABC)" + " " + spldate[2]
//                print(selecteddate1)
//                UserDefaults.standard.setValue(selecteddate, forKey: "selecteddate")
//                UserDefaults.standard.setValue(selecteddate1, forKey: "selecteddate1")
//                UserDefaults.standard.synchronize()
//                
//                let alert = UIAlertController(title: "\(dateString)", message: "\(time)", preferredStyle: UIAlertControllerStyle.alert)
//                
//                alert.addAction(UIAlertAction(title: "Invite", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
//                    print("Invite !!")
//                    
//                    let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS" )
//                    actionSheet.show(in: self.view)
//                }))
//                
//                alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
//                    print("Done !!")
//                    self.performSegue(withIdentifier: "Addview", sender: self)
//                }))
//                
//                alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler:self.handleDelete))
//                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:self.handleCancel))
//                self.present(alert, animated: true, completion: {
//                    
//                    print("completion block")
//                    self.activityindicator.stopAnimating()
//                    self.view.isUserInteractionEnabled = true
//                })
//            }
//            
//        }
//    }
//}



