//
//  Customer.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/21/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation


struct ApiCustomer: Codable{
    let customer: Customer
    let accessToken: String
    let expires_in: String
}

struct Customer: Codable {
    let customer_id: Int
    let name: String
    let email: String
    let address_1: String?
    let address_2: String?
    let city: String?
    let region: String?
    let postal_code: String?
    let country: String?
    let shipping_region_id: Int
    let day_phone: String?
    let eve_phone: String?
    let mob_phone: String?
    let credit_card: String?
}

