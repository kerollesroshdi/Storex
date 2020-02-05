//
//  LifeArticleViewController.swift
//  Storex
//
//  Created by admin on 2/4/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class LifeArticleViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var articleLabel: UILabel!
    
    var lifeArticle: LifeArticle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mask = UIImageView(image: #imageLiteral(resourceName: "Shape"))
        mask.contentMode = .scaleAspectFit
        mask.frame = image.bounds
        image.mask = mask
        
        dateLabel.text = lifeArticle?.date.uppercased()
        titleLabel.text = lifeArticle?.title.uppercased()
        image.image = lifeArticle?.image
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }
    
}
