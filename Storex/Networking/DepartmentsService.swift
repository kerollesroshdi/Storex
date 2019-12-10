//
//  DepartmentsService.swift
//  Storex
//
//  Created by admin on 12/10/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum DepartmentsService {
    case getAllDepartments
}

extension DepartmentsService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/departments")!
    }
    
    var path: String {
        switch self {
        case .getAllDepartments:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllDepartments:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getAllDepartments:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
