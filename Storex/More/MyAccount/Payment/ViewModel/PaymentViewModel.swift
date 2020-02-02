//
//  PaymentViewModel.swift
//  Storex
//
//  Created by admin on 2/2/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class PaymentViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let message: PublishSubject<String> = PublishSubject()
    let creditCard = BehaviorSubject<String?>(value: "")
    
    let customerProvider: MoyaProvider<CustomersService>
    
    init(customerProvider: MoyaProvider<CustomersService> = MoyaProvider<CustomersService>()) {
        self.customerProvider = customerProvider
    }
    
    lazy var creditCardValid = creditCard.map { $0?.count ?? 0 == 16}.share(replay: 1)
    
    func getCustomer() {
        state.onNext(.loading)
        customerProvider.request(.getCustomer) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let customer = try decoder.decode(Customer.self, from: response.data)
                        self.creditCard.onNext(customer.creditCard ?? "")
                        self.state.onNext(.success)
                    } catch {
                        print("response decoding response: \(error)")
                        self.state.onNext(.error)
                    }
                } else if response.statusCode == 400 {
                    do {
                        let error = try decoder.decode(ApiError.self, from: response.data)
                        self.state.onNext(.error)
                        self.errorMessage.onNext(error.error.message)
                    } catch {
                        print("error decoding error: \(error)")
                        self.state.onNext(.error)
                    }
                }
            case .failure(let error):
                self.state.onNext(.error)
                self.errorMessage.onNext(error.localizedDescription)
            }
        }
    }
    
    func updateCreditCard() {
        guard let creditCard = try? creditCard.value() else { return }
        state.onNext(.loading)
        customerProvider.request(.updateCreditCard(creditCard: creditCard)) { (result) in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    self.state.onNext(.success)
                    self.message.onNext("Informations saved successfully")
                    
                } else if response.statusCode == 400 {
                    do {
                        let error = try decoder.decode(ApiError.self, from: response.data)
                        self.state.onNext(.error)
                        self.errorMessage.onNext(error.error.message)
                    } catch {
                        print("error decoding error: \(error)")
                        self.state.onNext(.error)
                    }
                } else {
                    self.state.onNext(.error)
                    self.errorMessage.onNext("connection failed")
                }
            case .failure(let error):
                self.state.onNext(.error)
                self.errorMessage.onNext(error.localizedDescription)
            }
        }
    }
    
}
