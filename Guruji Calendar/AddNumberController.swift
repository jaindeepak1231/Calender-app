//
//  AddNumberController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 13/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class AddNumberController: UIViewController {
    
    @IBOutlet weak var lblContactname: UILabel!
    var selected_number = NSMutableArray()
    var labelArray = NSMutableArray()
    var _number = NSMutableArray()
    var checked = [Bool]()
    var contactname = String()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        print("Select \(selected_number)")
        lblContactname.text = contactname
        UIApplication.shared.delegate?.window!!.rootViewController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selected_number.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = selected_number[indexPath.row] as? String
//        cell.detailTextLabel?.text = labelArray[indexPath.row] as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        
        print("not checked")
        
        let cell = tableView.cellForRow(at: indexPath)
        let value = cell?.textLabel?.text
        print("Valll :\(value!)")
        
        calclick.selectednumber.add(value!)
        
        if calclick.invite_click == 1
        {
            calclick.num_name_data.add("\(value!)")
        }
        else{
            calclick.num_name_data.add("\(contactname) : \(value!)")
        }
        print("checked")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
        print("not checked")
        
        let cell = tableView.cellForRow(at: indexPath)
        let value = cell?.textLabel?.text
        print(value!)
        
        let index = calclick.selectednumber.index(of: value!)
        calclick.selectednumber.removeObject(at: index)
        calclick.num_name_data.removeObject(at: index)
        
    }

    @IBAction func close () {
        self.dismiss(animated: true, completion: nil)
        selected_number.removeAllObjects()
    }
    @IBAction func done (_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        selected_number.removeAllObjects()
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
