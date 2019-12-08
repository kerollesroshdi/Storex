//
//  SignUpVC.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/21/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var termsAgreeSwitch: UISwitch!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var toSignInButton: UIButton!
    
    lazy var viewModel: SignUpViewModel = {
       return SignUpViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Trying to sign up ...")
        // Do any additional setup after loading the view.
        initView()
        initVM()
    }
    
    func initView() {
        
        let nameValid = nameTextField.rx.text.orEmpty
            .map { $0.count >= 6}
            .share(replay: 1)
        
        let emailValid = emailTextField.rx.text.orEmpty
            .map { isValidEmail(testStr: $0) }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1)
        
        let passwordConfirm = Observable.combineLatest(passwordTextField.rx.text.orEmpty, confirmPasswordTextField.rx.text.orEmpty) { (password, confirm) -> Bool in
            return password == confirm
            }
            .share(replay: 1)
        
        let termsAgreed = termsAgreeSwitch.rx.value
            .share(replay: 1)
        
        let allValid = Observable.combineLatest(nameValid, emailValid, passwordValid, passwordConfirm, termsAgreed) { $0 && $1 && $2 && $3 && $4 }
            .share(replay: 1)
        
        allValid
            .bind(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        allValid
            .map { $0 == true ? 1 : 0.5 }
            .bind(to: signUpButton.rx.alpha)
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let self = self {
                    self.viewModel.signUp(name: self.nameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!)
                }
            })
            .disposed(by: disposeBag)
        
        toSignInButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    func initVM() {
        
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { message in
                NotificationBannerManager.show(title: "Signup Error!", message: message)
            })
        .disposed(by: disposeBag)
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .loading:
                    self?.signUpButton.loadingIndicator(true)
                case .error:
                    self?.signUpButton.loadingIndicator(false)
                case .success:
                    self?.signUpButton.loadingIndicator(false)
                    // navigate to main screen
                }
            })
            .disposed(by: disposeBag)

    }
    
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let nextTag = textField.tag + 1
            if let nextResponder = textField.superview?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            }
        } else if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}
