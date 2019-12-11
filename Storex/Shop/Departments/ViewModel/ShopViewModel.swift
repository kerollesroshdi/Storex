//
//  ShopViewModel.swift
//  Storex
//
//  Created by admin on 12/10/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class ShopViewModel {
    
    let state: PublishSubject<State> = PublishSubject()
    let errorMessage: PublishSubject<String> = PublishSubject()
    let departmentCellViewModels: PublishSubject<[DepartmentCellViewModel]> = PublishSubject()
    
    let departmentsProvider: MoyaProvider<DepartmentsService>
    
    init(departmentsProvider: MoyaProvider<DepartmentsService> = MoyaProvider<DepartmentsService>()) {
        self.departmentsProvider = departmentsProvider
    }
    
    func initFetch() {
        state.onNext(.loading)
        departmentsProvider.request(.getAllDepartments) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                if response.statusCode == 200 {
                    do {
                       let departments = try decoder.decode([Department].self, from: response.data)
                        self.processFetchedDepatments(departments: departments)
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
    
    private func processFetchedDepatments(departments: [Department]) {
        var vms = [DepartmentCellViewModel]()
        for department in departments {
            vms.append(createDepartmentCellViewModel(department: department))
        }
        self.departmentCellViewModels.onNext(vms)
    }
    
    private func createDepartmentCellViewModel(department: Department) -> DepartmentCellViewModel {
        let colors: [(red: CGFloat, green: CGFloat, blue: CGFloat)] = [(255, 159, 243), (255, 159, 243), (254, 202, 87), (10, 189, 227), (29, 209, 161), (46, 134, 222), (34, 47, 62), (52, 31, 151), (1, 163, 164)]
        
        return DepartmentCellViewModel(name: department.name.uppercased(), description: department.description, color: colors[department.departmentID], departmentID: department.departmentID)
    }
    
}
