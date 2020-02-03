//
//  OrderStatusTableVC.swift
//  Storex
//
//  Created by admin on 2/3/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderStatusTableVC: UITableViewController {
    
    lazy var viewModel: OrderStatusViewModel = {
           return OrderStatusViewModel()
       }()
       let disposeBag = DisposeBag()

    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.color = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerCellNib(cellClass: OrderStatusCell.self)
        
        initView()
        initVM()
    }
    
    private func initView() {
        
        tableView.backgroundView = spinner
        
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
                    self.spinner.startAnimating()
                case .error:
                    self.spinner.stopAnimating()
                case .success:
                    self.spinner.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        tableView.delegate = nil
        tableView.dataSource = nil
        viewModel.orderCellViewModels
            .bind(to: tableView.rx.items(cellIdentifier: "OrderStatusCell")) { (row, cellViewModel, cell: OrderStatusCell) in
                cell.orderCellViewModel = cellViewModel
        }.disposed(by: disposeBag)
        
        viewModel.getOrders()
        
    }
    
}
