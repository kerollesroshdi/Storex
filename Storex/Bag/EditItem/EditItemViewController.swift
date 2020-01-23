//
//  EditItemViewController.swift
//  Storex
//
//  Created by admin on 1/23/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit
import SDWebImage
import RxSwift
import RxCocoa

class EditItemViewController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    @IBOutlet weak var updateCheckButton: UIBarButtonItem!
    
    lazy var viewModel: EditItemViewModel = {
        return EditItemViewModel()
    }()
    let disposeBag = DisposeBag()
    
    var cartProductCellViewModel: CartProductCellViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitleImage()
        initView()
        initVM()
    }
    
    private func initView() {
        
        let imageURL = URL(string: "https://backendapi.turing.com/images/products/")?.appendingPathComponent(cartProductCellViewModel!.imageURL)
        self.productImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.productImageView.sd_setImage(with: imageURL)
        self.productNameLabel.text = cartProductCellViewModel?.name
        self.priceLabel.text = "$\(cartProductCellViewModel?.price ?? "00.00")"
        self.quantityLabel.text = "Qty: \(cartProductCellViewModel?.quantity ?? 1)"
        self.sizeLabel.text = cartProductCellViewModel?.size
        if let color = cartProductCellViewModel?.color {
            self.colorImageView.tintColor = UIColor(red: CGFloat(color.red/255), green: CGFloat(color.green/255), blue: CGFloat(color.blue/255), alpha: 1)
        }
        self.quantityStepper.value = Double(cartProductCellViewModel?.quantity ?? 1)
        
        updateCheckButton.rx.tap
            .throttle(.seconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.updateProduct(itemID: self.cartProductCellViewModel!.itemID, quantity: self.cartProductCellViewModel!.quantity)
            })
        .disposed(by: disposeBag)
    }
    
    private func initVM() {
        viewModel.message
        .observeOn(MainScheduler.instance)
        .subscribe(onNext:{ message in
            NotificationBannerManager.show(title: "Item Update:", message: message, style: .info)
        })
        .disposed(by: disposeBag)
        
        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    self.updateCheckButton.image = nil
                    self.updateCheckButton.title = "updating..."
                case .success:
                    self.updateCheckButton.image = #imageLiteral(resourceName: "icon-check")
                case .error:
                    print("error updating item")
                }
            })
        .disposed(by: disposeBag)
    }
    
    
    @IBAction func quantityChanged(_ sender: UIStepper) {
        cartProductCellViewModel?.quantity = Int(sender.value)
        self.quantityLabel.text = "Qty: \(Int(sender.value))"
    }
    
}
