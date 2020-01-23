//
//  ShoppingCartService.swift
//  Storex
//
//  Created by admin on 12/17/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

enum ShoppingCartService {
    case generateUniqueID
    case addProduct(cartID: String, productID: Int, attributes: String)
    case getProductsInCart(_ cartID: String)
    case getTotalAmountInCart(_ cartID: String)
    case removeProduct(_ itemID: Int)
    case updateProduct(itemID: Int, quantity: Int)
}

extension ShoppingCartService: TargetType {
    var baseURL: URL {
        return URL(string: "https://backendapi.turing.com/shoppingcart")!
    }
    
    var path: String {
        switch self {
        case .generateUniqueID:
            return "/generateUniqueId"
        case .addProduct:
            return "/add"
        case .getProductsInCart(let cartID):
            return "/\(cartID)"
        case .getTotalAmountInCart(let cartID):
            return "/totalAmount/\(cartID)"
        case .removeProduct(let itemID):
            return "removeProduct/\(itemID)"
        case .updateProduct(let itemID, _):
            return "update/\(itemID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .generateUniqueID, .getProductsInCart, .getTotalAmountInCart:
            return .get
        case .addProduct:
            return .post
        case .removeProduct:
            return .delete
        case .updateProduct:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .generateUniqueID, .getProductsInCart, .getTotalAmountInCart, .removeProduct:
            return .requestPlain
        case .addProduct(let cartID, let productID, let attributes):
            return .requestParameters(parameters: ["cart_id" : cartID, "product_id" : productID, "attributes" : attributes], encoding: JSONEncoding.default)
        case .updateProduct(_, let quantity):
            return .requestParameters(parameters: ["quantity" : quantity], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
    
    
}
