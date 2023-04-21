//
//  AddInviteesController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 13/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI
@available(iOS 9.0, *)

class AddInviteesController : UIViewController,CNContactPickerDelegate,UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var contactListTable: UITableView!
    
    var TableData = NSMutableArray()
    var data = NSMutableArray()
    var selected_number = NSMutableArray()
    var selected_number1 = NSMutableArray()
    var maildata = String()
    var discription = String()
    var time = String()
    var maildiscription = String()
    var contactname = String()
    var abc = Int()
    var labelArray = NSMutableArray()
    var contacts = [CNContact]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func openContactList (_ sender: AnyObject) {
            if calclick.invite_click == 1
            {
                let contactPicker = CNContactPickerViewController()
                contactPicker.delegate = self
                contactPicker.displayedPropertyKeys =
                    [CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey]
                self.present(contactPicker, animated: true, completion: nil)
            }
            else
            {
                let pick = CNContactPickerViewController()
                pick.displayedPropertyKeys = [CNContactPhoneNumbersKey]
                pick.delegate = self
                present(pick, animated: true, completion: nil)
            }
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact)
    {
        if calclick.invite_click == 1
        {
            for email in contact.emailAddresses
            {
                print(email.value as String)
                let string = email.value as String
                TableData.add(string)
                print(TableData)
            }
        }
        else
        {
            selected_number1.removeAllObjects()
            
            for number in contact.phoneNumbers {
            
                let phoneNumber = number.value
                print("number is = \(phoneNumber)")
                
                let formatter = CNContactFormatter()
                formatter.style = .fullName
                contactname = formatter.string(from: contact)!
                
                let name = number.label
                print(contactname)
                
                labelArray.add(name!)
                selected_number1.add(phoneNumber)
            }
            abc = selected_number1.count - 1
            if selected_number1.count > 1
            {
                for _ in selected_number1
                {
                    let value = String(describing: contact.phoneNumbers[abc].value)
                    let start = value.range(of: "digits=")!.upperBound
                    let end = value.characters.index(before: value.endIndex)
                    let number = value.substring(with: (start ..< end))
                    selected_number.add(number)
                    abc = abc - 1
                }
                DispatchQueue.main.async(execute: {
                    self.performSegue(withIdentifier: "selectNumber", sender: self)
                    calclick.num_name_data.removeAllObjects()
                    calclick.selectednumber.removeAllObjects()
                })
            }
            else
            {
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value
                    print("number is = \(phoneNumber)")
                    let formatter = CNContactFormatter()
                    formatter.style = .fullName
                    let a = formatter.string(from: contact)
                    let value = String(describing: contact.phoneNumbers[0].value)
                    let start = value.range(of: "digits=")!.upperBound
                    let end = value.characters.index(before: value.endIndex)
                    let number = value.substring(with: (start ..< end))
                    let abc = "\(a!) : \(number)"
                    TableData.add(abc)
                    data.add(number)
                }
            }
        }
        self.reloadTableData()
    }
    override func viewDidAppear(_ animated: Bool) {
        if calclick.select_number_page == 1
        {
            data.addObjects(from: calclick.selectednumber as [AnyObject])
            TableData.addObjects(from: calclick.num_name_data as [AnyObject])
            
            self.reloadTableData()
            selected_number1.removeAllObjects()
            calclick.select_number_page = 0
        }
    }
    @IBAction func Cancelbutton(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Donebutton(_ sender: AnyObject) {
        if calclick.invite_click == 1
        {
            let mailComposeViewController = configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        else
        {
            if MFMessageComposeViewController.canSendText() {
                let messageComposeVC = configuredMessageComposeViewController()
                present(messageComposeVC, animated: true, completion: nil)
            } else {
                
                let alert = UIAlertController(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", preferredStyle: UIAlertControllerStyle.alert)
                
                self.present(alert, animated: true, completion: nil)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                }))
            }
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(TableData as AnyObject! as! NSArray as? [String])
        mailComposerVC.setSubject("Navtanpuri Dham-Meeting Invitation")
        mailComposerVC.setMessageBody("\(maildiscription)", isHTML: false)
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        
        let alert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        self.present(alert, animated: true, completion: nil)

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
        }))
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        controller.dismiss(animated: true, completion: nil)
    }
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = data as AnyObject! as! NSArray as? [String]
        messageComposeVC.body = "\(maildiscription)"
        return messageComposeVC
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = TableData[indexPath.row] as? String
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            if calclick.invite_click == 1
            {
                TableData.removeObject(at: indexPath.row)
            }
            else if calclick.invite_click == 0
            {
                TableData.removeObject(at: indexPath.row)
                data.removeObject(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    func reloadTableData()
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.contactListTable.reloadData()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "selectNumber")
        {
            let destiVC = segue.destination as! AddNumberController
            destiVC.modalPresentationStyle = UIModalPresentationStyle.formSheet
            destiVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            UIApplication.shared.keyWindow?.rootViewController!.present(destiVC, animated: true, completion: nil)
            destiVC.selected_number = selected_number
            destiVC.contactname = contactname
            destiVC.labelArray = labelArray
        }
    }
    @IBAction func close () {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
