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
    let customerID: Int
    let name: String
    let email: String
    let address1: String?
    let address2: String?
    let city: String?
    let region: String?
    let postalCode: String?
    let country: String?
    let shippingRegionID: Int
    let dayPhone: String?
    let evePhone: String?
    let mobPhone: String?
    let creditCard: String?
    
    enum CodingKeys: String, CodingKey {
        case customerID = "customer_id"
        case address1 = "address_1"
        case address2 = "address_2"
        case postalCode = "postal_code"
        case shippingRegionID = "shipping_region_id"
        case dayPhone = "day_phone"
        case evePhone = "eve_phone"
        case mobPhone = "mob_phone"
        case creditCard = "credit_card"
        
        case name, email, city, region, country
    }
}

