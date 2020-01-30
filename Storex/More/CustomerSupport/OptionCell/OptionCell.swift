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
    @IBOutlet weak var iconImageView: UIImageView!
    
    var viewModel: OptionCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            if let subtitle = viewModel?.subtitle {
                subtitleLabel.text = subtitle
                subtitleLabel.isHidden = false
            }
            if let icon = viewModel?.icon {
                iconImageView.image = icon
                iconImageView.isHidden = false
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
