//
//  SignInVC.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/21/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import Moya
import NotificationBannerSwift
import RxSwift
import RxCocoa

class SignInVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var toSignUpButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var twitterLoginButton: UIButton!
    
    lazy var viewModel: SignInViewModel = {
       return SignInViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Trying to sign in ...")
        // Do any additional setup after loading the view.
        
        initView()
        initVM()
        
    }
    
    func initView() {
        
        let emailValid = emailTextField.rx.text.orEmpty
            .map { isValidEmail(testStr: $0) }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            .share(replay: 1)
        
        let allValid = Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        allValid
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        allValid
            .map { $0 == true ? 1 : 0.5 }
            .bind(to: signInButton.rx.alpha)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let self = self {
                    self.viewModel.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!)
                }
            })
            .disposed(by: disposeBag)
        
        toSignUpButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let signUpVC = self?.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
                    self?.navigationController?.pushViewController(signUpVC, animated: true)
                } else {
                    print("cannot instantiate sign up VC")
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func initVM() {
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { message in
                self.showAlert(title: "Login Error!", message: message)
            })
        .disposed(by: disposeBag)
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .loading:
                    self?.signInButton.loadingIndicator(true)
                case .error:
                    self?.signInButton.loadingIndicator(false)
                case .success:
                    self?.signInButton.loadingIndicator(false)
                    // navigate to main screen
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func showAlert(title: String, message: String) {
        let banner = NotificationBanner(title: title, subtitle: message, style: .warning)
        banner.show()
    }
    
    
}


extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            let nextTag = textField.tag + 1
            if let nextResponder = textField.superview?.superview?.viewWithTag(88)?.viewWithTag(nextTag) {
                nextResponder.becomeFirstResponder()
            }
        } else if textField.returnKeyType == .done {
            textField.resignFirstResponder()
        }
        return true
    }
}

