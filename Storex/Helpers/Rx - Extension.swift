//
//  Rx - Extension.swift
//  Storex
//
//  Created by admin on 2/2/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <->

@discardableResult func <-><T>(property: ControlProperty<T>, variable: BehaviorSubject<T>) -> Disposable {
    let variableToProperty = variable.asObservable()
        .bind(to: property)

    let propertyToVariable = property
        .subscribe(
            onNext: { variable.onNext($0) },
            onCompleted: { variableToProperty.dispose() }
    )

    return Disposables.create(variableToProperty, propertyToVariable)
}
