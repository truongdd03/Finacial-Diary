//
//  MainView.swift
//  financialDiary
//
//  Created by Dong Truong on 3/31/21.
//

import UIKit

var radius:CGFloat = 130
var progressColor:CGColor = UIColor.systemGreen.cgColor
var allMonthsLists = [MonthList]()

class MainView: UIViewController {
    var titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
    var circularProgressBarView: ProgressView!
    var previousPercent = 0
    var goal = 1 {
        didSet {
            save()
            goalLabel.text = "\(reformatNumber(number: goal))"
            goalLabel.textColor = .systemYellow
            showTotalMoney()
        }
    }
    var percent = 0 {
        didSet {
            percentLabel.text = "\(percent)%"
            percentLabel.textColor = .systemYellow
            let toValue: CGFloat = CGFloat(percent) / 100
            setUpCircularProgressBarView(to: toValue)
            previousPercent = percent
        }
    }
    
    var totalMoney = 0

    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
        
        title = "Financial Diary"
        showTotalMoney()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set goal", style: .plain, target: self, action: #selector(addGoal))
    }

    @objc func addGoal() {
        let ac = UIAlertController(title: "Type your goal", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            
            if text.count > 10 {
                self?.showError(title: "Too big number")
                return
            }
            
            if let number = Int(text) {
                self?.goal = number
            } else {
                self?.showError(title: "Invalid number")
            }
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func showError(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }

    var circularViewDuration: TimeInterval = 1

    func setUpCircularProgressBarView(to toValue: CGFloat) {
        circularProgressBarView = ProgressView(frame: .zero)
        circularProgressBarView.center = view.center
        circularProgressBarView.progressAnimation(duration: circularViewDuration, to: toValue)

        view.addSubview(circularProgressBarView)
    }

    func calculateTotalMoney() {
        totalMoney = 0
        for item in list {
            totalMoney += item.amountOfMoneySpent
        }
    }
    
    func showTotalMoney() {
        calculateTotalMoney()
        let formattedNumber = reformatNumber(number: totalMoney)
        
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
        
        if goal == 0 {
            percent = 100
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
    
    @IBAction func compareButtonClicked(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "CompareView") as? CompareView {
            vc.totalMoneyOfThisMonth = totalMoney
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleColor
        navigationController?.isToolbarHidden = true
        radius = 130
        progressColor = UIColor.systemGreen.cgColor
        showTotalMoney()
    }
    
    func reformatNumber(number: Int) -> String {
        let formater = NumberFormatter()
        
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: number))!
        
        return formattedNumber
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
        
        if let savedData = defaults.object(forKey: "goal") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                goal = try jsonDecoder.decode(Int.self, from: savedData)
            } catch {
                print("Failed to load")
            }
        } else {
            goal = 0
        }
        
        if let savedData = defaults.object(forKey: "previousMonthList") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                allMonthsLists = try jsonDecoder.decode([MonthList].self, from: savedData)
            } catch {
                print("Failed to load")
            }
        } else {
            let tmp = Expenditure(name: "No name", amountOfMoneySpent: 100, isExpenditure: false, history: [], textColor: "green")
            let tmp1 = MonthList(list: [tmp])
            allMonthsLists.append(tmp1)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
            
        if let savedData = try? jsonEncoder.encode(goal) {
            let defaults = UserDefaults.standard
                
            defaults.setValue(savedData, forKey: "goal")
        }
    }

}
