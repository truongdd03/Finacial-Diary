//
//  CompareView.swift
//  financialDiary
//
//  Created by Dong Truong on 4/1/21.
//

import UIKit

class CompareView: UIViewController {
    var totalMoneyOfThisMonth = 0
    var totalMoneyOfPreviousMonth = 0
    
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var previousMonthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Compare"
        calculateTotalMoneyOfPreviousMonth()
        showLabel(labelName: thisMonthLabel, amountOfMoney: totalMoneyOfThisMonth)
        showLabel(labelName: previousMonthLabel, amountOfMoney: totalMoneyOfPreviousMonth)
        
    }

    func calculateTotalMoneyOfPreviousMonth() {
        totalMoneyOfPreviousMonth = 0
        
        for item in previousMonthList {
            totalMoneyOfPreviousMonth += item.amountOfMoneySpent
        }
    }
    
    func showLabel(labelName: UILabel, amountOfMoney: Int) {
        let formattedNumber = reformatNumber(number: amountOfMoney)
        
        labelName.text = "\(formattedNumber)VND"
        labelName.textColor = .red
        
        if amountOfMoney >= 0 {
            labelName.textColor = .systemGreen
            labelName.text = "+\(formattedNumber)VND"
        }
    }
    
    func reformatNumber(number: Int) -> String {
        let formater = NumberFormatter()
        
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: number))!
        
        return formattedNumber
    }
}
