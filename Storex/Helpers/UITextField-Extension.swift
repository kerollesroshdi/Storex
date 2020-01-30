//
//  UITextField-Extension.swift
//  Storex
//
//  Created by admin on 1/30/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

extension UITextField {
    
    func addBottomBorder() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
    }
    
}
