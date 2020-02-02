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
    @IBOutlet weak var loadingView: UIView!
    
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
        
        initView()
        initVM()
    }
    
    private func initView() {
        
        settingsFormTableVC?.viewModel.allValid
            .bind(to: saveSettingsButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        settingsFormTableVC?.viewModel.allValid
            .map{ $0 == true ? 1 : 0.5 }
            .bind(to: saveSettingsButton.rx.alpha)
            .disposed(by: disposeBag)
        
        
        saveSettingsButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let viewModel = self.settingsFormTableVC?.viewModel else { return }
                guard let address1 = try? viewModel.address1.value(),
                    let address2 = try? viewModel.address2.value(),
                    let city = try? viewModel.city.value(),
                    let region = try? viewModel.region.value(),
                    let postalcode = try? viewModel.postalcode.value(),
                    let country = try? viewModel.country.value()
                    else { return }
                self.viewModel.updateAddress(address1: address1, address2: address2, city: city, region: region, postalCode: postalcode, country: country)
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
        
        viewModel.message
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ message in
                NotificationBannerManager.show(title: message, message: "", style: .success)
            })
            .disposed(by: disposeBag)
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.loadingView.isHidden = false
                case .error:
                    self.loadingView.isHidden = true
                case .success:
                    self.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.updateState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.saveSettingsButton.loadingIndicator(true)
                case .error:
                    self.saveSettingsButton.loadingIndicator(false)
                case .success:
                    self.saveSettingsButton.loadingIndicator(false)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.customer
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] customer in
                guard let self = self else { return }
                print("customer: ", customer)
                self.settingsFormTableVC?.viewModel.customer = customer
            })
            .disposed(by: disposeBag)
        
        viewModel.getCustomer()
    }
    
}
