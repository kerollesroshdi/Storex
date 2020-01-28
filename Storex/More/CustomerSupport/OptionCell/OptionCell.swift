//
//  OptionCell.swift
//  Storex
//
//  Created by admin on 1/28/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
