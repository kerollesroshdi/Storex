//
//  SettingsFormViewModel.swift
//  Storex
//
//  Created by admin on 2/2/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import RxSwift

class SettingsFormViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    
    let name = BehaviorSubject<String?>(value: "")
    let address1 = BehaviorSubject<String?>(value: "")
    let address2 = BehaviorSubject<String?>(value: "")
    let city = BehaviorSubject<String?>(value: "")
    let region = BehaviorSubject<String?>(value: "")
    let postalcode = BehaviorSubject<String?>(value: "")
    let country = BehaviorSubject<String?>(value: "")
    
    var customer: Customer? {
        didSet {
            name.onNext(customer!.name)
            address1.onNext(customer?.address1 ?? "")
            address2.onNext(customer?.address2 ?? "")
            city.onNext(customer?.city ?? "")
            region.onNext(customer?.region ?? "")
            postalcode.onNext(customer?.postalCode ?? "")
            country.onNext(customer?.country ?? "")
        }
    }
    
    lazy var nameValid = name.map { $0?.count ?? 0 >= 4 }.share(replay: 1)
    
    lazy var address1Valid = address1.map{ $0?.count ?? 0 >= 10 }.share(replay: 1)
    
    lazy var cityValid = city.map{ $0?.count ?? 0 >= 3 }.share(replay: 1)
    
    lazy var stateValid = region.map{ $0?.count ?? 0 >= 3 }.share(replay: 1)
    
    lazy var zipcodeValid = postalcode.map{ isValidZipCode(value: $0 ?? "" ) }.share(replay: 1)
    
    lazy var countryValid = country.map{ $0?.count ?? 0 >= 3 }.share(replay: 1)
    
    lazy var allValid = Observable.combineLatest(nameValid, address1Valid, cityValid, stateValid, zipcodeValid, countryValid) { $0 && $1 && $2 && $3 && $4 && $5 }
        .share(replay: 1)
    
}


func isValidZipCode(value: String) -> Bool {
    let ZIPCODE_REGEX = "^[0-9]{5}$"
    let zipcodeTest = NSPredicate(format: "SELF MATCHES %@", ZIPCODE_REGEX)
    let result = zipcodeTest.evaluate(with: value)
    return result
}
