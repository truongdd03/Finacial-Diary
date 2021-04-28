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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
