//
//  CartTotalAmount.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct CartTotalAmount: Codable {
    let totalAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case totalAmount = "total_amount"
    }
}
