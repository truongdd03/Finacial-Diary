//
//  Money.swift
//  financialDiary
//
//  Created by Dong Truong on 4/3/21.
//

import UIKit

struct Money: Codable {
    var amount = 0

    init(amount: Int) {
        self.amount = amount
    }
    
    func reformatNumber() -> String {
        let formater = NumberFormatter()
        
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: self.amount))!
        
        return formattedNumber
    }
    
    mutating func calculate(from list: [Expenditure]) {
        self.amount = 0
        for item in list {
            self.amount += item.amountOfMoneySpent.amount
        }
    }
    
    func show(label: UILabel, color: UIColor?) {
        let tmp = reformatNumber()
        var textColor = color
        
        if textColor == nil {
            if self.amount >= 0 { textColor = .systemGreen }
            else { textColor = .red }
        }
        
        if self.amount >= 0 {
            label.text = "+\(tmp)$"
        } else {
            label.text = "\(tmp)$"
        }
        label.textColor = textColor
    }
}
