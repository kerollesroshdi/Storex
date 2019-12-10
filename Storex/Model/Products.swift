//
//  Products.swift
//  Storex
//
//  Created by admin on 12/10/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct Products: Codable {
    let count: Int
    let rows: [Product]
}
