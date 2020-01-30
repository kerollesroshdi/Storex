//
//  SettingsViewModel.swift
//  Storex
//
//  Created by admin on 1/30/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class SettingsViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let customer: PublishSubject<Customer> = PublishSubject()
    
    let customerProvider: MoyaProvider<CustomersService>

    init(customerProvider: MoyaProvider<CustomersService> = MoyaProvider<CustomersService>()) {
        self.customerProvider = customerProvider
    }
    
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
                        self.customer.onNext(customer)
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
    
    func updateAddress(address1: String, address2: String?, city: String, region: String, postalCode: String, country: String, shippingRegionID: Int = 2) {
        customerProvider.request(.updateAddress(address1: address1, address2: address2, city: city, region: region, postalCode: postalCode, country: country)) { (result) in
            switch result {
            case .success(let response):
                print("update address response code : \(response.statusCode)")
            case .failure(let error):
                print("update address error : \(error.localizedDescription)")
            }
        }
    }
    
}
