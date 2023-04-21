//
//  BirthdayCell.swift
//  Guruji Calendar
//
//  Created by Vivek Goswami on 02/03/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import UIKit

class BirthdayCell: UITableViewCell {
    @IBOutlet weak var titleLbl : UILabel?
    @IBOutlet weak var giftImage : UIImageView?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
