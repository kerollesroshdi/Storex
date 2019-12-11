//
//  DepartmentViewController.swift
//  Storex
//
//  Created by admin on 12/10/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DepartmentViewController: UIViewController {
    @IBOutlet weak var departmentView: UIView!
    @IBOutlet weak var departmentNameLabel: UILabel!
    @IBOutlet weak var departmentDescriptionLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: DepartmentViewModel = {
        return DepartmentViewModel()
    }()
    let disposeBag = DisposeBag()
    
    var departmentCellViewModel: DepartmentCellViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavigationTitleImage()
        
        // register nibs:
        categoriesCollectionView.registerCellNib(cellClass: CategoryCell.self)
        
        initView()
        initVM()
    }
    
    func setNavigationTitleImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "nav-logo")!
        self.navigationItem.titleView = imageView
    }
    
    func initView() {
        
        if let color = departmentCellViewModel?.color {
           departmentView.backgroundColor = UIColor(red: color.red/255, green: color.green/255, blue: color.blue/255, alpha: 1)
        }
        departmentNameLabel.text = departmentCellViewModel.name
        departmentDescriptionLabel.text = departmentCellViewModel.description
        
        categoriesCollectionView.rx.modelSelected(CategoryCellViewModel.self)
            .subscribe(onNext: { model in
                print(model)
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
                    // tableView & collectionView loading ...
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self.categoriesCollectionView.alpha = 0.0
                        self.productsTableView.alpha = 0.0
                    }
                case .error:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self.categoriesCollectionView.alpha = 0.0
                        self.productsTableView.alpha = 0.0
                    }
                case .success:
                    // tableview & collectionView loaded
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self.categoriesCollectionView.alpha = 1.0
                        self.categoriesCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.left)
                        self.productsTableView.alpha = 1.0
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.categoryCellViewModels
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.categoriesCollectionView.reloadData()
            })
        .disposed(by: disposeBag)
        
        viewModel.categoryCellViewModels
            .bind(to: categoriesCollectionView.rx.items(cellIdentifier: "CategoryCell")) {
                (row, cellViewModel, cell: CategoryCell) in
                if let color = self.departmentCellViewModel?.color {
                    let selectedColor = UIColor(red: color.red/255, green: color.green/255, blue: color.blue/255, alpha: 1)
                    if cell.isSelected {
                        cell.nameLabel.textColor = selectedColor
                    }
                    cell.selectedColor = selectedColor
                }
                cell.categoryCellViewModel = cellViewModel
        }.disposed(by: disposeBag)
        
        viewModel.productCellViewModels
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.productsTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.productCellViewModels
            .bind(to: productsTableView.rx.items(cellIdentifier: "ProductCell")) {
                (row, cellViewModel, cell: ProductCell) in
                    
        }.disposed(by: disposeBag)
        
        viewModel.categoriesFetch(departmentID: departmentCellViewModel.departmentID)
        viewModel.productsInDepartmentFetch(departmentID: departmentCellViewModel.departmentID, page: 1)
    }

}
