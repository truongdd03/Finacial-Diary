//
//  Stock.swift
//  financialDiary
//
//  Created by Dong Truong on 4/18/21.
//

import Foundation

struct Stock:Codable {
    var name = ""
    var date = ""
    var prices = [StockPrice]() {
        didSet {
            if prices.count >= 2 {
                self.calculatePercentage()
            }
        }
    }
    var percentage = ""
    
    init(name: String, date: String, prices: [StockPrice]) {
        self.name = name
        self.date = date
        self.prices = prices
    }
    
    mutating func calculatePercentage() {
        let todayPrice = prices[0].close
        let yesterdayPrice = prices[1].close
        let o = Double(todayPrice)!
        let u = Double(yesterdayPrice)!
        
        let tmp = round((o-u)/u * 100 * 100) / 100
        if o > u {
            self.percentage = "+\(tmp)%"
        } else if o < u {
            self.percentage = "\(tmp)%"
        } else {
            self.percentage = "0.00%"
        }
    }
    
}
