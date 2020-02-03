//
//  OrderStatusCell.swift
//  Storex
//
//  Created by admin on 2/3/20.
//  Copyright © 2020 KerollesRoshdi. All rights reserved.
//

import UIKit

class OrderStatusCell: UITableViewCell {
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var creationDayLabel: UILabel!
    @IBOutlet weak var creationDateLabel: UILabel!
    
    @IBOutlet weak var step1view: UIView!
    @IBOutlet weak var step1point: UIImageView!
    @IBOutlet weak var step2view: UIView!
    @IBOutlet weak var step2point: UIImageView!
    @IBOutlet weak var step3view: UIView!
    @IBOutlet weak var step3point: UIImageView!
    @IBOutlet weak var step4view: UIView!
    
    var orderCellViewModel: OrderStatusCellViewModel? {
        didSet {
            orderIDLabel.text = orderCellViewModel?.orderID
            orderAmountLabel.text = "$\(orderCellViewModel?.orderAmount ?? "00.00")"
            creationDayLabel.text = "Placed on \(orderCellViewModel?.creationDay ?? "--"),"
            creationDateLabel.text = orderCellViewModel?.creationDate
            configureStatusProgress(status: orderCellViewModel?.status ?? -1)
        }
    }
    
    private func configureStatusProgress(status: Int) {
        if status == 0 {
            step1view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step1point.tintColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
        } else if status == 1 {
            step1view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step1view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step1point.tintColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step2point.tintColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
        } else if status > 1 {
            step1view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step1view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step3view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step4view.backgroundColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step1point.tintColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step2point.tintColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
            step3point.tintColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
