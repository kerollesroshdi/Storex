//
//  UIViewController-Extension.swift
//  Storex
//
//  Created by admin on 1/23/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

extension UIViewController {
    func setNavigationTitleImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "nav-logo")!
        self.navigationItem.titleView = imageView
    }
}
