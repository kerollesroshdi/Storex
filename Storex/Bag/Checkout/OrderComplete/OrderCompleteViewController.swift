//
//  OrderCompleteViewController.swift
//  Storex
//
//  Created by admin on 1/26/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class OrderCompleteViewController: UIViewController {
    @IBOutlet weak var orderIDTextView: UITextView!
    
    var orderID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let orderID = orderID {
            orderIDTextView.text = String(orderID)
        } else {
            orderIDTextView.text = "-- -- -- --"
        }
        
        navigationItem.hidesBackButton = true
        CartManager.updateCartID()
    }
    
    @IBAction func backToShopButtonPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
