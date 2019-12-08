//
//  SignInWithFBViewModel.swift
//  Storex
//
//  Created by admin on 12/8/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import FacebookCore
import FacebookLogin

class SignInWithFBViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let token: PublishSubject<String> = PublishSubject()
    
    let customersProvider: MoyaProvider<CustomersService>
    
    init(customersProvider: MoyaProvider<CustomersService> = MoyaProvider<CustomersService>()) {
        self.customersProvider = customersProvider
    }
    
    
    // signin with Facebook:
    func signInWithFb() {
        state.onNext(.loading)
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: [.publicProfile, .email], viewController: nil) {  [weak self] (loginResult) in
            switch loginResult {
            case .success( _, _, let token):
                // call api signin with facebook token
                self?.signInWithFbAPI(token: token.tokenString)
                print("Logged in with FaceBook - Token: \(token.tokenString)")
            case .cancelled:
                self?.state.onNext(.error)
                self?.errorMessage.onNext("Login Cancelled")
            case .failed(_):
                self?.state.onNext(.error)
                self?.errorMessage.onNext("Login Failed, Please try again later")
            }
        }
    }
    
    private func signInWithFbAPI(token: String) {
        customersProvider.request(.loginWithFb(token: token)) { [weak self] (result) in
            switch result {
                
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let response = try decoder.decode(ApiCustomer.self, from: response.data)
                        // pass token :
                        print("response: \(response)")
                        self?.state.onNext(.success)
                    } catch {
                        print("Error decoding response")
                        self?.state.onNext(.error)
                    }
                } else if response.statusCode == 400 {
                    do {
                        let error = try decoder.decode(ApiError.self, from: response.data)
                        self?.state.onNext(.error)
                        self?.errorMessage.onNext(error.error.message)
                    } catch {
                        print("Erro decoding Error")
                        self?.state.onNext(.error)
                    }
                } else {
                    print("Internal server Error Status Code: \(response.statusCode)")
                }
            case .failure(let error):
                self?.errorMessage.onNext(error.localizedDescription)
        
            }
        }
    }
    
}
