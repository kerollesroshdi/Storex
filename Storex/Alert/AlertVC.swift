//
//  AlertVC.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/22/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
