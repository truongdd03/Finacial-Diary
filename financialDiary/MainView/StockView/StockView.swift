//
//  StockView.swift
//  financialDiary
//
//  Created by Dong Truong on 4/14/21.
//

import UIKit

class StockView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(getInformationOfStock(stock: "AAPL"))
    }

    func getInformationOfStock(stock: String) -> Stock?{
        let apiKey = "RFY0FTDRI3L71DN1"
        let url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(stock)&apikey=\(apiKey)"
        
        if let url = URL(string: url) {
            if let data = try? Data(contentsOf: url) {
                return parseStockInfo(json: data)
            }
        }
        return nil
    }
    
    func parseStockInfo(json: Data) -> Stock?{
        let decoder = JSONDecoder()
        var stock = Stock(name: "", date: "", prices: [])
        
        let info = try! decoder.decode(RootOfStockInfo.self, from: json)
        stock.date = info.data.date
        stock.name = info.data.symbol
        
        let prices = try! decoder.decode(RootOfPrices.self, from: json)
        stock.prices = prices.list.prices
        
        return stock
    }
}
