//
//  StockView.swift
//  financialDiary
//
//  Created by Dong Truong on 4/14/21.
//

import UIKit

var todayDate = "2021-04-26"
var yesterdayDate = "2021-04-25"
class StockView: UITableViewController {
    var listOfStocks = [Stock]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let customCell = UINib(nibName: "StockCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "StockCell")
        
        load()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCell))
    }

    @objc func addCell() {
        let ac = UIAlertController(title: "Add stock", message: "Enter a stock symbol", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            self?.add(text: text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
    }

    func add(text: String) {
        var tmp = getInformationOfStock(stock: text)
        if tmp == nil {
            showAlert(text: "Your stock doesn't exist")
        } else {
            tmp!.name = tmp!.name.uppercased()
            
            for item in listOfStocks {
                if item.name == tmp?.name {
                    showAlert(text: "Stock existed")
                    return
                }
            }
            
            listOfStocks.insert(tmp!, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            save()
        }
        
    }
    
    func showAlert(text: String) {
        let ac = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    func getInformationOfStock(stock: String) -> Stock?{
        let apiKey = "RFY0FTDRI3L71DN1"
        let url = "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY_ADJUSTED&symbol=\(stock)&apikey=\(apiKey)"
        
        print(url)
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
        
        if let info = try? decoder.decode(RootOfStockInfo.self, from: json) {
            stock.date = info.data.date
            stock.name = info.data.symbol
        } else { return nil }
        
        if let prices = try? decoder.decode(RootOfPrices.self, from: json) {
            stock.prices = prices.list.prices
        } else { return nil }
        
        return stock
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfStocks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as! StockCell
        cell.stock = listOfStocks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != UITableViewCell.EditingStyle.delete { return }
                
        listOfStocks.remove(at: indexPath.row)
        list.remove(at: indexPath.row)
        save()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(listOfStocks) {
            let defaults = UserDefaults.standard
            
            defaults.setValue(savedData, forKey: "listOfStocks")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
                
        if let savedData = defaults.object(forKey: "listOfStocks") as? Data {
            let jsonDecoder = JSONDecoder()
            listOfStocks = try! jsonDecoder.decode([Stock].self, from: savedData)
        }
    }
}
