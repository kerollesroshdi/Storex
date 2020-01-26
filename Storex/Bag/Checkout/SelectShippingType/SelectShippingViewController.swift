//
//  SelectShippingViewController.swift
//  Storex
//
//  Created by admin on 1/26/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectShippingViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: SelectShippingViewModel = {
        return SelectShippingViewModel()
    }()
    let disposeBag = DisposeBag()
    
    var selectedRegion: Int?
    var selectedType: Int?
    var shippingID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
        viewModel.getShippingTypes(regionID: selectedRegion ?? 1)
    }
    
    private func initView() {
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexpath in
                guard let self = self else { return }
                self.selectedType = indexpath.row
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ShippingType.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.shippingID = model.shippingID
            }).disposed(by: disposeBag)
        
        orderButton.rx.tap
            .throttle(.seconds(20), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let shippingID = self.shippingID {
                    self.viewModel.order(shippingID: shippingID, taxID: nil)
                } else {
                    NotificationBannerManager.show(title: "Please select shipping type", message: "", style: .warning)
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func initVM() {
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.activityIndicator.isHidden = false
                case .success, .error:
                    self.activityIndicator.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        viewModel.orderState
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.orderButton.loadingIndicator(true)
                    self.navigationItem.hidesBackButton = true
                case .error:
                    self.orderButton.loadingIndicator(false)
                    self.navigationItem.hidesBackButton = false
                case .success:
                    self.orderButton.loadingIndicator(false)
                }
            }).disposed(by: disposeBag)
        
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ message in
                NotificationBannerManager.show(title: "Network Error!", message: message, style: .warning)
            })
            .disposed(by: disposeBag)
        
        viewModel.shippingTypes
            .bind(to: tableView.rx.items(cellIdentifier: "ShippingTypeCell") ) {
                (row, cellViewModel, cell: UITableViewCell) in
                cell.textLabel?.text = cellViewModel.shippingType
                cell.accessoryType = row == self.selectedType ? .checkmark : .none
        }.disposed(by: disposeBag)
        
        viewModel.orderID
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] orderID in
                guard let self = self else { return }
                if let orderCompleteVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderCompleteViewController") as? OrderCompleteViewController  {
                    // set order id :
                    orderCompleteVC.orderID = orderID
                    self.navigationController?.pushViewController(orderCompleteVC, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
}
