//
//  FashionCollectionViewController.swift
//  Storex
//
//  Created by admin on 2/4/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class FashionCollectionViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fashionArticle: FashionArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // register nibs:
        collectionView.registerCellNib(cellClass: ImageCell.self)
        
        titleLabel.text = fashionArticle?.title.uppercased()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }
    
}

extension FashionCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as ImageCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 4)
        return CGSize(width: width - 2, height: width - 2)
    }
    
    
}
