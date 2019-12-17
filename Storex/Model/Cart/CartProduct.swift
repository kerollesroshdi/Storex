//
//  CartProduct.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct CartProduct: Codable {
    let itemID, productID: Int
    let name, attributes: String
    let price, subtotal: String
    let quantity: Int
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case itemID = "item_id"
        case productID = "product_id"
        
        case name, attributes, price, subtotal, quantity, image
    }
}
