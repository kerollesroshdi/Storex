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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
