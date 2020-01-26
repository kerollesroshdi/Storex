//
//  SelectShippingTypeViewModel.swift
//  Storex
//
//  Created by admin on 1/26/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class SelectShippingViewModel {
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let shippingTypes: PublishSubject<[ShippingType]> = PublishSubject()
    let orderState: PublishSubject<State> = PublishSubject()
    let orderID: PublishSubject<Int> = PublishSubject()
    
    let shippingProvider: MoyaProvider<ShippingService>
    let orderProvider: MoyaProvider<OrderService>
    
    
    init(shippingProvider: MoyaProvider<ShippingService> = MoyaProvider<ShippingService>(), orderProvider: MoyaProvider<OrderService> = MoyaProvider<OrderService>()) {
        self.shippingProvider = shippingProvider
        self.orderProvider = orderProvider
    }
    
    func getShippingTypes(regionID: Int) {
        shippingProvider.request(.getRegoinTypes(regionID)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let types = try decoder.decode([ShippingType].self, from: response.data)
                        self.shippingTypes.onNext(types)
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
                        print("error getting response: \(error)")
                        self.state.onNext(.error)
                    }
                }
            case .failure(let error):
                self.state.onNext(.error)
                self.errorMessage.onNext(error.localizedDescription)
            }
        }
    }
    
    func order(shippingID: Int, taxID: Int?) {
        self.orderState.onNext(.loading)
        CartManager.cartID { [weak self] (cartID) in
            guard let self = self else { return }
            guard let cartID = cartID else { return }
            self.orderProvider.request(.order(cardID: cartID, shippingID: shippingID, taxID: 2)) { (result) in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    if response.statusCode == 200 {
                        do {
                            let orderID = try decoder.decode(OrderID.self, from: response.data)
                            self.orderID.onNext(orderID.id)
                            self.orderState.onNext(.success)
                        } catch {
                            print("response decoding response: \(error)")
                            self.orderState.onNext(.error)
                        }
                    } else if response.statusCode == 400 {
                        do {
                            let error = try decoder.decode(ApiError.self, from: response.data)
                            self.orderState.onNext(.error)
                            self.errorMessage.onNext(error.error.message)
                        } catch {
                            print("error getting response: \(error)")
                            self.orderState.onNext(.error)
                        }
                    }
                case .failure(let error):
                    self.orderState.onNext(.error)
                    self.errorMessage.onNext(error.localizedDescription)
                }
            }
        }
        
    }
    
}
