//
//  FashionCell.swift
//  Storex
//
//  Created by admin on 2/4/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class FashionCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var fashionArticle: FashionArticle? {
        didSet {
            image.image = fashionArticle?.image
            titleLabel.text = fashionArticle?.title.uppercased()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let mask = UIImageView(image: #imageLiteral(resourceName: "Shape"))
        mask.contentMode = .scaleAspectFit
        mask.frame = image.bounds
        image.mask = mask
    }

}
