//
//  PaymentViewController.swift
//  Storex
//
//  Created by admin on 2/2/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PaymentViewController: UIViewController {
    @IBOutlet weak var saveInfoButton: UIButton!
    @IBOutlet weak var cardTextField: UITextField!
    
    
    lazy var viewModel: PaymentViewModel = {
        return PaymentViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        initView()
        initVM()
    }
    
    private func initView() {
        
        ( cardTextField.rx.text <-> viewModel.creditCard ).disposed(by: disposeBag)
        
        viewModel.creditCardValid
            .bind(to: saveInfoButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.creditCardValid
            .map{ $0 == true ? 1 : 0.5 }
            .bind(to: saveInfoButton.rx.alpha)
            .disposed(by: disposeBag)
        
        saveInfoButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.updateCreditCard()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func initVM() {
        
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ message in
                NotificationBannerManager.show(title: "Error!", message: message, style: .warning)
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
                    self.saveInfoButton.loadingIndicator(true)
                case .error:
                    self.saveInfoButton.loadingIndicator(false)
                case .success:
                    self.saveInfoButton.loadingIndicator(false)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.getCustomer()
    }
}


extension PaymentViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 16
    }
}
