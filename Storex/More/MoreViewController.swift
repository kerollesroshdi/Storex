//
//  FirstViewController.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import SideMenu

class MoreViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitleImage()
        tableView.registerCellNib(cellClass: OptionCell.self)
    }

    @IBAction func menuButtonPressed(_ sender: Any) {
        let menu = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenu") as! UISideMenuNavigationController
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.menuPresentMode = .viewSlideInOut
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        self.present(menu, animated: true)
    }
    
}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MoreOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = MoreOption.allCases[indexPath.row]
        let cell = tableView.dequeue() as OptionCell
        cell.viewModel = OptionCellViewModel(title: option.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = MoreOption.allCases[indexPath.row]
        var vc = UIViewController()
        switch option {
        case .MyAccount:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as? MyAccountViewController { vc = VC }
        case .CustomerSupport:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "CustomerSupportViewController") as? CustomerSupportViewController { vc = VC }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    enum MoreOption: CaseIterable {
        case MyAccount
        case CustomerSupport
        
        var title: String {
            switch self {
            case .MyAccount:
                return "My Account"
            case .CustomerSupport:
                return "Customer Support"
            }
        }
    }
    
}

