//
//  SignUpViewModel.swift
//  Storex
//
//  Created by admin on 12/5/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class SignUpViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let accessToken: PublishSubject<String> = PublishSubject()
    
    let customersProvider: MoyaProvider<CustomersService>
    
    init(customersProvider: MoyaProvider<CustomersService> = MoyaProvider<CustomersService>(/*plugins: [NetworkLoggerPlugin(verbose: true)]*/)) {
        self.customersProvider = customersProvider
    }
    
    func signUp(name: String, email: String, password: String) {
        
        state.onNext(.loading)
        customersProvider.request(.register(name: name, email: email, password: password)) { [weak self] (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let response = try decoder.decode(ApiCustomer.self, from: response.data)
                        print(response)
                        self?.accessToken.onNext(response.accessToken)
                        self?.state.onNext(.success)
                    } catch {
                        print("response decoding error: \(error)")
                        self?.state.onNext(.error)
                    }
                } else if response.statusCode == 400 {
                    print("Sign up Error")
                    self?.state.onNext(.error)
                    guard let error = try? decoder.decode(ApiError.self, from: response.data) else { return }
                    print(error)
                    self?.errorMessage.onNext(error.error.message)
                }
            case .failure(let error):
                self?.errorMessage.onNext(error.localizedDescription)
            }
        }
        
    }
    
}
