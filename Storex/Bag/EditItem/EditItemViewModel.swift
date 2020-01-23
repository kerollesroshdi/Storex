//
//  EditItemViewModel.swift
//  Storex
//
//  Created by admin on 1/23/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class EditItemViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let message: PublishSubject<String> = PublishSubject()
    
    let shoppingCartProvider: MoyaProvider<ShoppingCartService>
    
    init(shoppingProvider: MoyaProvider<ShoppingCartService> = MoyaProvider<ShoppingCartService>()) {
        self.shoppingCartProvider = shoppingProvider
    }
    
    func updateProduct(itemID: Int, quantity: Int) {
        self.state.onNext(.loading)
        shoppingCartProvider.request(.updateProduct(itemID: itemID, quantity: quantity)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.message.onNext("item updated successfully")
                self.state.onNext(.success)
            case .failure(let error):
                self.message.onNext(error.localizedDescription)
                self.state.onNext(.error)
            }
        }
    }
}
