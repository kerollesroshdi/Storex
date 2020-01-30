//
//  SettingsViewController.swift
//  Storex
//
//  Created by admin on 1/30/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    @IBOutlet weak var formContainerView: UIView!
    @IBOutlet weak var saveSettingsButton: UIButton!
    
    private var settingsFormTableVC: SettingsFormTableVC?
    
    lazy var viewModel: SettingsViewModel = {
        return SettingsViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let settingsform = children.first as? SettingsFormTableVC else {
            fatalError("Couldn't get settings form table vc .. check storyboard")
        }
        settingsFormTableVC = settingsform
        
//        settingsFormTableVC?.nameTextField.text = "Casper"
        
        initView()
        initVM()
    }
    
    private func initView() {
        
        #warning("get data from text fields ... ")
        
        saveSettingsButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.updateAddress(address1: "12 Faisal st.", address2: nil, city: "Talbia", region: "Giza", postalCode: "17432", country: "Egypt")
            })
        .disposed(by: disposeBag)
        
    }
    
    private func initVM() {
        
        viewModel.errorMessage
        .observeOn(MainScheduler.instance)
        .subscribe(onNext:{ message in
            NotificationBannerManager.show(title: "Network Error!", message: message, style: .warning)
        })
        .disposed(by: disposeBag)
        
        
        viewModel.customer
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] customer in
                guard let self = self else { return }
                print("customer: ", customer)
                self.settingsFormTableVC?.customer = customer
            })
            .disposed(by: disposeBag)
        
        viewModel.getCustomer()
    }
    
}
