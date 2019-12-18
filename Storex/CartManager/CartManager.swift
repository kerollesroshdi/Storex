//
//  CartManager.swift
//  Storex
//
//  Created by admin on 12/18/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya

class CartManager {
    
    static let shoppingCartProvider = MoyaProvider<ShoppingCartService>()
    
    static func cartID(completion: @escaping (_ cartID: String?) -> Void) {
        
        let cartID = UserDefaults.standard.string(forKey: "cartID")
        
        if let cartID = cartID {
            completion(cartID)
        } else {
            getNewCartID { (cartID) in
                UserDefaults.standard.set(cartID, forKey: "cartID")
                completion(cartID)
            }
        }
    }
    
    static func updateCartID() {
        getNewCartID { (cartID) in
            UserDefaults.standard.set(cartID, forKey: "cartID")
        }
    }
    
    static func getNewCartID(completion: @escaping (_ cartID: String?) -> Void) {
        
        shoppingCartProvider.request(.generateUniqueID) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let response = try decoder.decode(CartUniqueID.self, from: response.data)
                        completion(response.cartID)
                    } catch {
                        print("error decoding response \(error)")
                    }
                } else if response.statusCode == 400 {
                    completion(nil)
                    do {
                        let error = try decoder.decode(ApiError.self, from: response.data)
                        print("error getting unique cartID: \(error)")
                    } catch {
                        print("error decoding error: \(error)")
                    }
                }
            case .failure(let error):
                print("error getting unique cartID: \(error.localizedDescription)")
                completion(nil)
            }

        }
    }
    
}
    

