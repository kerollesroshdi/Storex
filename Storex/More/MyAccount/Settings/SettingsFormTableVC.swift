//
//  SettingsFormTableVC.swift
//  Storex
//
//  Created by admin on 1/30/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsFormTableVC: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var address1TextField: UITextField!
    @IBOutlet weak var address2TextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
        
    lazy var viewModel: SettingsFormViewModel = {
        return SettingsFormViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        
        [nameTextField, address1TextField, address2TextField, cityTextField, stateTextField, zipcodeTextField, countryTextField].forEach { (textField) in
            textField?.addBottomBorder()
            textField?.rightView = UIImageView(image: #imageLiteral(resourceName: "icons8-high-priority-80"))
        }
        
        
        initView()
    }
    
    private func initView() {
        
        ( nameTextField.rx.text <-> viewModel.name ).disposed(by: disposeBag)
        ( address1TextField.rx.text <-> viewModel.address1 ).disposed(by: disposeBag)
        ( address2TextField.rx.text <-> viewModel.address2 ).disposed(by: disposeBag)
        ( cityTextField.rx.text <-> viewModel.city ).disposed(by: disposeBag)
        ( stateTextField.rx.text <-> viewModel.region ).disposed(by: disposeBag)
        ( zipcodeTextField.rx.text <-> viewModel.postalcode ).disposed(by: disposeBag)
        ( countryTextField.rx.text <-> viewModel.country ).disposed(by: disposeBag)
        
        
        viewModel.nameValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.nameTextField.rightViewMode = value ? .never : .unlessEditing
            })
            .disposed(by: disposeBag)
        
        
        viewModel.address1Valid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.address1TextField.rightViewMode = value ? .never : .unlessEditing
            })
            .disposed(by: disposeBag)
        
        
        viewModel.cityValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.cityTextField.rightViewMode = value ? .never : .unlessEditing
            })
            .disposed(by: disposeBag)
        
        
        viewModel.stateValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.stateTextField.rightViewMode = value ? .never : .unlessEditing
            })
            .disposed(by: disposeBag)
        
        
        viewModel.zipcodeValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.zipcodeTextField.rightViewMode = value ? .never : .unlessEditing
            })
            .disposed(by: disposeBag)
        
        
        viewModel.countryValid
            .skip(2)
            .distinctUntilChanged()
            .subscribe(onNext: { value in
                self.countryTextField.rightViewMode = value ? .never : .unlessEditing
            })
            .disposed(by: disposeBag)
        
    }

}



