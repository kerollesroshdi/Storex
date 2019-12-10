//
//  Department.swift
//  Storex
//
//  Created by admin on 12/10/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Department: Codable {
    let departmentID: Int
    let name, description: String
    
    enum CodingKeys: String, CodingKey {
        case departmentID = "department_id"
        
        case name, description
    }
}
