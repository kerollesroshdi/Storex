//
//  UITableViewNibExtension.swift
//  Mosand
//
//  Created by admin on 10/29/19.
//  Copyright © 2019 Mosandah. All rights reserved.
//

import UIKit

extension UITableView {
    
     func registerHeaderNib<Cell: UITableViewHeaderFooterView>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
         self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
     }
     
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else { fatalError("Error dequeuing cell") }
        return cell
    }
}
