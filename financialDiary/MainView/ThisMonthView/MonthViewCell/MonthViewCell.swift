//
//  MonthViewCell.swift
//  financialDiary
//
//  Created by Dong Truong on 4/28/21.
//

import UIKit

class MonthViewCell: UITableViewCell {
    @IBOutlet weak var expenditureName: UILabel!
    @IBOutlet weak var amountOfMoney: UILabel!

    var expenditure: Expenditure? {
        didSet {
            if let expenditure = expenditure {
                expenditureName.text = expenditure.name
                amountOfMoney.text = String(expenditure.amountOfMoneySpent.reformatNumber()) + "$"
                expenditureName.textColor = colorOf(expenditure)
                amountOfMoney.textColor = colorOf(expenditure)
            }
        }
    }
    
    var monthInformation: MonthList? {
        didSet {
            if let monthInformation = monthInformation {
                if monthInformation.month == "" { return }
                expenditureName.text = monthInformation.month
                
                let tmp = monthInformation.totalMoney.amount
                if tmp < 0 {
                    amountOfMoney.textColor = .red
                } else {
                    amountOfMoney.textColor = .systemGreen
                }
                
                amountOfMoney.text = "\(monthInformation.totalMoney.amount)$"
            }
        }
    }
    
    func colorOf(_ expenditure: Expenditure) -> UIColor {
        if expenditure.isExpenditure {
            return .red
        } else {
            return .systemGreen
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let border = CALayer()
        border.backgroundColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: contentView.frame.size.height - 1, width: contentView.frame.size.width, height: 1)
        contentView.layer.addSublayer(border)
    }
}
