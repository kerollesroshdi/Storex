//
//  CustomersService.swift
//  Storex
//
//  Created by admin on 12/4/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum CustomersService {
    case login(email: String, password: String)
    case loginWithFb(token: String)
    case register(name: String, email: String, password: String)
    case getCustomer
    case updateAddress(address1: String, address2: String?, city: String, region: String, postalCode: String, country: String, shippingRegionID: Int = 2)
    case updateCreditCard(creditCard: String)
}

extension CustomersService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/customers/login"
        case .loginWithFb:
            return "/customers/facebook"
        case .register:
            return "/customers"
        case .getCustomer:
            return "/customer"
        case .updateAddress:
            return "/customers/address"
        case .updateCreditCard:
            return "/customers/creditCard"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .loginWithFb, .register:
            return .post
        case .getCustomer:
            return .get
        case .updateAddress, .updateCreditCard:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .login(email, password):
            return .requestParameters(parameters: ["email" : email, "password" : password], encoding: JSONEncoding.default)
        case .loginWithFb(let token):
            return .requestParameters(parameters: ["access_token" : token], encoding: JSONEncoding.default)
        case .register(let name, let email, let password):
            return .requestParameters(parameters: ["name" : name, "email" : email, "password" : password], encoding: JSONEncoding.default)
        case .getCustomer:
            return .requestPlain
        case .updateAddress(let address1, let address2, let city, let region, let postalCode, let country, let shippingRegionID):
            return .requestParameters(parameters:
                ["address_1" : address1,
                 "address_2" : address2 ?? NSNull(),
                 "city" : city,
                 "region" : region,
                 "postal_code" : postalCode,
                 "country" : country,
                 "shipping_region_id" : shippingRegionID],
                                      encoding: JSONEncoding.default)
        case .updateCreditCard(let creditCard):
            return .requestParameters(parameters: ["credit_card" : creditCard], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCustomer, .updateAddress, .updateCreditCard:
            let token = UserDefaults.standard.string(forKey: "token")
            return ["Content-type": "application/json" , "USER-KEY" : token!]
        default:
            return ["Content-type" : "application/json"]
        }
    }
    
    
}
