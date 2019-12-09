//
//  Error.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/21/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation

struct ApiError: Codable {
    let error: ErrorClass
}

struct ErrorClass: Codable {
    let status: Int
    let code, message, field: String
}


struct ServerError: Codable {
    let error: InternalError
}

struct InternalError: Codable {
    let code: Int
    let message, type: String
}
