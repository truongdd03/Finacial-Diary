//
//  ViewController.swift
//  financialDiary
//
//  Created by Dong Truong on 3/4/21.
//
import UIKit

var totalMoney = 0
var list = [Expenditure]()

class ViewController: UITableViewController {
    var titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
    var filteredData = [Expenditure]()
    @IBOutlet weak var totalMoneyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Financial diary"
        
        load()
        filteredData = list
        
        // Add-Button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(addFilter))
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
        } else {
            filteredData.removeAll()
            var goal = false
            title = action.title
            if action.title == "Expenditure" { goal = true }
        
            for item in list {
                if goal == item.isExpenditure {
                    filteredData.append(item)
                }
            }
        }
        tableView.reloadData()
    }
    
    // support for add-button
    @objc func addCell() {
        let tmp = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        tmp.addAction(UIAlertAction(title: "Add expenditure", style: .default, handler: addExpenditure))
        tmp.addAction(UIAlertAction(title: "Add income", style: .default, handler: addIncome))
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
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
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
        let tmp = list[id]
        totalMoney -= tmp.amountOfMoneySpent
        
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
    }
    
    func labelUpdate() {
        titleColor = [NSAttributedString.Key.foregroundColor:UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = titleColor
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: totalMoney))!
        totalMoneyLabel.text = "\(formattedNumber)VND"
        
        totalMoneyLabel.textColor = .red
        if totalMoney > 0 {
            totalMoneyLabel.textColor = .systemGreen
            totalMoneyLabel.text = "+\(formattedNumber)VND"
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
        cell.detailTextLabel?.text = String(reformat(tmp.amountOfMoneySpent))
        cell.textLabel?.textColor = takeColorOf(tmp.textColor)
        cell.detailTextLabel?.textColor = takeColorOf(tmp.textColor)
        
        return cell
    }
    
    // add . in number
    func reformat(_ number: Int) -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: number))!
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
        
        if let savedData = defaults.object(forKey: "totalMoney") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                totalMoney = try jsonDecoder.decode(Int.self, from: savedData)
            } catch {
                print("Failed to load")
            }
        }
    }
}
