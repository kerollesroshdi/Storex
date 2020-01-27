//
//  StoresViewModel.swift
//  Storex
//
//  Created by admin on 1/27/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import RxSwift

class StoresViewModel {
    let storeLocationCellViewModels: PublishSubject<[StoreLocationCellViewModel]> = PublishSubject()
    let storesLocation: PublishSubject<[(name: String, latitude: Double, longitude: Double)]> = PublishSubject()
    let storesDetailsViewModels: PublishSubject<[StoreDetailsViewModel]> = PublishSubject()
    
    func getStoresLocation() {
        
        // MARK:- setting storesLocationsCells :
        let storesLocations: [StoreLocationCellViewModel] = [
            StoreLocationCellViewModel(name: "Storex CityStars Mall", walkingDistance: "50", distance: "6.4"),
            StoreLocationCellViewModel(name: "Storex CityCenter Mall", walkingDistance: "30", distance: "4.1"),
            StoreLocationCellViewModel(name: "Storex Tahrir Square", walkingDistance: "20", distance: "3.2"),
//            StoreLocationCellViewModel(name: "Storex CityStars Mall", walkingDistance: "50", distance: "6.4"),
//            StoreLocationCellViewModel(name: "Storex CityCenter Mall", walkingDistance: "30", distance: "4.3"),
        ]
        storeLocationCellViewModels.onNext(storesLocations)
        
        // MARK:- setting storesLocations coordinate :
        let storesLocationsCoordinate: [(name: String, latitude: Double, longitude: Double)] = [
            ("Storex CityStars", 30.072979, 31.34605),
            ("Storex CityCenter", 30.0034693, 31.0873205),
            ("Storex Tahrir", 30.0444145, 31.2335109),
        ]
        storesLocation.onNext(storesLocationsCoordinate)
        
        // MARK:- setting storesDetails :
        let storesDetails = [
            StoreDetailsViewModel(name: "Storex CityStars Mall", address: "Omar Ibn El-Khattab, Masaken Al Mohandesin. Nasr City, Cairo Governorate", number: "01023674218", location: (30.072979, 31.34605)),
            StoreDetailsViewModel(name: "Storex CityCenter Mall", address: "Ring Rd, El-Basatin Sharkeya, El Basatin, Cairo Governorate", number: "01277706902", location: (30.0034693, 31.0873205)),
            StoreDetailsViewModel(name: "Storex Tahrir Square", address: "eltahrir sqair, Cairo Governorate", number: "01023674218", location: (30.0444145, 31.2335109)),
        ]
        storesDetailsViewModels.onNext(storesDetails)
        
    }
}
