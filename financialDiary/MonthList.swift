//
//  AllLists.swift
//  financialDiary
//
//  Created by Dong Truong on 4/1/21.
//

import UIKit

class MonthList: NSObject, Codable {
    var list = [Expenditure]()
    
    init(list: [Expenditure]) {
        self.list = list
    }
}
