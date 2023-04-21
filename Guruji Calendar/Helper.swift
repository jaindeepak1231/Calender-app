//
//  Helper.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 11/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import Foundation

extension UITextField
{
    func setBottomBorder() {
        
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red:0.00, green:0.75, blue:0.87, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension UITextView
{
    func setBottomBorder() {

        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(red:0.00, green:0.75, blue:0.87, alpha:1.0).cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

extension UIButton {
    func roundedButton(){
        let button = UIButton()
        button.layer.cornerRadius = button.frame.size.height / 2
        button.clipsToBounds = true
        
    }
}
extension UITextField {
    func textFieldBorderSet (){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        let textField = UITextField()
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: (textField.frame.size.height) - width, width:  (textField.frame.size.width), height: (textField.frame.size.height))
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
    
}
