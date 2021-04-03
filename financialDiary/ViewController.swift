//
//  ViewController.swift
//  financialDiary
//
//  Created by Dong Truong on 3/4/21.
//
import UIKit

var list = [Expenditure]()

class ViewController: UITableViewController {
    var totalMoney = 0
    var titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
    var filteredData = [Expenditure]()
    @IBOutlet weak var totalMoneyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Financial Diary"
        
        filteredData = list
        
        // Add-Button
        let filterButton = UIBarButtonItem(image: UIImage(named: "icons8-filter-30"), style: .plain, target: self, action: #selector(addFilter))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolbarItems = [spacer, filterButton]
        navigationController?.isToolbarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCell))
        
    }
    
    @objc func addFilter() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "None", style: .default, handler: buildFilter))
        ac.addAction(UIAlertAction(title: "Expenditure", style: .default, handler: buildFilter))
        ac.addAction(UIAlertAction(title: "Income", style: .default, handler: buildFilter))

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func buildFilter(_ action: UIAlertAction) {
        if action.title == "None" {
            filteredData = list
            title = "Financial Diary"
            titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
        } else {
            filteredData.removeAll()
            var goal = false
            title = action.title
            titleColor = [NSAttributedString.Key.foregroundColor:UIColor.systemGreen]
            if action.title == "Expenditure" {
                goal = true
                titleColor = [NSAttributedString.Key.foregroundColor:UIColor.red]
            }
        
            for item in list {
                if goal == item.isExpenditure {
                    filteredData.append(item)
                }
            }
        }
        tableView.reloadData()
        labelUpdate()
    }
    
    func calculateTotalMoney() {
        totalMoney = 0
        for item in filteredData {
            totalMoney += item.amountOfMoneySpent
        }
    }
    
    // support for add-button
    @objc func addCell() {
        let tmp = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if title != "Income" {
            tmp.addAction(UIAlertAction(title: "Add expenditure", style: .default, handler: addExpenditure))
        }
        if title != "Expenditure" {
            tmp.addAction(UIAlertAction(title: "Add income", style: .default, handler: addIncome))
        }
        tmp.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(tmp, animated: true)
    }
    
    func addExpenditure(action: UIAlertAction) {
        showAlert(title: "Enter expenditure's name", isExpenditure: true)
    }
    
    func addIncome(action: UIAlertAction) {
        showAlert(title: "Enter income's name", isExpenditure: false)
    }
    
    func showAlert(title: String, isExpenditure: Bool) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            
            let tmp = Expenditure(name: text, amountOfMoneySpent: 0, isExpenditure: isExpenditure, history: [], textColor: "green")
            
            if isExpenditure {
                tmp.textColor = "red"
            }
            
            self?.submitAnswer(tmp)
        }
        
        save()
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func submitAnswer(_ tmp: Expenditure) {
        for item in list {
            if item.name == tmp.name {
                showError(title: "Existed")
                return
            }
        }
        
        if tmp.name == "" {
            showError(title: "Invalid")
            return
        }
        
        if tmp.name.count > 40 {
            showError(title: "Too long")
            return
        }
        
        filteredData.insert(tmp, at: 0)
        list.insert(tmp, at: 0)
        save()
        
        //let action = UIAlertAction(title: "None", style: .default, handler: nil)
        //buildFilter(action)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func showError(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
    }
    
    func findPositionInList(at position: Int) -> Int {
        let tmp = filteredData[position].name
        
        for (id, item) in list.enumerated() {
            if item.name == tmp {
                return id
            }
        }
        print("Do not exist")
        return -1
    }
    
    // remove-button
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != UITableViewCell.EditingStyle.delete { return }
        
        let id = findPositionInList(at: indexPath.row)
        
        filteredData.remove(at: indexPath.row)
        list.remove(at: id)
        save()
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        labelUpdate()
    }
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    // link to DetailViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.chosenItemId = findPositionInList(at: indexPath.row)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // show total amount of money
    override func viewWillAppear(_ animated: Bool) {
        labelUpdate()
        navigationController?.isToolbarHidden = false
    }
    
    func labelUpdate() {
        navigationController?.navigationBar.titleTextAttributes = titleColor
        
        calculateTotalMoney()
        let formattedNumber = reformat(totalMoney)
        totalMoneyLabel.text = "\(formattedNumber)$"
        
        totalMoneyLabel.textColor = .red
        if totalMoney >= 0 {
            totalMoneyLabel.textColor = .systemGreen
            totalMoneyLabel.text = "+\(formattedNumber)$"
        }
    }
    
    //
    override func viewDidAppear(_ animated: Bool) {
        guard let selectedRow: IndexPath = tableView.indexPathForSelectedRow else { return }
        tableView.deselectRow(at: selectedRow, animated: true)
        tableView.reloadData()
    }

    func takeColorOf(_ color: String) -> UIColor {
        if color == "red" {
            return .red
        }
        return .systemGreen
    }
    
    // show cell's name
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tmp = filteredData[indexPath.row]
        
        cell.textLabel?.text = tmp.name
        cell.detailTextLabel?.text = String(reformat(tmp.amountOfMoneySpent)) + "$"
        cell.textLabel?.textColor = takeColorOf(tmp.textColor)
        cell.detailTextLabel?.textColor = takeColorOf(tmp.textColor)
        
        return cell
    }
    
    // add , in number
    func reformat(_ number: Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: number))!
    }

    func save() {
        let jsonEncoder = JSONEncoder()

        if let savedData = try? jsonEncoder.encode(list) {
            let defaults = UserDefaults.standard
            
            defaults.setValue(savedData, forKey: "list")
        }
    }

}
