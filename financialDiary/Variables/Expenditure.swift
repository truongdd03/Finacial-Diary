//
//  expenditure.swift
//  financialDiary
//
//  Created by Dong Truong on 3/30/21.
//

import UIKit

class Expenditure: NSObject, Codable {
    var name: String
    var amountOfMoneySpent: Money
    var isExpenditure: Bool
    var history: [String]
    
    init(name: String, amountOfMoneySpent: Money, isExpenditure: Bool, history: [String]) {
        self.name = name
        self.amountOfMoneySpent = amountOfMoneySpent
        self.isExpenditure = isExpenditure
        self.history = history
    }
    
    func addHistory(amount: Double) {
        var tmp = Money(amount: amount)
        
        if self.isExpenditure {
            tmp.amount *= -1
        }
        
        self.amountOfMoneySpent.amount += tmp.amount
        
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm E, d MMM y"
                
        self.history.insert("\(formatter1.string(from: today)): \(tmp.reformatNumber())", at: 0)
    }
}
