//
//  ProductDetails.swift
//  Storex
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct ProductDetails: Codable {
    let productID: Int
    let name, description, price, discountedPrice: String
    let image, image2 : String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case discountedPrice = "discounted_price"
        case image2 = "image_2"
        
        case name, description, price, image
    }
    
}
