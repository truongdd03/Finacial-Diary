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
                self?.goal = number
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
        
        if let savedData = defaults.object(forKey: "allMonthsLists") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                allMonthsLists = try jsonDecoder.decode([MonthList].self, from: savedData)
            } catch {
                print("Failed to load")
            }
        } else {
            let tmp = Expenditure(name: "No name", amountOfMoneySpent: 0, isExpenditure: false, history: [], textColor: "green")
            let tmp1 = MonthList(list: [tmp], month: "")
            allMonthsLists.append(tmp1)
        }
        
        if let savedData = defaults.object(forKey: "isPreviousMonthSaved") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                isPreviousMonthSaved = try jsonDecoder.decode(Bool.self, from: savedData)
            } catch {
                print("Failed to load")
            }
        } else {
            isPreviousMonthSaved = false
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
            
        if let savedData = try? jsonEncoder.encode(goal) {
            let defaults = UserDefaults.standard
                
            defaults.setValue(savedData, forKey: "goal")
        }
    }
    
    func saveList() {
        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(list) {
            let defaults = UserDefaults.standard
            
            defaults.setValue(savedData, forKey: "list")
        }
    }
    
    func saveAllMonthsLists(month: String) {
        var tmp = [Expenditure]()
        for item in list {
            tmp.append(Expenditure(name: item.name, amountOfMoneySpent: item.amountOfMoneySpent, isExpenditure: item.isExpenditure, history: [], textColor: item.textColor))
        }
        
        allMonthsLists.append(MonthList(list: tmp, month: month))
        isPreviousMonthSaved = true
        let jsonEncoder = JSONEncoder()
            
        if let savedData = try? jsonEncoder.encode(allMonthsLists) {
            let defaults = UserDefaults.standard
                
            defaults.setValue(savedData, forKey: "allMonthsLists")
        }
        
        if let savedData = try? jsonEncoder.encode(isPreviousMonthSaved) {
            let defaults = UserDefaults.standard
                
            defaults.setValue(savedData, forKey: "isPreviousMonthSaved")
        }
    }
    
    func resetList() {
        for id in 0..<list.count {
            list[id].amountOfMoneySpent = 0
            list[id].history = [String]()
        }
        saveList()
    }
    
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
                        
            showError(title: "Your data was saved", message: "Your data of last month was automatically saved. All of your expenditure/income names remain unchanged, while their histories was reset. Now you can only add expenditure/income for the current month")
            saveAllMonthsLists(month: month)
            
            resetList()
            
        }
    }

}
