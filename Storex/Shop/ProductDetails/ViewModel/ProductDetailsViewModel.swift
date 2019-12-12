//
//  ProductDetailsViewModel.swift
//  Storex
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class ProductDetailsViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let productDetails: PublishSubject<ProductDetails> = PublishSubject()
    let productImageCellViewModels: PublishSubject<[ProductImageCellViewModel]> = PublishSubject()
    
    let productsProvider: MoyaProvider<ProductsService>
    
    init(productsProvider: MoyaProvider<ProductsService> = MoyaProvider<ProductsService>(/*plugins: [NetworkLoggerPlugin(verbose: true)]*/)) {
        self.productsProvider = productsProvider
    }
    
    func getProductDetails(_ productID: Int) {
        state.onNext(.loading)
        productsProvider.request(.getProductDetails(productID)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let productDetails = try decoder.decode(ProductDetails.self, from: response.data)
                        self.productDetails.onNext(productDetails)
                        self.processFetchedProductDetails(productDetails)
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
    
    private func processFetchedProductDetails(_ productDetails: ProductDetails) {
        var vms = [ProductImageCellViewModel]()
        vms.append(createProductImageCellViewModel(imageURL: productDetails.image))
        vms.append(createProductImageCellViewModel(imageURL: productDetails.image2))
        productImageCellViewModels.onNext(vms)
    }
    
    private func createProductImageCellViewModel(imageURL: String) -> ProductImageCellViewModel {
        return ProductImageCellViewModel(imageURL: imageURL)
    }
}
