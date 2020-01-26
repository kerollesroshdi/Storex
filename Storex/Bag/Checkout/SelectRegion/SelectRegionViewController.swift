//
//  SelectRegionViewController.swift
//  Storex
//
//  Created by admin on 1/26/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectRegionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: SelectRegionViewModel = {
        return SelectRegionViewModel()
    }()
    let disposeBag = DisposeBag()
    
    var selectedRegion: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
        viewModel.getShippingRegions()
    }
    
    private func initView() {
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexpath in
            guard let self = self else { return }
            self.selectedRegion = indexpath.row
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        continueButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let selectedRegion = self.selectedRegion {
                    if let selectShippingViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectShippingViewController") as? SelectShippingViewController {
                        selectShippingViewController.selectedRegion = selectedRegion + 2
                        self.navigationController?.pushViewController(selectShippingViewController, animated: true)
                    }
                } else {
                    NotificationBannerManager.show(title: "Please select region", message: "", style: .warning)
                }
                
            }).disposed(by: disposeBag)
    }
    
    private func initVM() {
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .loading:
                    self?.activityIndicator.isHidden = false
                case .success, .error:
                    self?.activityIndicator.isHidden = true
                }
            }).disposed(by: disposeBag)
        
        viewModel.errorMessage
        .observeOn(MainScheduler.instance)
        .subscribe(onNext:{ message in
            NotificationBannerManager.show(title: "Network Error!", message: message, style: .warning)
        })
        .disposed(by: disposeBag)
        
        
        viewModel.shippingRegions
            .bind(to: tableView.rx.items(cellIdentifier: "RegionCell") ) {
                (row, cellViewModel, cell: UITableViewCell) in
                cell.textLabel?.text = cellViewModel.shippingRegion
                cell.accessoryType = row == self.selectedRegion ? .checkmark : .none
        }.disposed(by: disposeBag)
    }
}
