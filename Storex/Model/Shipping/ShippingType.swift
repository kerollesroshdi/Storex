//
//  ShippingType.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct ShippingType: Codable {
    let shippingID, shippingRegionID: Int
    let shippingType, shippingCost: String
    
    enum CodingKeys: String, CodingKey {
        case shippingID = "shipping_id"
        case shippingType = "shipping_type"
        case shippingCost = "shipping_cost"
        case shippingRegionID = "shipping_region_id"
    }
}
