//
//  LifeViewController.swift
//  Storex
//
//  Created by admin on 2/3/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class LifeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let articles: [LifeArticle] = [
        LifeArticle(date: "JAN, 11 2020", title: "what about style?", image: #imageLiteral(resourceName: "fashion-model-8")),
        LifeArticle(date: "JAN, 12 2020", title: "winter is here", image: #imageLiteral(resourceName: "fashion-model-1")),
        LifeArticle(date: "FEB, 30 2020", title: "shopping tips and tricks", image: #imageLiteral(resourceName: "fashion-model-2")),
        LifeArticle(date: "MAR, 1 2020", title: "formal or semi-formal?", image: #imageLiteral(resourceName: "fashion-model-3")),
        LifeArticle(date: "MAR, 3 2020", title: "suits for him", image: #imageLiteral(resourceName: "fashion-model-4")),
        LifeArticle(date: "APR, 15 2020", title: "casual for her", image: #imageLiteral(resourceName: "fashion-model-6")),
        LifeArticle(date: "APR, 20 2020", title: "trending high cole", image: #imageLiteral(resourceName: "fashion-model-7")),
        LifeArticle(date: "MAY, 17 2020", title: "fashion for work", image: #imageLiteral(resourceName: "fashion-model-9")),
        LifeArticle(date: "JAN, 11 2020", title: "interview style?", image: #imageLiteral(resourceName: "fashion-model-5")),
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register nibs:
        collectionView.registerCellNib(cellClass: LifeCell.self)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension LifeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as LifeCell
        cell.lifeArticle = articles[indexPath.row]
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
        if let lifeArticleVC = storyboard?.instantiateViewController(withIdentifier: "LifeArticleViewController") as? LifeArticleViewController {
            lifeArticleVC.lifeArticle = articles[indexPath.row]
            presentDetail(lifeArticleVC)
        }
    }
    
}


struct LifeArticle {
    let date: String
    let title: String
    let image: UIImage
}
