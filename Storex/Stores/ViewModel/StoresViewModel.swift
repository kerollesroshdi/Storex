//
//  StoresViewModel.swift
//  Storex
//
//  Created by admin on 1/27/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class StoresViewModel {
    let storeLocationCellViewModels: PublishSubject<[StoreLocationCellViewModel]> = PublishSubject()
    let storesLocation: PublishSubject<[(name: String, location: CLLocation)]> = PublishSubject()
    let storesDetailsViewModels: PublishSubject<[StoreDetailsViewModel]> = PublishSubject()
    
    func getStoresLocation(fromLocation userLocation: CLLocation) {
        
        // MARK:- setting storesLocationsCells :
        
        let storeLocationCellViewModels: [StoreLocationCellViewModel] = storesInfo.map {
            let distance = userLocation.distance(from: $0.location) / 1000.0
            let walkingTime = distance * 60 / 5
            return StoreLocationCellViewModel(name: $0.name, walkingDistance: String(format: "%.0f", walkingTime), distance: String(format: "%.2f", distance))
        }
        
        self.storeLocationCellViewModels.onNext(storeLocationCellViewModels)
    }
    
    func getStoreInfo() {
        
        // MARK:- setting storesLocations coordinate :
        
        let storesLocationsCoordinate: [(name: String, location: CLLocation)] =  storesInfo.map {
            return ($0.name, $0.location)
        }
        
        storesLocation.onNext(storesLocationsCoordinate)
        
        
        // MARK:- setting storesDetails :
        
        let storesDetails: [StoreDetailsViewModel] = storesInfo.map{
            return StoreDetailsViewModel(name: $0.name, address: $0.address, number: $0.number, location: $0.location)
        }
        
        storesDetailsViewModels.onNext(storesDetails)
    }
    
    let storesInfo = [
        StoreInfo(name: "Storex CityStars Mall", address: "Omar Ibn El-Khattab, Masaken Al Mohandesin. Nasr City, Cairo Governorate", number: "01023674218", location: CLLocation(latitude: 30.072979, longitude: 31.34605)),
        StoreInfo(name: "Storex CityCenter Mall", address: "Ring Rd, El-Basatin Sharkeya, El Basatin, Cairo Governorate", number: "01277706902", location: CLLocation(latitude: 30.0034693, longitude: 31.0873205)),
        StoreInfo(name: "Storex Tahrir Square", address: "eltahrir sqair, Cairo Governorate", number: "01023674218", location: CLLocation(latitude: 30.0444145, longitude: 31.2335109))
    ]
    
}

struct StoreInfo {
    let name: String
    let address: String
    let number: String
    let location: CLLocation
}
