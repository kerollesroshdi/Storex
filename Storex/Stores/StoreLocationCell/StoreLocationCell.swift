//
//  StoreLocationCell.swift
//  Storex
//
//  Created by admin on 1/27/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class StoreLocationCell: UITableViewCell {
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var walkingDistanceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceUnitLabel: UILabel!
    
    var storeLocationCellViewModel: StoreLocationCellViewModel? {
        didSet {
            storeNameLabel.text = storeLocationCellViewModel?.name
            walkingDistanceLabel.text = "Walking distance: \(storeLocationCellViewModel?.walkingDistance ?? "--") min"
            distanceLabel.text = storeLocationCellViewModel?.distance
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
        selectedBackgroundView = view
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            [storeNameLabel, walkingDistanceLabel, distanceLabel, distanceUnitLabel].forEach { (label) in
                label?.textColor = UIColor.white
            }
        } else {
            [storeNameLabel, distanceLabel, distanceUnitLabel].forEach { (label) in
                label?.textColor = UIColor.black
            }
            walkingDistanceLabel.textColor = #colorLiteral(red: 0.1960259676, green: 0.1960259676, blue: 0.1960259676, alpha: 1)
        }
    }
    
}
