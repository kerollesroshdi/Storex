//
//  MaskedUIImageView.swift
//  Storex
//
//  Created by admin on 2/5/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

@IBDesignable
class MaskedUIImageView: UIImageView {

    var maskImageView = UIImageView()
    
    @IBInspectable
    var maskImage: UIImage? {
        didSet {
            maskImageView.image = maskImage
            maskImageView.frame = bounds
            maskImageView.contentMode = .scaleAspectFit
            mask = maskImageView
        }
    }

}
