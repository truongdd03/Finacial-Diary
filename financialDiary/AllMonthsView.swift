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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthCell", for: indexPath)
        cell.textLabel?.text = allMonthsLists[indexPath.row].month
        if cell.textLabel?.text == "" {
            cell.detailTextLabel?.text = ""
        } else {
            allMonthsLists[indexPath.row].totalMoney.show(label: cell.detailTextLabel!, color: nil)
        }
        return cell
    }
    
}
