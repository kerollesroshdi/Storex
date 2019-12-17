//
//  ProductsService.swift
//  Storex
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum ProductsService {
    case getProductsInDepartment(_ department: Int, page: Int)
    case getProductsInCategory(_ category: Int, page: Int)
    case getProductDetails(_ productID: Int)
}

extension ProductsService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/products")!
    }
    
    var path: String {
        switch self {
        case .getProductsInDepartment(let department, _):
            return "/inDepartment/\(department)"
        case .getProductsInCategory(let category, _):
            return "/inCategory/\(category)"
        case .getProductDetails(let productID):
            return "/\(productID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProductsInDepartment, .getProductsInCategory, .getProductDetails:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getProductsInDepartment(_, let page), .getProductsInCategory(_, let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        case .getProductDetails(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    
}
