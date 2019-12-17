//
//  TaxService.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum TaxService {
    case getAllTaxes
}

extension TaxService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/tax")!
    }
    
    var path: String {
        switch self {
        case .getAllTaxes:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllTaxes:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getAllTaxes:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    
}
