//
//  CartProductCell.swift
//  Storex
//
//  Created by admin on 12/18/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import SDWebImage

class CartProductCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var colorAttribute: UIImageView!
    @IBOutlet weak var sizeAttribute: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var cartProductCellViewModel: CartProductCellViewModel? {
        didSet {
            let imageURL = URL(string: "https://backendapi.turing.com/images/products/")?.appendingPathComponent(cartProductCellViewModel!.imageURL)
            self.productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.productImageView.sd_setImage(with: imageURL)
            self.nameLabel.text = cartProductCellViewModel?.name
            self.priceLabel.text = cartProductCellViewModel?.price
            self.sizeAttribute.text = cartProductCellViewModel?.size
            if let color = cartProductCellViewModel?.color {
                self.colorAttribute.tintColor = UIColor(red: CGFloat(color.red/255), green: CGFloat(color.green/255), blue: CGFloat(color.blue/255), alpha: 1)
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
