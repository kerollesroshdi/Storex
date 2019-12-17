//
//  Product.swift
//  Storex
//
//  Created by admin on 12/10/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Product: Codable {
    let productID: Int
    let name: String
    let description: String
    let price: String
    let discountedPrice: String
    let thumbnail: String
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case discountedPrice = "discounted_price"
        
        case name, description, price, thumbnail
    }
}
