//
//  SendQuestionTableVC.swift
//  Storex
//
//  Created by admin on 1/29/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift

class SendQuestionTableVC: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    var fields = [AnyObject]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

         fields = [nameTextField, emailTextField, phoneTextField, subjectTextField, messageTextView]
        
        nameTextField.rightView = errorLabel(withText: "please enter a name")
        emailTextField.rightView = errorLabel(withText: "invalid email!")
        phoneTextField.rightView = errorLabel(withText: "invalid phone!")
        subjectTextField.rightView = errorLabel(withText: "plase enter a subject")
        
        initView()
    }
    
    
    private func initView() {
        
        let nameValid = nameTextField.rx.text.orEmpty
            .map { $0.count >= 6 }
            .share(replay: 1)
        
        nameValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.nameTextField.rightViewMode = value ? .never : .unlessEditing
            }).disposed(by: disposeBag)
        
        let emailValid = emailTextField.rx.text.orEmpty
            .map { isValidEmail(testStr: $0) }
            .share(replay: 1)
        
        emailValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.emailTextField.rightViewMode = value ? .never : .unlessEditing
            }).disposed(by: disposeBag)
        
        let phoneValid = phoneTextField.rx.text.orEmpty
            .map{ isvalidPhone(value: $0) }
            .share(replay: 1)
        
        phoneValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.phoneTextField.rightViewMode = value ? .never : .unlessEditing
            }).disposed(by: disposeBag)
        
        let subjectValid = subjectTextField.rx.text.orEmpty
            .map{ $0.count >= 5 }
            .share(replay: 1)
        
        subjectValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.subjectTextField.rightViewMode = value ? .never : .unlessEditing
            }).disposed(by: disposeBag)
        
        let messageValid = messageTextView.rx.text.orEmpty
            .map{ $0.count >= 10 }
            .share(replay: 1)
        
        let allValid = Observable.combineLatest(nameValid, emailValid, phoneValid, subjectValid, messageValid) { $0 && $1 && $2 && $3 && $4 }
            .share(replay: 1)
        
        allValid
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        allValid
        .map { $0 == true ? 1 : 0.5 }
        .bind(to: sendButton.rx.alpha)
        .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .subscribe(onNext: { _ in
                self.sendButton.loadingIndicator(true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    print("Timer fired!")
                    self.sendButton.loadingIndicator(false)
                    NotificationBannerManager.show(title: "message sent successfully", message: "", style: .success)
                    self.messageTextView.text = ""
                }
            })
            .disposed(by: disposeBag)
        
    }

}

extension SendQuestionTableVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            if let currentIndex = self.fields.firstIndex(where: { $0 as! UITextField == textField }) {
                let nextIndex = currentIndex + 1
                let nextResponder = self.fields[nextIndex]
                nextResponder.becomeFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}


func isvalidPhone(value: String) -> Bool {
    let PHONE_REGEX = "^[0-9]{11}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

private func errorLabel(withText text: String) -> UILabel {
    let errorLabel = UILabel()
    errorLabel.text = text
    errorLabel.font = UIFont(name: "Avenir", size: 14)
    errorLabel.textColor = UIColor.red
    return errorLabel
}
