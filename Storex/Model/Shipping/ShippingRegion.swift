//
//  ShippingRegion.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct ShippingRegion: Codable {
    let shippingRegionID: Int
    let shippingRegion: String
    
    enum CodingKeys: String, CodingKey {
        case shippingRegionID = "shipping_region_id"
        case shippingRegion = "shipping_region"
    }
}
