//
//  MyAccountViewController.swift
//  Storex
//
//  Created by admin on 1/29/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyAccountViewController: UIViewController {
    @IBOutlet weak var ordersProgressButton: UIButton!
    @IBOutlet weak var lastOrderLabel: UILabel!
    @IBOutlet weak var lastOrderIDLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var rertyView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    
    lazy var viewModel: MyAccountViewModel = {
        return MyAccountViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersProgressButton.alignImageAndTitleVertically()
        
        // register nibs:
        tableView.registerCellNib(cellClass: OptionCell.self)
        
        initView()
        initVM()
    }
    
    private func initView() {
        
        retryButton.rx.tap
            .throttle(.seconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.viewModel.getOrders()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func initVM() {
        
        viewModel.errorMessage
        .observeOn(MainScheduler.instance)
        .subscribe(onNext:{ message in
            NotificationBannerManager.show(title: "Network Error!", message: message, style: .warning)
        })
        .disposed(by: disposeBag)
        
        
        viewModel.state
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                UIView.animate(withDuration: 0.2) {
                    self.loadingView.alpha = 1.0
                    self.rertyView.alpha = 0.0
                }
            case .error:
                UIView.animate(withDuration: 0.2) {
                    self.loadingView.alpha = 0.0
                    self.rertyView.alpha = 1.0
                }
            case .success:
                UIView.animate(withDuration: 0.2) {
                    self.loadingView.alpha = 0.0
                    self.rertyView.alpha = 0.0
                }
            }
        })
        .disposed(by: disposeBag)
        
        
        viewModel.ordersCount
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] ordersCount in
                guard let self = self else { return }
                let buttonTitle = ordersCount > 1 ? "\(ordersCount) Orders in Progress" : "\(ordersCount) Order in Progress"
                self.ordersProgressButton.setTitle(buttonTitle, for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.lastOrderDate
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] lastOrderDate in
                guard let self = self else { return }
                self.lastOrderLabel.text = "Last Order: \(lastOrderDate)"
            })
            .disposed(by: disposeBag)
        
        viewModel.lastOrderID
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] lastOrderID in
                guard let self = self else { return }
                self.lastOrderIDLabel.text = "ID: \(lastOrderID)"
            })
            .disposed(by: disposeBag)
        
        viewModel.getOrders()
    }
    
}

extension MyAccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyAccountOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = MyAccountOption.allCases[indexPath.row]
        let cell = tableView.dequeue() as OptionCell
        cell.viewModel = OptionCellViewModel(title: option.title, icon: option.icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = MyAccountOption.allCases[indexPath.row]
        var vc = UIViewController()
        switch option {
        case .payment:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController { vc = VC }
        case .settings:
            if let VC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController { vc = VC }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    enum MyAccountOption: CaseIterable {
        case payment
        case settings
        
        var title: String {
            switch self {
            case .payment:
                return "Payment Information"
            case .settings:
                return "Settings"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .payment:
                return #imageLiteral(resourceName: "icon-payment")
            case .settings:
                return #imageLiteral(resourceName: "icon-settings")
            }
        }
        
        var identifier: String {
            switch self {
            case .payment:
                return "PaymentInformationViewController"
            case .settings:
                return "SettingsViewController"
            }
        }
    }
}
