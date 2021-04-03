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
    var previousMonthList:[Expenditure] = allMonthsLists.last!.list
    
    var circularProgressBarView: ProgressView!
    var circularViewDuration: TimeInterval = 1
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var previousMonthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Compare"
        calculateTotalMoneyOfPreviousMonth()
        showLabel(labelName: thisMonthLabel, amountOfMoney: totalMoneyOfThisMonth)
        showLabel(labelName: previousMonthLabel, amountOfMoney: totalMoneyOfPreviousMonth)
        
        radius = 100
        setUpCircularProgressBarView()
        
    }

    func calculateTotalMoneyOfPreviousMonth() {
        totalMoneyOfPreviousMonth = 0
        
        for item in previousMonthList {
            totalMoneyOfPreviousMonth += item.amountOfMoneySpent
        }
    }
    
    func showLabel(labelName: UILabel, amountOfMoney: Int) {
        let formattedNumber = reformatNumber(number: amountOfMoney)
        
        labelName.text = "\(formattedNumber)$"
        labelName.textColor = .red
        
        if amountOfMoney >= 0 {
            labelName.textColor = .systemGreen
            labelName.text = "+\(formattedNumber)$"
        }
    }
    
    func reformatNumber(number: Int) -> String {
        let formater = NumberFormatter()
        
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: number))!
        
        return formattedNumber
    }
    
    func setUpCircularProgressBarView() {
        var percent = 0
        
        if totalMoneyOfThisMonth < totalMoneyOfPreviousMonth {
            statusLabel.text = "Reduced by"
            percentLabel.textColor = .red
            progressColor = UIColor.red.cgColor
        } else {
            statusLabel.text = "Increased by"
            percentLabel.textColor = .systemGreen
            progressColor = UIColor.systemGreen.cgColor
        }
    
        if totalMoneyOfPreviousMonth == 0 {
            percent = totalMoneyOfThisMonth *  100
        } else {
            percent = abs((totalMoneyOfPreviousMonth - totalMoneyOfThisMonth) / totalMoneyOfPreviousMonth) * 100
        }
        percentLabel.text = "\(percent)%"
        
        circularProgressBarView = ProgressView(frame: .zero)
        circularProgressBarView.center = view.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration, to: 1.0)

        view.addSubview(circularProgressBarView)
    }

    @IBAction func detailButtonClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "DetailCompareView") as? DetailCompareView {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
