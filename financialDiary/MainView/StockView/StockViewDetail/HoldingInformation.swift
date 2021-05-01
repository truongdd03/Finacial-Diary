//
//  HoldingInformation.swift
//  financialDiary
//
//  Created by Dong Truong on 4/30/21.
//

import UIKit

class HoldingInformation: NSObject, Codable {
    var quantity: Double {
        didSet {
            self.totalCost = self.costPrice * self.quantity
            self.marketValue = self.marketPrice * self.quantity
            self.profit = (self.marketValue - self.totalCost) / self.totalCost * 100
        }
    }
    var costPrice: Double {
        didSet {
            self.costPrice = round(self.costPrice * 100)/100
            self.totalCost = self.costPrice * self.quantity
            self.profit = (self.marketValue - self.totalCost) / self.totalCost * 100
        }
    }
    var totalCost: Double {
        didSet {
            self.totalCost = round(self.totalCost * 100)/100
        }
    }
    var marketPrice: Double {
        didSet {
            self.marketValue = self.marketPrice * self.quantity
        }
    }
    var marketValue: Double {
        didSet {
            self.marketValue = round(self.marketValue * 100)/100
            self.profit = (self.marketValue - self.totalCost) / self.totalCost * 100
        }
    }
    var profit: Double {
        didSet {
            self.profit = round(self.profit * 100)/100
        }
    }
    
    init(quantity: Double, costPrice: Double, marketPrice: Double) {
        self.quantity = quantity
        self.costPrice = round(costPrice * 100) / 100
        self.totalCost = round(self.costPrice * self.quantity * 100) / 100
        self.marketPrice = marketPrice
        self.marketValue = round(marketPrice * self.quantity * 100) / 100
        self.profit = (self.marketValue - self.totalCost) / self.totalCost * 100
        self.profit = round(self.profit * 100) / 100
    }
    
    func buy(quantity: Double, price: Double) {
        self.costPrice = (self.costPrice * self.quantity + price * quantity) / (self.quantity + quantity)
        self.quantity += quantity
    }
    
    func sell(quantity: Double, price: Double) {
        self.quantity -= quantity
    }
    
    func updateMarketPrice(price: Double) {
        self.marketPrice = price
    }
    
    func rnd(number: Double) -> Double {
        return round(number * 100)/100
    }
}
