//
//  SignIn-Up.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/21/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Alamofire

func signIn(email: String, password: String, completionHandler: @escaping (CustomerRegister?, Error?) -> Void){
    Alamofire.request("https://mobilebackend.turing.com/customers/login", method: .post, parameters: ["email" : email, "password" : password ]).responseJSON { (response) in
        
        response.result.ifSuccess {
            
            print("response: \(response)")

            let decoder = JSONDecoder()
            if response.response?.statusCode == 200 {
                do {
                    guard let data = response.data else { return }
                    let customer = try decoder.decode(CustomerRegister.self, from: data)
                    print("Customer: \(customer)" )
                    completionHandler(customer, nil)
                } catch let err {
                    print("DecodingError: \(err)")
                }

            } else if response.response?.statusCode == 400 {
                do {
                    guard let data = response.data else { return }
                    let error = try decoder.decode(Error.self, from: data)
                    print("Error: \(error)")
                    completionHandler(nil, error)
                } catch let err {
                    print("DecodingError: \(err)")
                }
            }
        }
    }
}
