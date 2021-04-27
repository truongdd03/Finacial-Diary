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
                let todayPrice = stock.prices[0].close
                let yesterdayPrice = stock.prices[1].close
                stockPrice.text = todayPrice
            
                let o = Double(todayPrice)!
                let u = Double(yesterdayPrice)!
                let tmp = round((o-u)/u * 100 * 100) / 100
                if o > u {
                    percentageWrapper.backgroundColor = .systemGreen
                    percentage.text = "+\(tmp)%"
                } else if o < u {
                    percentageWrapper.backgroundColor = .systemRed
                    percentage.text = "\(tmp)%"
                } else {
                    percentageWrapper.backgroundColor = .systemYellow
                    percentage.text = "0.0%"
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        percentageWrapper.layer.cornerRadius = 0.5
    }
    
}
