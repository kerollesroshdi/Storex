//
//  LifeCell.swift
//  Storex
//
//  Created by admin on 2/3/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class LifeCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var hexagonImage: UIImageView!
    
    var lifeArticle: LifeArticle? {
        didSet {
            dateLabel.text = lifeArticle?.date.uppercased()
            titleLabel.text = lifeArticle?.title.uppercased()
            hexagonImage.image = lifeArticle?.image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let mask = UIImageView(image: #imageLiteral(resourceName: "Shape"))
        mask.contentMode = .scaleAspectFit
        mask.frame = hexagonImage.bounds
        hexagonImage.mask = mask
    }

}
