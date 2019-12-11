//
//  UICollectionViewNibExtension.swift
//  Storex
//
//  Created by admin on 12/11/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCellNib<Cell: UICollectionViewCell>(cellClass: Cell.Type){
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeue<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell{
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }
    
}
