//
//  Stock.swift
//  financialDiary
//
//  Created by Dong Truong on 4/18/21.
//

import Foundation

struct Stock {
    var name = ""
    var date = ""
    var prices = [StockPrice]()
    
    init(name: String, date: String, prices: [StockPrice]) {
        self.name = name
        self.date = date
        self.prices = prices
    }
}
