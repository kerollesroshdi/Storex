//
//  SizeCell.swift
//  Storex
//
//  Created by admin on 12/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class SizeCell: UICollectionViewCell {
    @IBOutlet weak var selectedSize: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var sizeCellViewModel: SizeCellViewModel? {
        didSet {
            self.sizeLabel.text = sizeCellViewModel?.size
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectedSize.isHidden = false
                sizeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                selectedSize.isHidden = true
                sizeLabel.textColor = #colorLiteral(red: 0.4280895591, green: 0.4281002283, blue: 0.4280944169, alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
