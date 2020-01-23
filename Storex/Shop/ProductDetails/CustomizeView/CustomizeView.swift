//
//  CustomizeView.swift
//  Storex
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CustomizeView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    
    var selectedAttributes: Dictionary<String, String> = ["size": "S" , "color" : StorexColor.White.rawValue] {
        didSet {
            print(self.selectedAttributes)
        }
    }
    
    lazy var viewModel: CustomizeViewModel = {
        return CustomizeViewModel()
    }()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    private func commonInit() {
        if let nibView = Bundle.main.loadNibNamed("CustomizeView", owner: self, options: nil)?.first as? UIView {
            nibView.frame = self.bounds
            self.addSubview(nibView)
            containerView = nibView
        }
        
        initView()
        initVM()
    }
    
    func initView() {
        sizeCollectionView.registerCellNib(cellClass: SizeCell.self)
        colorCollectionView.registerCellNib(cellClass: ColorCell.self)
        
        sizeCollectionView.rx.modelSelected(SizeCellViewModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.selectedAttributes["size"] = model.size
            })
            .disposed(by: disposeBag)
        
        colorCollectionView.rx.modelSelected(ColorCellViewModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.selectedAttributes["color"] = model.color.rawValue
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
                    //                    self.containerView.backgroundColor = .green
                    print("loading Customization")
                case .error:
                    //                    self.containerView.backgroundColor = .red
                    print("loading Customization failed :(")
                case .success:
                    //                    self.containerView.backgroundColor = .white
                    self.sizeCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
                    self.colorCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
                }
            })
            .disposed(by: disposeBag)
        
        
        viewModel.sizeCellViewModels.bind(to: sizeCollectionView.rx.items(cellIdentifier: "SizeCell")) {
            (row, cellViewModel, cell: SizeCell) in
            cell.sizeCellViewModel = cellViewModel
        }.disposed(by: disposeBag)
        
        viewModel.colorCellViewModels.bind(to: colorCollectionView.rx.items(cellIdentifier: "ColorCell")) {
            (row, cellViewModel, cell: ColorCell) in
            cell.colorCellViewModel = cellViewModel
        }.disposed(by: disposeBag)
        
    }
}

