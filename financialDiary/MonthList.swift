//
//  AllLists.swift
//  financialDiary
//
//  Created by Dong Truong on 4/1/21.
//

import UIKit

class MonthList: NSObject, Codable {
    var month = ""
    var list = [Expenditure]()
    var totalMoney = 0
    
    init(list: [Expenditure], month: String, totalMoney: Int) {
        self.list = list
        self.month = month
        self.totalMoney = totalMoney
    }
}
