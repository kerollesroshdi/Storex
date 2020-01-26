//
//  SecondViewController.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/15/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

class BagViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var noItemsView: UIView!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: BagViewModel = {
        return BagViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CartManager.cartID { (cartID) in
            print("CartID from BagWillAppear: \(String(describing: cartID))")
        }
        viewModel.getProductsInCart()
        viewModel.getTotalAmountInCart()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setNavigationTitleImage()
        
        // register nibs:
        productsTableView.registerCellNib(cellClass: CartProductCell.self)
        
        initView()
        initVM()
    }
    
    func initView() {
        
        menuButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let menu = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenu") as! UISideMenuNavigationController
                menu.setNavigationBarHidden(true, animated: false)
                SideMenuManager.default.menuPresentMode = .viewSlideInOut
                SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
                self.present(menu, animated: true)
            })
            .disposed(by: disposeBag)
        
        checkoutButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if let selectRegionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectRegionViewController") {
                    self.navigationController?.pushViewController(selectRegionViewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        productsTableView.rx.modelSelected(CartProductCellViewModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                if let editItem = self.storyboard?.instantiateViewController(withIdentifier: "EditItemViewController") as? EditItemViewController {
                    editItem.cartProductCellViewModel = model
                    self.navigationController?.pushViewController(editItem, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        productsTableView.rx.modelDeleted(CartProductCellViewModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.viewModel.removeProduct(itemID: model.itemID)
            })
            .disposed(by: disposeBag)
    }

    func initVM() {
        
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
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self.loadingView.alpha = 1.0
                    }
                case .error:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self.loadingView.alpha = 0.0
                        self.noItemsView.alpha = 1.0
                    }
                case .success:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self.loadingView.alpha = 0.0
                        self.noItemsView.alpha = 0.0
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.totalAmount
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] totalAmount in
                guard let self = self else { return }
                self.totalAmountLabel.text = totalAmount
            })
            .disposed(by: disposeBag)
        
        // bind product tableview and items count label
        viewModel.cartProductCellViewModels
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] products in
                guard let self = self else { return }
                if products.count > 1 {
                    self.numberOfItemsLabel.text = "\(products.count) items"
                } else {
                   self.numberOfItemsLabel.text = "\(products.count) item"
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.cartProductCellViewModels
            .bind(to: productsTableView.rx.items(cellIdentifier: "CartProductCell")) {
                (row, cellViewModel, cell: CartProductCell) in
                // configure cell :
                cell.cartProductCellViewModel = cellViewModel
        }.disposed(by: disposeBag)
    }

}

