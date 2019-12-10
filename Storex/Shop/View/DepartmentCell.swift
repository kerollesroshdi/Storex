//
//  DepartmentCell.swift
//  Storex
//
//  Created by admin on 12/10/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class DepartmentCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var departmentCellViewModel: DepartmentCellViewModel? {
        didSet {
            nameLabel.text = departmentCellViewModel?.name
            descriptionLabel.text = departmentCellViewModel?.description
            if let color = departmentCellViewModel?.color {
                self.contentView.backgroundColor = UIColor(red: color.red/255, green: color.green/255, blue: color.blue/255, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
