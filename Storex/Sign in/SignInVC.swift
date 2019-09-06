//
//  SignInVC.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/21/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Trying to sign in ...")
        // Do any additional setup after loading the view.
        
    
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        print("Alamofire login")
        
        if emailTextField.text != "" &&
            passwordTextField.text != "" {
            guard let email = emailTextField.text, let password = passwordTextField.text else { return }
            signIn(email: email, password: password) { (CustomerRegister, Error) in
                //
                
                let alertVC = UIViewController(nibName: "AlertVC", bundle: nil)
                self.present(alertVC, animated: true, completion: nil)
                
            }
        }
        
    }
    
}


extension SignInVC: UITextFieldDelegate {
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

