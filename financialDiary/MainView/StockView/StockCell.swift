//
//  StockCell.swift
//  financialDiary
//
//  Created by Dong Truong on 4/18/21.
//

import UIKit

class StockCell: UITableViewCell {
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    @IBOutlet weak var percentageWrapper: UIView!
    
    var stock: Stock? {
        didSet {
            if let stock = stock {
                stockName.text = stock.name
                stockPrice.text = stock.prices[0].close + "$"
                
                let tmp = stock.percentage
                if tmp.first == "+" {
                    percentageWrapper.backgroundColor = .systemGreen
                } else if tmp.first == "-" {
                    percentageWrapper.backgroundColor = .systemRed
                } else {
                    percentageWrapper.backgroundColor = .systemYellow
                }
                percentage.text = tmp
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let border = CALayer()
        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: contentView.frame.size.height - 1, width: contentView.frame.size.width + 70, height: 1)
        contentView.layer.addSublayer(border)
    }
    
}
