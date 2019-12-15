//
//  AttributesService.swift
//  Storex
//
//  Created by admin on 12/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum AttributesService {
    case getAttributesInProduct(_ productID: Int)
}

extension AttributesService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/attributes")!
    }
    
    var path: String {
        switch self {
        case .getAttributesInProduct(let productID):
            return "/inProduct/\(productID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAttributesInProduct:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getAttributesInProduct:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
