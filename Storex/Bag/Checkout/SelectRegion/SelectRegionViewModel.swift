//
//  SelectRegionViewModel.swift
//  Storex
//
//  Created by admin on 1/26/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class SelectRegionViewModel {
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let shippingRegions: PublishSubject<[ShippingRegion]> = PublishSubject()
    
    let shippingProvider: MoyaProvider<ShippingService>
    
    init(shippingProvider: MoyaProvider<ShippingService> = MoyaProvider<ShippingService>()) {
        self.shippingProvider = shippingProvider
    }
    
    func getShippingRegions() {
        shippingProvider.request(.getAllRegions) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        var regions = try decoder.decode([ShippingRegion].self, from: response.data)
                        regions.removeFirst()
                        self.shippingRegions.onNext(regions)
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
}
