//
//  CompareView.swift
//  financialDiary
//
//  Created by Dong Truong on 4/1/21.
//

import UIKit

class CompareView: UIViewController {
    var totalMoneyOfThisMonth = Money(amount: 0)
    var totalMoneyOfPreviousMonth = Money(amount: 0)
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
        
        totalMoneyOfPreviousMonth.calculate(from: previousMonthList)
        
        totalMoneyOfThisMonth.show(label: thisMonthLabel, color: nil)
        totalMoneyOfPreviousMonth.show(label: previousMonthLabel, color: nil)
        
        radius = 100
        setUpCircularProgressBarView()
        
    }
    
    func setUpCircularProgressBarView() {
        var percent = 0
        
        if totalMoneyOfThisMonth.amount < totalMoneyOfPreviousMonth.amount {
            statusLabel.text = "Reduced by"
            percentLabel.textColor = .red
            progressColor = UIColor.red.cgColor
        } else {
            statusLabel.text = "Increased by"
            percentLabel.textColor = .systemGreen
            progressColor = UIColor.systemGreen.cgColor
        }
    
        if totalMoneyOfPreviousMonth.amount == 0 {
            percent = totalMoneyOfThisMonth.amount *  100
        } else {
            percent = abs((totalMoneyOfPreviousMonth.amount - totalMoneyOfThisMonth.amount) / totalMoneyOfPreviousMonth.amount) * 100
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
