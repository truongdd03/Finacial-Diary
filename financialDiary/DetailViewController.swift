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
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    func submit(_ text: String) {
        guard var tmp = Int(text) else {
            showError(title: "Invalid number")
            return
        }
        
        if text.count > 10 {
            showError(title: "Too big number")
            return
        }
    
        if list[chosenItemId].isExpenditure {
            tmp *= -1
        }

        list[chosenItemId].amountOfMoneySpent += tmp
        labelUpdate()
            
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "HH:mm E, d MMM y"
            
        list[chosenItemId].history.insert("\(formatter1.string(from: today)): \(reformat(tmp))", at: 0)
        save()
        print(reformat(tmp))
            
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        return
    }
    
    func showError(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    // add . in number
    func reformat(_ number: Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
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
            labelUpdate()
                        
            list[chosenItemId].history.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            
            save()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isToolbarHidden = true
    }
    
    // return the amount of money in the history string
    func amountOfMoneyInEvent(event: String) -> Int {
        var tmp = event
        let index = tmp.lastIndex(of: ":")!
        tmp.removeSubrange(tmp.startIndex...index)
        tmp.remove(at: tmp.startIndex)
        print(tmp)
        while let id = tmp.firstIndex(of: ",") {
            tmp.remove(at: id)
        }
        return Int(tmp)!
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(list) {
            let defaults = UserDefaults.standard
            
            defaults.setValue(savedData, forKey: "list")
        }
    }
    
    

}

