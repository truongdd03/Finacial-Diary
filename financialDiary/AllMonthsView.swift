//
//  AllMonthsView.swift
//  financialDiary
//
//  Created by Dong Truong on 4/1/21.
//

import UIKit

class AllMonthsView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "History"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMonthsLists.count
    }

    func reformatNumber(number: Int) -> String {
        let formater = NumberFormatter()
        
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: number))!
        
        return formattedNumber
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCell", for: indexPath)
        cell.textLabel?.text = allMonthsLists[indexPath.row].month
        if cell.textLabel?.text == "" {
            cell.detailTextLabel?.text = ""
        } else {
            let totalMoney = allMonthsLists[indexPath.row].totalMoney
            let text = reformatNumber(number: totalMoney)
            
            if totalMoney >= 0 {
                cell.detailTextLabel?.textColor = .systemGreen
                cell.detailTextLabel?.text = "+\(text)$"
            } else {
                cell.detailTextLabel?.textColor = .systemRed
                cell.detailTextLabel?.text = "-\(text)$"
            }
        }
        return cell
    }
    
}
