//
//  AlertVC.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/22/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

class AlertVC: UIViewController {
    @IBOutlet weak var alertHeaderLabel: UILabel!
    @IBOutlet weak var alertMessageLabel: UILabel!
    
    var header: String?
    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.alertHeaderLabel.text = "Error code: \(header ?? "N/A")"
        self.alertMessageLabel.text = message
        
        // Do any additional setup after loading the view.
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
