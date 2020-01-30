//
//  CustomerSupportViewController.swift
//  Storex
//
//  Created by admin on 1/28/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class CustomerSupportViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register nibs:
        tableView.registerCellNib(cellClass: OptionCell.self)
    }
    
}

extension CustomerSupportViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomerSupportOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = CustomerSupportOption.allCases[indexPath.row]
        let cell = tableView.dequeue() as OptionCell
        cell.viewModel = OptionCellViewModel(title: option.title, subtitle: option.subtitle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = CustomerSupportOption.allCases[indexPath.row]
        var vc = UIViewController()
        switch option {
        case .Contact:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "ContactViewController") { vc = VC }
        case .CustomerService:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "CustomerServiceTableVC") as? CustomerServiceTableVC { vc = VC }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    enum CustomerSupportOption: CaseIterable {
        case Contact
        case CustomerService
        
        var title: String {
            switch self {
            case .Contact:
                return "Contact"
            case .CustomerService:
                return "Customer Service"
            }
        }
        
        var subtitle: String {
            switch self {
            case .Contact:
                return "Ask questions or get contact info."
            case .CustomerService:
                return "FAQ and company policies."
            }
        }
    }
}
