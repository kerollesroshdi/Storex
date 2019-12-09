//
//  SignInViewModel.swift
//  Storex
//
//  Created by admin on 12/4/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class SignInViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let accessToken: PublishSubject<String> = PublishSubject()
    
    let customersProvider: MoyaProvider<CustomersService>
    
    init(customersProvider: MoyaProvider<CustomersService> = MoyaProvider<CustomersService>()) {
        self.customersProvider = customersProvider
    }
    
    func signIn(email: String, password: String) {
        state.onNext(.loading)
        customersProvider.request(.login(email: email, password: password)) { [weak self] (result) in
            switch result {
                
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    print("Logged in successfully")
                    do {
                        let response = try decoder.decode(ApiCustomer.self, from: response.data)
                        // pass token
                        print(response)
                        self?.accessToken.onNext(response.accessToken)
                        self?.state.onNext(.success)
                    } catch {
                        print("response decoding error: \(error)")
                        self?.state.onNext(.error)
                    }
                } else if response.statusCode == 400 {
                    print("Login Error")
                    guard let error = try? decoder.decode(ApiError.self, from: response.data) else { return }
                    print(error)
                    self?.state.onNext(.error)
                    self?.errorMessage.onNext(error.error.message)
                }
                
            case .failure(let error):
                self?.errorMessage.onNext(error.localizedDescription)
                
            }
        }
    }
}
