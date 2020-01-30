//
//  CustomerServiceTableVC.swift
//  Storex
//
//  Created by admin on 1/29/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class CustomerServiceTableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerCellNib(cellClass: OptionCell.self)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CustomerServiceOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = CustomerServiceOption.allCases[indexPath.row]
        let cell = tableView.dequeue() as OptionCell
        cell.viewModel = OptionCellViewModel(title: option.title, subtitle: option.subtitle)
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let customerServiceDetailsVC = storyboard?.instantiateViewController(withIdentifier: "CustomerServiceDetailsVC") as? CustomerServiceDetailsVC {
            let option = CustomerServiceOption.allCases[indexPath.row]
            customerServiceDetailsVC.navigationItem.title = option.title
            navigationController?.pushViewController(customerServiceDetailsVC, animated: true)
        }
    }
    
    enum CustomerServiceOption: CaseIterable {
        case shopping
        case payments
        case tracking
        case onlineReturns
        case storeReturns
        case recalled
        case responsibility
        
        var title: String {
            switch self {
            case .shopping:
                return "Shopping at Storex"
            case .payments:
                return "Payments & Sales Tax"
            case .tracking:
                return "Order Tracking"
            case .onlineReturns:
                return "Returns of online purchaces"
            case .storeReturns:
                return "Returns of store purchaces"
            case .recalled:
                return "Recalled Items"
            case .responsibility:
                return "Our Responsibility"
            }
        }
        
        var subtitle: String {
            return "Lorem ipsum dolor sit amet consecter adipisci…"
        }
    }
    
}
