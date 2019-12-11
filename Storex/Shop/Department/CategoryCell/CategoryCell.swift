//
//  CategoryCell.swift
//  Storex
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectedColor: UIColor?
    
    var categoryCellViewModel: CategoryCellViewModel? {
        didSet {
            self.nameLabel.text = categoryCellViewModel?.name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
               self.nameLabel.textColor = selectedColor ?? #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            } else {
                self.nameLabel.textColor = #colorLiteral(red: 0.1960259676, green: 0.1960259676, blue: 0.1960259676, alpha: 1)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
