//
//  ShippingService.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum ShippingService {
    case getAllRegions
    case getRegoinTypes(_ regionID: Int)
}

extension ShippingService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/shipping")!
    }
    
    var path: String {
        switch self {
        case .getAllRegions:
            return "/regions"
        case .getRegoinTypes(let regionID):
            return "/regions/\(regionID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllRegions, .getRegoinTypes:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getAllRegions, .getRegoinTypes:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
