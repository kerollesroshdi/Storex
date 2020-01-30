//
//  ContactViewController.swift
//  Storex
//
//  Created by admin on 1/29/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func callButtonPressed(_ sender: Any) {
        // call number :
        guard let number = URL(string: "tel://201023674218") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func sendQuestionButtonPressed(_ sender: Any) {
        if let sendQuestionTableVC = storyboard?.instantiateViewController(withIdentifier: "SendQuestionTableVC") as? UITableViewController {
            navigationController?.pushViewController(sendQuestionTableVC, animated: true)
        }
    }
    
}
