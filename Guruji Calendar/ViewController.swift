//
//  ViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 02/04/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var evenData = [Tithi]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        

        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let startOfMonth = Calendar.current.date(from: comp)!
        print(dateFormatter.string(from: startOfMonth))
        
        
        
        var comps2 = DateComponents()
        comps2.month = 1
        comps2.day = -1
        
        let endOfMonth = Calendar.current.date(byAdding: comps2, to: startOfMonth)
        print(dateFormatter.string(from: endOfMonth!))
        
        let dateGetStart = dateFormatter.string(from: startOfMonth)
        let dateGetEnd = dateFormatter.string(from: endOfMonth!)
        
        var data = [Tithi]()
        let startDates: Date = dateFormatter.date(from: dateGetStart)!
        let endDates: Date = dateFormatter.date(from: dateGetEnd)!
        
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

        
        data = DBManager.shared.loadSelectTithiByQuery(query: "SELECT * FROM Tithi_table WHERE tdate BETWEEN '\(dateGetStart)' AND '\(dateGetEnd)' ORDER BY tdate")
        
        for i in 0 ..< data.count {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formatedDate = dateFormatter.date(from: data[i].date!)
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let dateGetStart = dateFormatter.string(from: formatedDate!)
            let tithi = "\(dateGetStart) \(data[i].pmonth!) \(data[i].tithi!)  \(data[i].vaar!)"
            
            
            var event = [Event]()
            event = DBManager.shared.loadEventsWithParam(queryString: "tdate='\(data[i].date!)'")
            
            if event.count > 0 {
                for j in 0 ..< event.count{
                    print(event[j].eventID)
                    print("\(event[j].descriptionDetail!)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
