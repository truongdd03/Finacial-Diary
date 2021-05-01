//
//  ViewController.swift
//  financialDiary
//
//  Created by Dong Truong on 4/29/21.
//

import UIKit

class StockViewDetail: UIViewController {
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var costPriceLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var marketValueLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    
    var stock: Stock?

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentageWrapper: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let stock = stock else { return }
        
        title = stock.name
        dateLabel.text = "Closing price(\(todayDate))"
        priceLabel.text = "\(stock.prices[0].close)$"
        percentageLabel.text = stock.percentage
        percentageWrapper.backgroundColor = colorOfWrapper()
        
        if informationOfStocks[stock.name] == nil {
            informationOfStocks[stock.name] = HoldingInformation(quantity: 0, costPrice: 0, marketPrice: 0)
        }
        informationOfStocks[stock.name]!.updateMarketPrice(price: Double(stock.prices[0].close)!)
        showLabel()
    }
    
    func colorOfWrapper() -> UIColor {
        let tmp = stock!.percentage
        if tmp.first == "+" {
            return .systemGreen
        } else if tmp.first == "-" {
            return .systemRed
        }
        return .systemYellow
    }

    func updateLabel(value: Double, label: UILabel) {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: value))!
        
        label.text = formattedNumber
    }
    
    @IBAction func buyButtonClicked(_ sender: Any) {
        let ac = UIAlertController(title: "Buy \(stock!.name)", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        
        ac.textFields![0].placeholder = "Enter quantity"
        ac.textFields![1].placeholder = "Enter price"
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Go", style: .default) { [weak self, weak ac] action in
            guard let quantity = ac?.textFields?[0].text else { return }
            guard let price = ac?.textFields?[1].text else { return }
            self?.buy(quantity: quantity, price: price)
        })
        
        present(ac, animated: true)
    }
    
    @IBAction func sellButtonClicked(_ sender: Any) {
        let ac = UIAlertController(title: "Sell \(stock!.name)", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addTextField()
        
        ac.textFields![0].placeholder = "Enter quantity"
        ac.textFields![1].placeholder = "Enter price"
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Go", style: .default) { [weak self, weak ac] action in
            guard let quantity = ac?.textFields?[0].text else { return }
            guard let price = ac?.textFields?[1].text else { return }
            self?.sell(quantity: quantity, price: price)
        })
        
        present(ac, animated: true)
    }
    
    func checkInt(text: String) -> Bool{
        guard let tmp = Int(text) else {
            showError(title: "Invalid quantity")
            return false
        }
        if tmp <= 0 {
            showError(title: "Invalid quantity")
            return false
        }
        return true
    }
    
    func checkDouble(text: String) -> Bool{
        guard let tmp = Double(text) else {
            showError(title: "Invalid price")
            return false
        }
        if tmp < 0 {
            showError(title: "Invalid price")
            return false
        }
        return true
    }
    
    func findExpenditureId(name: String) -> Int {
        for i in 0..<list.count {
            if list[i].name == name {
                return i
            }
        }
        return -1
    }
    
    func updateExpenditureList(amount: Double, isExpenditure: Bool) {
        var name = "Sell \(stock!.name)"
        if isExpenditure {
            name = "Buy \(stock!.name)"
        }
        var id = findExpenditureId(name: name)
        if id == -1 {
            list.append(Expenditure(name: name, amountOfMoneySpent: Money(amount: 0), isExpenditure: isExpenditure, history: []))
            id = list.count - 1
        }
        list[id].addHistory(amount: amount)
    }
    
    func buy(quantity: String, price: String) {
        if checkInt(text: quantity) && checkDouble(text: price) {
            let o = Double(quantity)!
            let u = Double(price)!
            informationOfStocks[stock!.name]!.buy(quantity: o, price: u)
            updateExpenditureList(amount: o*u, isExpenditure: true)
            showLabel()
        }
    }
    
    func sell(quantity: String, price: String) {
        if checkInt(text: quantity) && checkDouble(text: price) {
            let o = Double(quantity)!
            let u = Double(price)!
            if o > informationOfStocks[stock!.name]!.quantity {
                showError(title: "Don't have enough stocks to sell")
                return
            }
            if o == informationOfStocks[stock!.name]!.quantity {
                informationOfStocks[stock!.name]!.costPrice = 0
            }
            informationOfStocks[stock!.name]!.sell(quantity: o, price: u)
            updateExpenditureList(amount: o*u, isExpenditure: false)
            showLabel()
        }
    }
    
    func showError(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func showLabel() {
        guard let information = informationOfStocks[stock!.name] else { return }
        
        quantityLabel.text = "\(information.quantity)"
        updateLabel(value: information.costPrice, label: costPriceLabel)
        updateLabel(value: information.totalCost, label: totalCostLabel)
        updateLabel(value: information.marketValue, label: marketValueLabel)
        if information.totalCost == 0 {
            information.profit = 0
        }
        profitLabel.text = "\(information.profit)%"
                
        if information.profit == 0 {
            profitLabel.textColor = .yellow
        } else if information.profit > 0 {
            profitLabel.textColor = .systemGreen
        } else {
            profitLabel.textColor = .red
        }
    }
}
