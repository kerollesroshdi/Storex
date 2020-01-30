//
//  SettingsFormTableVC.swift
//  Storex
//
//  Created by admin on 1/30/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class SettingsFormTableVC: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    var customer: Customer? {
        didSet {
            nameTextField.text = customer?.name
            address1TextField.text = customer?.address1
            address2TextField.text = customer?.address2
            cityTextField.text = customer?.city
            stateTextField.text = customer?.region
            zipcodeTextField.text = customer?.postalCode
            countryTextField.text = customer?.country
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        [nameTextField, address1TextField, address2TextField, cityTextField, stateTextField, zipcodeTextField, countryTextField].forEach { (textField) in
            textField?.addBottomBorder()
            textField?.rightView = UIImageView(image: #imageLiteral(resourceName: "icons8-high-priority-80"))
            textField?.rightViewMode = .always
        }
        
    }

}


