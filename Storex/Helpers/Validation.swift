//
//  Validation.swift
//  Mosand
//
//  Created by admin on 7/30/19.
//  Copyright © 2019 Mosandah. All rights reserved.
//

import UIKit

func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

func isValidPassword(password: String) -> Bool {
    return password.count < 6 ? false : true
}

