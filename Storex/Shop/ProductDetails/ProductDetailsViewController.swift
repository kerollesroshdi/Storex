//
//  ProductDetailsViewController.swift
//  Storex
//
//  Created by admin on 12/12/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductDetailsViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var imagesPageControl: UIPageControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var customizeViewAsButton: UIView!
    @IBOutlet weak var expandIconImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountedPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var customizeView: CustomizeView!
    @IBOutlet weak var customizeViewConstraint: NSLayoutConstraint!
    
    lazy var viewModel: ProductDetailsViewModel = {
        return ProductDetailsViewModel()
    }()
    let disposeBag = DisposeBag()
    
    var productID: Int!
    var customizeOn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // register nibs:
        imagesCollectionView.registerCellNib(cellClass: ProductImageCell.self)
        
        initView()
        initVM()
        customizeView.viewModel.getAttributesInProduct(productID)
    }
    
    func initView() {
        
        closeButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        #warning ("//TODO: request add to bag")
        addToCartButton.rx.tap
            .throttle(.seconds(30), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self ] _ in
                guard let self = self else { return }
                self.addToCartButton.setTitle("Loading...     ", for: .normal)
                self.addToCartButton.loadingIndicator(true)
                
                CartManager.cartID { (cartID) in
                    guard let cartID = cartID else { return }
                    let attributes = self.customizeView.selectedAttributes["size"]! + "," + self.customizeView.selectedAttributes["color"]!
                    self.viewModel.addProduct(cartID: cartID, productID: self.productID, attributes: attributes)
                }
                
            })
            .disposed(by: disposeBag)
        
        // animate constraint :
        let tapOnCustomize = UITapGestureRecognizer()
        customizeViewAsButton.addGestureRecognizer(tapOnCustomize)
        
        tapOnCustomize.rx.event.bind { [weak self] (recognizer) in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.4) {
                self.customizeViewConstraint.constant = self.customizeOn ? -240 : 0
                self.customizeView.alpha = self.customizeOn ? 0 : 1
                self.expandIconImageView.transform = self.customizeOn ? .identity : CGAffineTransform(rotationAngle:  0.999 * CGFloat.pi)
                self.customizeOn.toggle()
                self.view.layoutIfNeeded()
            }
        }.disposed(by: disposeBag)
        
        imagesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
    }
    
    func initVM() {
        
        viewModel.errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self ] message in
                guard let self = self else { return }
                NotificationBannerManager.show(title: "Network Error!", message: message, style: .warning)
                self.addToCartButton.setTitle("ADD TO CART", for: .normal)
                self.addToCartButton.loadingIndicator(false)
            })
            .disposed(by: disposeBag)
        
        viewModel.successMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:{ [weak self ] message in
                guard let self = self else { return }
                NotificationBannerManager.show(title: "added successfully", message: message, style: .success)
                self.addToCartButton.setTitle("ADD TO CART", for: .normal)
                self.addToCartButton.loadingIndicator(false)
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
                        self.loadingView.alpha = 1.0
                    }
                case .success:
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2) {
                        self.loadingView.alpha = 0.0
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.productDetails
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] productDetails in
                guard let self = self else { return }
                self.configureViewWith(productDetails)
            })
            .disposed(by: disposeBag)
        
        viewModel.productImageCellViewModels.bind(to: imagesCollectionView.rx.items(cellIdentifier: "ProductImageCell")) {
            (row, cellViewModel, cell: ProductImageCell) in
            cell.productImageCellViewModel = cellViewModel
        }.disposed(by: disposeBag)
        
        viewModel.getProductDetails(self.productID)
    }
    
    private func configureViewWith(_ productDetails: ProductDetails) {
        nameLabel.text = productDetails.name
        descriptionLabel.text = productDetails.description
        discountedPriceLabel.text = "$\(productDetails.discountedPrice)"
        
        if productDetails.discountedPrice == "0.00" {
            discountedPriceLabel.isHidden = true
            priceLabel.textColor = #colorLiteral(red: 0.1960259676, green: 0.1960259676, blue: 0.1960259676, alpha: 1)
            priceLabel.attributedText = NSAttributedString(string: "$\(productDetails.price)")
        } else {
            discountedPriceLabel.isHidden = false
            priceLabel.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            priceLabel.attributedText = NSAttributedString(string: "$\(productDetails.price)", attributes: [NSAttributedString.Key.strikethroughStyle : 2])
        }
        
    }
    
}


extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / imagesCollectionView.frame.size.width)
        imagesPageControl.currentPage = currentIndex
    }
    
}
