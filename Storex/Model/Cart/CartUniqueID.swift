//
//  CartUniqueID.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct CartUniqueID: Codable {
    let cartID: String
    
    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
    }
}
