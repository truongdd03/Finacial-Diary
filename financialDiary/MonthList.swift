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
    
    init(list: [Expenditure], month: String) {
        self.list = list
        self.month = month
    }
}
