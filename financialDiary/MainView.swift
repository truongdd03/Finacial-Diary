//
//  MainView.swift
//  financialDiary
//
//  Created by Dong Truong on 3/31/21.
//

import UIKit

class MainView: UIViewController {
    var titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
    var circularProgressBarView: ProgressView!
    var previousPercent = 0
    var goal = 10000000
    var percent = 0 {
        didSet {
            percentLabel.text = "\(percent)%"
            let toValue: CGFloat = CGFloat(percent) / 100
            setUpCircularProgressBarView(to: toValue)
            previousPercent = percent
        }
    }

    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
        
        title = "Financial Diary"
        showTotalMoney()
        
    }

    var circularViewDuration: TimeInterval = 1

    func setUpCircularProgressBarView(to toValue: CGFloat) {
        circularProgressBarView = ProgressView(frame: .zero)
        circularProgressBarView.center = view.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration, to: toValue)

        view.addSubview(circularProgressBarView)
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
        
        if totalMoney <= 0 {
            percent = 0
            return
        }
        
        let tmp:CGFloat = CGFloat(totalMoney) / CGFloat(goal)
        let value = min(Int(tmp*100), 100)
        if value != percent {
            percent = value
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
