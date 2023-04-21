//
//  ListTithiCell.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 23/02/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class ListTithiCell: UITableViewCell {
    @IBOutlet weak var titleLbl : UILabel?
    @IBOutlet weak var alphaLetter : UILabel?
    @IBOutlet weak var timingLbl : UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
