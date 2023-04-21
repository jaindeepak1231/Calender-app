//
//  ToDoListTableCell.swift
//  Guruji Calendar
//
//  Created by deepak jain on 29/07/2560 BE.
//  Copyright © 2560 BE TriSoft Developers. All rights reserved.
//

import UIKit

class ToDoListTableCell: UITableViewCell {
    
    @IBOutlet weak var lblText : UILabel!
    @IBOutlet weak var lblDate : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
