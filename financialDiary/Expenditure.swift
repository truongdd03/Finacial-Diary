//
//  expenditure.swift
//  financialDiary
//
//  Created by Dong Truong on 3/30/21.
//

import UIKit

class Expenditure: NSObject, Codable {
    var name: String
    var amountOfMoneySpent: Int
    var isExpenditure: Bool
    var history: [String]
    var textColor: String
    
    init(name: String, amountOfMoneySpent: Int, isExpenditure: Bool, history: [String], textColor: String) {
        self.name = name
        self.amountOfMoneySpent = amountOfMoneySpent
        self.isExpenditure = isExpenditure
        self.history = history
        self.textColor = textColor
    }
}
