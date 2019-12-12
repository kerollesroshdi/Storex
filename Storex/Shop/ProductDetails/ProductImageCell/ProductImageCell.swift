//
//  ProductImageCell.swift
//  Storex
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import SDWebImage

class ProductImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var productImageCellViewModel: ProductImageCellViewModel? {
        didSet {
            let imageURL = URL(string: "https://backendapi.turing.com/images/products/")?.appendingPathComponent(productImageCellViewModel!.imageURL)
            self.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.imageView.sd_setImage(with: imageURL)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
