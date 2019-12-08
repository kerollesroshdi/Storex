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
}

extension CustomersService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/customers")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .loginWithFb:
            return "/facebook"
        case .register:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .loginWithFb, .register:
            return .post
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
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
