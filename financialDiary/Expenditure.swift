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
}
