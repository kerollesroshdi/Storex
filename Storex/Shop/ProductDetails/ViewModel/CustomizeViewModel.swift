//
//  CustomizeViewModel.swift
//  Storex
//
//  Created by admin on 12/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class CustomizeViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let sizeCellViewModels: PublishSubject<[SizeCellViewModel]> = PublishSubject()
    let colorCellViewModels: PublishSubject<[ColorCellViewModel]> = PublishSubject()
    
    let attributesProvider: MoyaProvider<AttributesService>
    
    init(attributesProvider: MoyaProvider<AttributesService> = MoyaProvider<AttributesService>()) {
        self.attributesProvider = attributesProvider
    }
    
    func getAttributesInProduct(_ productID: Int) {
        state.onNext(.loading)
        attributesProvider.request(.getAttributesInProduct(productID)) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                        let attributes = try decoder.decode([Attribute].self, from: response.data)
                        // process attributes ...
                        self.processFetchedAttributes(attributes)
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
                self.errorMessage.onNext(error.localizedDescription)
            }
        }
    }
    
    private func processFetchedAttributes(_ attributes: [Attribute]) {
        var sizeCellvms = [SizeCellViewModel]()
        var colorCellvms = [ColorCellViewModel]()
        for attribute in attributes {
            if attribute.attributeName == "Size" {
                sizeCellvms.append(createSizeCellViewModel(attribute))
            } else if attribute.attributeName == "Color" {
                colorCellvms.append(createColorCellViewModel(attribute))
            }
        }
        sizeCellViewModels.onNext(sizeCellvms)
        colorCellViewModels.onNext(colorCellvms)
    }
    
    private func createSizeCellViewModel(_ attribute: Attribute) -> SizeCellViewModel {
        return SizeCellViewModel(size: attribute.attributeValue, id: attribute.attributeValueID)
    }
    
    private func createColorCellViewModel(_ attribute: Attribute) -> ColorCellViewModel {
        let color = StorexColor(rawValue: attribute.attributeValue)?.rgbColor ?? StorexColor.Orange.rgbColor
        return ColorCellViewModel(color: color, id: attribute.attributeValueID)
    }
    
}
