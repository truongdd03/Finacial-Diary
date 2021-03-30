//
//  DetailViewController.swift
//  financialDiary
//
//  Created by Dong Truong on 3/4/21.
//

import UIKit

class DetailViewController: UITableViewController {
    var chosenItemId = 0
    var titleColor = [NSAttributedString.Key.foregroundColor:UIColor.red]
    
    @IBOutlet weak var moneyLabel: UILabel!

    func labelUpdate() {
        let formattedNumber = reformat(list[chosenItemId].amountOfMoneySpent)
        moneyLabel.text = "\(formattedNumber)VND"
        
        moneyLabel.textColor = .systemGreen
        if list[chosenItemId].textColor == "red" {
            moneyLabel.textColor = .red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //title
        title = list[chosenItemId].name
        if !list[chosenItemId].isExpenditure {
            titleColor = [NSAttributedString.Key.foregroundColor:UIColor.systemGreen]
        }
        navigationController?.navigationBar.titleTextAttributes = titleColor
        
        //showing the total of money
        tableView.reloadData()
        labelUpdate()
        
        //addButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
    }

    // add-button's support
    @objc func addEvent() {
        var tmp = "earned"
        if list[chosenItemId].isExpenditure { tmp = "spent" }
        let ac = UIAlertController(title: "Enter the amount of money you \(tmp)", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            
            self?.submit(text)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    func submit(_ text: String) {
        if var tmp = Int(text) {
            if list[chosenItemId].isExpenditure {
                tmp *= -1
            }

            totalMoney += tmp
            list[chosenItemId].amountOfMoneySpent += tmp
            labelUpdate()
            
            let today = Date()
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "HH:mm E, d MMM y"
            
            list[chosenItemId].history.insert("\(formatter1.string(from: today)): \(reformat(tmp))", at: 0)
            save()
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            return
        }
        let ac = UIAlertController(title: "Invalid number", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    // add . in number
    func reformat(_ number: Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: number))!
    }
    
    
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[chosenItemId].history.count
    }

    
    // cell's name
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)
        cell.textLabel?.text = list[chosenItemId].history[indexPath.row]
        return cell
    }
    
    
    // Delete row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
        
            let moneyInThisEvent = amountOfMoneyInEvent(event: list[chosenItemId].history[indexPath.row])
            list[chosenItemId].amountOfMoneySpent -= moneyInThisEvent
            totalMoney -= moneyInThisEvent
            labelUpdate()
                        
            list[chosenItemId].history.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            save()
        }
    }
    
    // return the amount of money in the history string
    func amountOfMoneyInEvent(event: String) -> Int {
        var tmp = event
        let index = tmp.lastIndex(of: ":")!
        tmp.removeSubrange(tmp.startIndex...index)
        tmp.remove(at: tmp.startIndex)
        return Int(tmp)!
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(list) {
            let defaults = UserDefaults.standard
            
            defaults.setValue(savedData, forKey: "list")
        }
        
        if let savedData = try? jsonEncoder.encode(totalMoney) {
            let defaults = UserDefaults.standard
            
            defaults.setValue(savedData, forKey: "totalMoney")
        }
    }

}
