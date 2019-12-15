//
//  ColorCell.swift
//  Storex
//
//  Created by admin on 12/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class ColorCell: UICollectionViewCell {
    @IBOutlet weak var selectedColor: UIImageView!
    @IBOutlet weak var colorImageView: UIImageView!
    
    var colorCellViewModel: ColorCellViewModel? {
        didSet {
            if let color = colorCellViewModel?.color {
                self.colorImageView.tintColor = UIColor(red: CGFloat(color.red/255), green: CGFloat(color.green/255), blue: CGFloat(color.blue/255), alpha: 1)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
