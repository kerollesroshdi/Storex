//
//  Category.swift
//  Storex
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Category: Codable {
    let categoryID, departmentID: Int
    let name, description: String
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "category_id"
        case departmentID = "department_id"
        
        case name, description
    }
}
