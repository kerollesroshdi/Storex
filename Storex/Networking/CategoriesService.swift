//
//  CategoriesService.swift
//  Storex
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum CategoriesService {
    case getCategoriesInDepartment(_ department: Int)
}

extension CategoriesService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/categories")!
    }
    
    var path: String {
        switch self {
        case .getCategoriesInDepartment(let department):
            return "/inDepartment/\(department)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCategoriesInDepartment:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getCategoriesInDepartment:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
