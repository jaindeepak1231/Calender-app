//
//  ToDoListVC.swift
//  Guruji Calendar
//
//  Created by deepak jain on 29/07/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class ToDoListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton : UIBarButtonItem!
    @IBOutlet var btnCreateNote: UIBarButtonItem!
    @IBOutlet var tblView: UITableView!
    
    var data = [ToDoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        tblView.estimatedRowHeight = 150
        tblView.rowHeight = UITableViewAutomaticDimension
        
        tblView.register(UINib(nibName: "ToDoListTableCell", bundle: nil), forCellReuseIdentifier: "ToDoListTableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = DBManager.shared.loadSelectTodoListByQuery(query: "SELECT * FROM TodoList_table")
        print(data[0].todoDesc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return data.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        //cell.textLabel?.text = TableData[indexPath.row] as? String
//        
//        cell.textLabel?.text = data[indexPath.row].todoDate
//        cell.detailTextLabel?.text = data[indexPath.row].todoDesc
//        
//        
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListTableCell", for: indexPath as IndexPath) as! ToDoListTableCell
            
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
            
        cell.lblDate.text = data[indexPath.row].todoDate
        cell.lblText.text = data[indexPath.row].todoDesc
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnClkCreateNote(_ sender: Any) {
        let objCreate = self.storyboard?.instantiateViewController(withIdentifier: "CreateNoteVC") as! CreateNoteVC
        self.navigationController?.pushViewController(objCreate, animated: true)
        
    }

}





    
