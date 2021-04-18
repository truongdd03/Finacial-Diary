//
//  Price.swift
//  financialDiary
//
//  Created by Dong Truong on 4/15/21.
//

import Foundation

struct RootOfPrices: Codable {
    var list: Prices
    
    private enum CodingKeys: String, CodingKey {
        case list = "Time Series (Daily)"
    }
}

struct Prices: Codable {
    var prices: [StockPrice]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        var tempArray = [StockPrice]()
        
        for key in container.allKeys {
            let decodeObject = try container.decode(StockPrice.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodeObject)
        }
        
        prices = tempArray
    }
}

struct StockPrice: Codable {
    var close: String
    var volume: String
    
    private enum CodingKeys: String, CodingKey {
        case close = "4. close"
        case volume = "6. volume"
    }
}
