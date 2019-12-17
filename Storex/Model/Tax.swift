//
//  Tax.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Tax: Codable {
    let taxID: Int
    let taxType, taxPercentage: String
    
    enum CodingKeys: String, CodingKey {
        case taxID = "tax_id"
        case taxType = "tax_type"
        case taxPercentage = "tax_percentage"
    }
}
