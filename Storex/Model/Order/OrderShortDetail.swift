//
//  OrderShortDetail.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct OrderShortDetail: Codable {
    let orderID: Int
    let totalAmount: String
    let createdOn: String
    let shippedOn: String?
    let status: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case totalAmount = "total_amount"
        case createdOn = "created_on"
        case shippedOn = "shipped_on"
        
        case status, name
    }
}
