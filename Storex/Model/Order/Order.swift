//
//  Order.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Order: Codable {
    let orderID, productID: Int
    let productName, attributes: String
    let quantity: Int
    let unitCost, subtotal: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case productID = "product_id"
        case productName = "product_name"
        case unitCost = "unit_cost"
        
        case attributes, quantity, subtotal
    }
}

struct OrderID: Codable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "orderId"
    }
}
