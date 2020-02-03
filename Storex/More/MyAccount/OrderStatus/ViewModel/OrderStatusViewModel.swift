//
//  OrderStatusViewModel.swift
//  Storex
//
//  Created by admin on 2/3/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class OrderStatusViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let orderCellViewModels: PublishSubject<[OrderStatusCellViewModel]> = PublishSubject()
    
    let orderProvider: MoyaProvider<OrderService>
    
    init(orderProvider: MoyaProvider<OrderService> = MoyaProvider<OrderService>()) {
        self.orderProvider = orderProvider
    }
    
    func getOrders() {
        state.onNext(.loading)
        orderProvider.request(.getOrders) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let orders = try decoder.decode([OrderShortDetail].self, from: response.data)
                        self.processFetchedOrders(orders)
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
    
    private func processFetchedOrders(_ orders: [OrderShortDetail]) {
        var vms = [OrderStatusCellViewModel]()
        for order in orders {
            let vm = OrderStatusCellViewModel(orderID: String(order.orderID), orderAmount: order.totalAmount, creationDay: getDay(order.createdOn), creationDate: reformatDate(order.createdOn), status: order.status)
            vms.append(vm)
        }
        orderCellViewModels.onNext(vms)
    }
    
    private func reformatDate(_ date: String) -> String {
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let apiDate = apiDateFormatter.date(from: date)
        
        let appDateFormatter = DateFormatter()
        appDateFormatter.dateFormat = "MMMM dd, yyyy / hh:mm a"
        
        return appDateFormatter.string(from: apiDate!)
    }
    
    private func getDay(_ date: String) -> String {
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let apiDate = apiDateFormatter.date(from: date)
        
        let appDateFormatter = DateFormatter()
        appDateFormatter.dateFormat = "EEEE"
        
        return appDateFormatter.string(from: apiDate!)
    }
    
}
