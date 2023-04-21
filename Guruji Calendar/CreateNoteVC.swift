//
//  CreateNoteVC.swift
//  Guruji Calendar
//
//  Created by deepak jain on 29/07/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class CreateNoteVC: UIViewController {
    @IBOutlet var txtNotes: UITextView!
    @IBOutlet var btnSave: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    @IBAction func btnClkSave(_ sender: Any) {
        
        if txtNotes.text == "" {
            return
        }
        
        let Currentdate = app_Delegate.currentDateString()
        print(txtNotes.text)
        print(Currentdate)
        
        var todo : ToDoList!
        
        todo = ToDoList(todoID: "", todoDesc: txtNotes.text!, todoDate: Currentdate, todoStatus: "", todoDbID: "", todoAction: "i", todoisSync: "0")
        DBManager.shared.insertTodoList(data: todo)
        
        
        //let live_db = UserDefaults.standard.value(forKey: "liveDB")
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnDelete(_ sender: Any) {
    }

}
