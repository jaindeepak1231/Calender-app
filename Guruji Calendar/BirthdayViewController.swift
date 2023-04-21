//
//  BirthdayViewController.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 02/03/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit
import Foundation
import Contacts
import ContactsUI
import MessageUI


class BirthdayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
 
        var contacts = [CNContact]()
        var B_string:Array< String > = Array < String >()
        var emaillist:Array< String > = Array < String >()
        var phonenumberlist:Array< String > = Array < String >()
        var emailid = String()
        var phonenum = String()
    
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return B_string.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BirthdayCell
            cell.titleLbl?.text = B_string[indexPath.row]
            return cell
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let cell = tableView.cellForRow(at: indexPath) as! BirthdayCell
            let title = cell.titleLbl?.text
            print(title!)
            let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Send Email", otherButtonTitles: "Send SMS","Call" )
            actionSheet.show(in: self.view)
            
            do {
                if #available(iOS 9.0, *) {
                    let store = CNContactStore()
                    let contacts = try store.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: title!), keysToFetch:[CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor])
                    print(contacts)
                    for contact in contacts{
                        for email in contact.emailAddresses
                        {
                            print(email.value as String)
                            let string = email.value as String
                            emailid = string
                        }
                        let value = String(describing: contact.phoneNumbers[0].value)
                        let start = value.range(of: "digits=")!.upperBound
                        let end = value.characters.index(before: value.endIndex)
                        let number = value.substring(with: (start ..< end))
                        print(number)
                        phonenum = number
                    }
                } else {
                }
            } catch {
                print(error)
            }
        }
        func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
        {
            print("\(buttonIndex)")
            switch (buttonIndex){
            case 0:
                print("Send Email")
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
            case 1:
                print("Cancel")
            case 2:
                print("Send SMS")
                if MFMessageComposeViewController.canSendText() {
                    let messageComposeVC = configuredMessageComposeViewController()
                    present(messageComposeVC, animated: true, completion: nil)
                } else {
                    let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
                    errorAlert.show()
                }
            case 3:
                print("call")
                let url:URL = URL(string: "tel://\(phonenum)")!
                UIApplication.shared.openURL(url)
            default:
                print("Default")
            }
        }
        func configuredMailComposeViewController() -> MFMailComposeViewController {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([emailid])
            mailComposerVC.setSubject("Wish you Happy Birthday")
            mailComposerVC.setMessageBody("", isHTML: false)
            return mailComposerVC
        }
        func showSendMailErrorAlert() {
            let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
            sendMailErrorAlert.show()
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
            messageComposeVC.recipients = [phonenum]
            messageComposeVC.body = "Happy Birthday"
            return messageComposeVC
        }
        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true, completion: nil)
        }
}
