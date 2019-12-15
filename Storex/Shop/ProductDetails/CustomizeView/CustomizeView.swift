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
    }

    func initVM() {
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ message in
                NotificationBannerManager.show(title: "Network Error!", message: message, style: .warning)
            })
            .disposed(by: disposeBag)

//        viewModel.state
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] state in
//                guard let self = self else { return }
//                switch state {
//                case .loading:
//                    self.containerView.backgroundColor = .green
//                case .error:
//                    self.containerView.backgroundColor = .red
//                case .success:
//                    self.containerView.backgroundColor = .white
//                }
//            })
//            .disposed(by: disposeBag)


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

