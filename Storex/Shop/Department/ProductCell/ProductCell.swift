//
//  ProductCell.swift
//  Storex
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import SDWebImage

class ProductCell: UITableViewCell {
  
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var saleView: UIView!
    
    
    
    var productCellViewModel: ProductCellViewModel? {
        didSet {
            // set image with kinsgfisher or sdwebimage
            let imageURL = URL(string: "https://backendapi.turing.com/images/products/")?.appendingPathComponent(productCellViewModel!.thumbnail)
            self.productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.productImageView.sd_setImage(with: imageURL)
            self.nameLabel.text = productCellViewModel?.name
            self.discountedPriceLabel.text = "$\(productCellViewModel!.discountedPrice)"
            if productCellViewModel?.discountedPrice == "0.00" {
                saleView.isHidden = true
                discountedPriceLabel.isHidden = true
                priceLabel.textColor = #colorLiteral(red: 0.1960259676, green: 0.1960259676, blue: 0.1960259676, alpha: 1)
                priceLabel.attributedText = NSAttributedString(string: "$\(productCellViewModel!.price)")
            } else {
                saleView.isHidden = false
                discountedPriceLabel.isHidden = false
                priceLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
                priceLabel.attributedText = NSAttributedString(string: "$\(productCellViewModel!.price)", attributes: [NSAttributedString.Key.strikethroughStyle : 2])
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.productImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
