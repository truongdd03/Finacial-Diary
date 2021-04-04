//
//  MainView.swift
//  financialDiary
//
//  Created by Dong Truong on 3/31/21.
//

import UIKit

var radius:CGFloat = 130
var progressColor:CGColor = UIColor.systemGreen.cgColor
var isPreviousMonthSaved = false
var allMonthsLists = [MonthList]()

class MainView: UIViewController {
    var titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
    var circularProgressBarView: ProgressView!
    var previousPercent = 0
    
    var goal = Money(amount: 1) {
        didSet {
            saveGoal()
            goal.show(label: goalLabel, color: .systemYellow)
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
    
    var totalMoney = Money(amount: 0)

    @IBOutlet weak var totalMoneyLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        load()
        
        title = "Financial Diary"
        showTotalMoney()
        checkToSaveAllMonthsLists()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set goal", style: .plain, target: self, action: #selector(addGoal))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Older", style: .plain, target: self, action: #selector(showPreviousMonths))
    }

    @objc func showPreviousMonths() {
        if let vc = storyboard?.instantiateViewController(identifier: "AllMonthsView") as? UITableViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func addGoal() {
        let ac = UIAlertController(title: "Type your goal", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            
            if text.count > 10 {
                self?.showError(title: "Too big number", message: nil)
                return
            }
            
            if let number = Int(text) {
                self?.goal.amount = number
            } else {
                self?.showError(title: "Invalid number", message: nil)
            }
            
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func showError(title: String, message: String?) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
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
    
    func showTotalMoney() {
        totalMoney.calculate(from: list)
        totalMoney.show(label: totalMoneyLabel, color: nil)
        
        if totalMoney.amount <= 0 {
            percent = 0
            return
        }
        
        if goal.amount == 0 {
            percent = 100
            return
        }
        
        let tmp:CGFloat = CGFloat(totalMoney.amount) / CGFloat(goal.amount)
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
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "list") as? Data {
            let jsonDecoder = JSONDecoder()
            list = try! jsonDecoder.decode([Expenditure].self, from: savedData)
        }
        
        if let savedData = defaults.object(forKey: "goal") as? Data {
            let jsonDecoder = JSONDecoder()
            goal = try! jsonDecoder.decode(Money.self, from: savedData)
        } else {
            goal.amount = 0
        }
        
        if let savedData = defaults.object(forKey: "allMonthsLists") as? Data {
            let jsonDecoder = JSONDecoder()
            allMonthsLists = try! jsonDecoder.decode([MonthList].self, from: savedData)
        } else {
            let tmp = Expenditure(name: "", amountOfMoneySpent: Money(amount: 0), isExpenditure: false, history: [])
            let tmp1 = MonthList(list: [tmp], month: "", totalMoney: Money(amount: 0))
            allMonthsLists.append(tmp1)
        }
        
        if let savedData = defaults.object(forKey: "isPreviousMonthSaved") as? Data {
            let jsonDecoder = JSONDecoder()
            isPreviousMonthSaved = try! jsonDecoder.decode(Bool.self, from: savedData)
        } else {
            isPreviousMonthSaved = false
        }
    }
    
    func saveGoal() {
        let jsonEncoder = JSONEncoder()
        let savedData = try! jsonEncoder.encode(goal)
        let defaults = UserDefaults.standard
                
        defaults.setValue(savedData, forKey: "goal")
    }
    
    func saveList() {
        let jsonEncoder = JSONEncoder()
        let savedData = try! jsonEncoder.encode(list)
        let defaults = UserDefaults.standard
            
        defaults.setValue(savedData, forKey: "list")
    }
    
    func saveAllMonthsLists(month: String) {
        var tmp = [Expenditure]()
        for item in list {
            tmp.append(Expenditure(name: item.name, amountOfMoneySpent: item.amountOfMoneySpent, isExpenditure: item.isExpenditure, history: []))
        }
        
        allMonthsLists.append(MonthList(list: tmp, month: month, totalMoney: totalMoney))
        isPreviousMonthSaved = true
        
        let jsonEncoder = JSONEncoder()
        var savedData = try! jsonEncoder.encode(allMonthsLists)
        let defaults = UserDefaults.standard
                
        defaults.setValue(savedData, forKey: "allMonthsLists")
        
        savedData = try! jsonEncoder.encode(isPreviousMonthSaved)
        defaults.setValue(savedData, forKey: "isPreviousMonthSaved")
    }
    
    func resetList() {
        for id in 0..<list.count {
            list[id].amountOfMoneySpent.amount = 0
            list[id].history = [String]()
        }
        saveList()
    }
    
    // save previous month
    func checkToSaveAllMonthsLists() {
        let today = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd"
        let date = formatter.string(from: today)
        
        formatter.dateFormat = "MM/yyyy"
        let month = formatter.string(from: today)
        
        if date == "01" && !isPreviousMonthSaved {
        
            if allMonthsLists[0].month == "" {
                allMonthsLists.removeFirst()
            }
                        
            showError(title: "Your data was saved", message: "Your data for last month was automatically saved. All of your expenditure/income names remain unchanged, while their histories were reset. Now you can only add expenditure/income for the current month")
            saveAllMonthsLists(month: month)
            
            resetList()
            
        }
    }

}
