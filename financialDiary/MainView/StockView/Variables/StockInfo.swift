//
//  StockInfo.swift
//  financialDiary
//
//  Created by Dong Truong on 4/14/21.
//

import Foundation

struct RootOfStockInfo: Codable {
    var data: StockInfo
    
    private enum CodingKeys: String, CodingKey {
        case data = "Meta Data"
    }
}
struct StockInfo: Codable {
    var symbol: String
    var date: String
    
    private enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
        case date = "3. Last Refreshed"
    }
}
