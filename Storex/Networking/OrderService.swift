//
//  OrderService.swift
//  Storex
//
//  Created by admin on 1/26/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum OrderService {
    case order(cardID: String, shippingID: Int, taxID: Int)
    case getOrders
}

extension OrderService: TargetType {

    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/orders")!
    }
    
    var path: String {
        switch self {
        case .order:
            return ""
        case .getOrders:
            return "/inCustomer"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .order:
            return .post
        case .getOrders:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .order(let cardID, let shippingID, let taxID):
            return .requestParameters(parameters: ["cart_id" : cardID , "shipping_id" : shippingID, "tax_id" : taxID], encoding: JSONEncoding.default)
        case .getOrders:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let token = UserDefaults.standard.string(forKey: "token")
        return ["Content-type": "application/json" , "USER-KEY" : token!]
    }
    
    
}
