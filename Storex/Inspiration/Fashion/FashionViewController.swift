//
//  FashionViewController.swift
//  Storex
//
//  Created by admin on 2/4/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class FashionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let articles: [FashionArticle] = [
        FashionArticle(title: "Winter sale", image: #imageLiteral(resourceName: "fashion-model-8")),
        FashionArticle(title: "casual", image: #imageLiteral(resourceName: "fashion-model-6")),
        FashionArticle(title: "Winter men", image: #imageLiteral(resourceName: "fashion-model-1")),
        FashionArticle(title: "classic", image: #imageLiteral(resourceName: "fashion-model-4")),
        FashionArticle(title: "formal", image: #imageLiteral(resourceName: "fashion-model-5")),
        FashionArticle(title: "trending", image: #imageLiteral(resourceName: "fashion-model-7")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register nibs:
        collectionView.registerCellNib(cellClass: FashionCell.self)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension FashionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as FashionCell
        cell.fashionArticle = articles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 + 60
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = collectionView.bounds.width / 4 - 30
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let fashionCollectionVC = storyboard?.instantiateViewController(withIdentifier: "FashionCollectionViewController") as? FashionCollectionViewController {
            fashionCollectionVC.fashionArticle = articles[indexPath.row]
            presentDetail(fashionCollectionVC)
        }
    }
    
}

struct FashionArticle {
    let title: String
    let image: UIImage
}
