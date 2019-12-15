//
//  Attribute.swift
//  Storex
//
//  Created by admin on 12/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Attribute: Codable {
    let attributeName: String
    let attributeValueID: Int
    let attributeValue: String
    
    enum CodingKeys: String, CodingKey {
        case attributeName = "attribute_name"
        case attributeValueID = "attribute_value_id"
        case attributeValue = "attribute_value"
    }
}
