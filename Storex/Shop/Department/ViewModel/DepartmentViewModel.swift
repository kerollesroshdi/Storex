//
//  DepartmentViewModel.swift
//  Storex
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class DepartmentViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let categoryCellViewModels: PublishSubject<[CategoryCellViewModel]> = PublishSubject()
    let productCellViewModels: PublishSubject<[ProductCellViewModel]> = PublishSubject()
    
    
    let categoriesProvider: MoyaProvider<CategoriesService>
    let productsProvider: MoyaProvider<ProductsService>
    
    init(categoriesProvider: MoyaProvider<CategoriesService> = MoyaProvider<CategoriesService>(), productsProvider: MoyaProvider<ProductsService> = MoyaProvider<ProductsService>()) {
        self.categoriesProvider = categoriesProvider
        self.productsProvider = productsProvider
    }
    
    func categoriesFetch(departmentID: Int) {
        state.onNext(.loading)
        categoriesProvider.request(.getCategoriesInDepartment(departmentID)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let categories = try decoder.decode([Category].self, from: response.data)
                        self.processFetchedCategories(categories)
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
    
    private func processFetchedCategories(_ categories: [Category]) {
        var vms = [CategoryCellViewModel]()
        vms.append(CategoryCellViewModel(name: "All Products", id: 0))
        for category in categories {
            vms.append(createCategoryCellViewModel(category))
        }
        self.categoryCellViewModels.onNext(vms)
    }
    
    private func createCategoryCellViewModel(_ category: Category) -> CategoryCellViewModel {
        return CategoryCellViewModel(name: category.name, id: category.categoryID)
    }
    
    func productsInDepartmentFetch(departmentID: Int, page: Int) {
        self.state.onNext(.loading)
        productsProvider.request(.getProductsInDepartment(departmentID, page: page)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let products = try decoder.decode(Products.self, from: response.data)
                        self.processFetchedProducts(products)
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
    
    private func processFetchedProducts(_ products: Products) {
        var vms = [ProductCellViewModel]()
        for product in products.rows {
            vms.append(createProductCellViewModel(product))
        }
        self.productCellViewModels.onNext(vms)
    }
    
    private func createProductCellViewModel(_ product: Product) -> ProductCellViewModel {
        return ProductCellViewModel(productID: product.productID, name: product.name, price: product.price, discountedPrice: product.discountedPrice, thumbnail: product.thumbnail)
    }
    
}
