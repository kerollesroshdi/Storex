//
//  MyAccountViewController.swift
//  Storex
//
//  Created by admin on 1/29/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class MyAccountViewController: UIViewController {
    @IBOutlet weak var ordersProgressButton: UIButton!
    @IBOutlet weak var lastOrderLabel: UILabel!
    @IBOutlet weak var lastOrderIDLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersProgressButton.alignImageAndTitleVertically()
    }
    
}
