//
//  BagViewModel.swift
//  Storex
//
//  Created by admin on 12/18/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class BagViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let cartProductCellViewModels: PublishSubject<[CartProductCellViewModel]> = PublishSubject()
    let totalAmount: PublishSubject<String> = PublishSubject()
    
    let shoppingCartProvider: MoyaProvider<ShoppingCartService>

    init(shoppingCartProvider: MoyaProvider<ShoppingCartService> = MoyaProvider<ShoppingCartService>()) {
        self.shoppingCartProvider = shoppingCartProvider
    }
    
    func getProductsInCart() {
        
        CartManager.cartID { [weak self] (cartID) in
            guard let self = self else { return }
            guard let cartID = cartID else { return }
            self.shoppingCartProvider.request(.getProductsInCart(cartID)) { (result) in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    if response.statusCode == 200 {
                        do {
                            let products = try decoder.decode([CartProduct].self, from: response.data)
                            // process fetched products:
                            print("fetched products: \(products.count)")
                            if products.count == 0 {
                                self.state.onNext(.error)
                                self.processFetchedCartProducts([])
                            } else {
                                self.processFetchedCartProducts(products)
                                self.state.onNext(.success)
                            }
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
        
    }
    
    func getTotalAmountInCart() {
        CartManager.cartID { [weak self] (cartID) in
            guard let self = self else { return }
            guard let cartID = cartID else { return }
            self.shoppingCartProvider.request(.getTotalAmountInCart(cartID)) { (result) in
                switch result {
                case .success(let response):
                    let decoder = JSONDecoder()
                    if response.statusCode == 200 {
                        do {
                            let totalAmount = try decoder.decode(CartTotalAmount.self, from: response.data)
                            self.totalAmount.onNext("$\(totalAmount.totalAmount ?? "00.00")")
                        } catch {
                            print("response decoding response: \(error)")
                        }
                    } else if response.statusCode == 400 {
                        do {
                            let error = try decoder.decode(ApiError.self, from: response.data)
                            print("error getting totalAmount : \(error)")
                        } catch {
                            print("error decoding error: \(error)")
                        }
                    }
                case .failure(let error):
                     print("error getting totalAmount : \(error)")
                }
            }
        }
    }
    
    private func processFetchedCartProducts(_ products: [CartProduct]) {
        var vms = [CartProductCellViewModel]()
        for product in products {
            vms.append(createCartProductCellViewModel(product))
        }
        cartProductCellViewModels.onNext(vms)
    }
    
    private func createCartProductCellViewModel(_ product: CartProduct) -> CartProductCellViewModel {
        let attributes = product.attributes.split(separator: ",")
        let color = StorexColor(rawValue: String(attributes[1]).trimmingCharacters(in: .whitespacesAndNewlines))?.rgbColor ?? StorexColor.Blue.rgbColor
        let size = String(attributes[0])
        return CartProductCellViewModel(productID: product.productID, itemID: product.itemID, imageURL: product.image, name: product.name, price: product.price, color: color, size: size, quantity: product.quantity)
    }
    
    func removeProduct(itemID: Int) {
        shoppingCartProvider.request(.removeProduct(itemID)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                print(response.statusCode)
                self.getProductsInCart()
                self.getTotalAmountInCart()
            case .failure(let error):
                self.errorMessage.onNext(error.localizedDescription)
            }
        }
    }
    
}
