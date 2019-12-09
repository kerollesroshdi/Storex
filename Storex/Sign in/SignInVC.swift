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
    
    lazy var viewModelFb: SignInWithFBViewModel = {
        return SignInWithFBViewModel()
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Trying to sign in ...")
        // Do any additional setup after loading the view.
        
        initView()
        initVM()
        initVMfb()
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
        
        
        // MARK:- Sign In:
        signInButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let self = self {
                    self.viewModel.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!)
                }
            })
            .disposed(by: disposeBag)
        
        // twitter signin
        twitterLoginButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                NotificationBannerManager.show(title: "Unavailable", message: "sorry!, sign in with twitter is currently unavailable", style: .info)
            })
            .disposed(by: disposeBag)
        
        // facebook signin
        facebookLoginButton.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                if let self = self {
                    // viewmodel facebook login
                    self.viewModelFb.signInWithFb()
                }
            })
            .disposed(by: disposeBag)
        
        
        // MARK:- To Sign Up:
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
                NotificationBannerManager.show(title: "Login Error!", message: message, style: .warning)
            })
        .disposed(by: disposeBag)
        
        viewModel.accessToken
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { token in
                // save token to keychain / UserDefaults
                Switcher.loggedWith(token: token)
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
                    // navigate to main app screen
                    Switcher.updateRootVC()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func initVMfb() {
        viewModelFb.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { message in
                NotificationBannerManager.show(title: "Facebook Login Error!", message: message, style: .warning)
            })
        .disposed(by: disposeBag)
        
        viewModelFb.accessToken
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { token in
            // save token to keychain / UserDefaults
            Switcher.loggedWith(token: token)
        })
        .disposed(by: disposeBag)
        
        viewModelFb.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .loading:
                    self?.facebookLoginButton.loadingIndicator(true)
                case .error:
                    self?.facebookLoginButton.loadingIndicator(false)
                case .success:
                    self?.facebookLoginButton.loadingIndicator(false)
                    // LOL - navigate to main app screen
                    Switcher.updateRootVC()
                }
            })
        .disposed(by: disposeBag)
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

