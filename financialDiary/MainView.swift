//
//  MainView.swift
//  financialDiary
//
//  Created by Dong Truong on 3/31/21.
//

import UIKit

class MainView: UIViewController {
    var titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
    
    @IBOutlet weak var totalMoneyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
        
        title = "Financial Diary"
        showTotalMoney()
    }

    func calculateTotalMoney() -> Int {
        var totalMoney = 0
        for item in list {
            totalMoney += item.amountOfMoneySpent
        }
        return totalMoney
    }
    
    func showTotalMoney() {
        let totalMoney = calculateTotalMoney()
        let formater = NumberFormatter()
        
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: totalMoney))!
        totalMoneyLabel.text = "\(formattedNumber)VND"
        
        totalMoneyLabel.textColor = .red
        if totalMoney >= 0 {
            totalMoneyLabel.textColor = .systemGreen
            totalMoneyLabel.text = "+\(formattedNumber)VND"
        }
    }
    
    @IBAction func detailButtonClicked(_ sender: Any) {
         if let vc = storyboard?.instantiateViewController(identifier: "TableView") as? ViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleColor
        
        showTotalMoney()
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "list") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                list = try jsonDecoder.decode([Expenditure].self, from: savedData)
            } catch {
                print("Failed to load")
            }
        }
    }

}
