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
        
        let customCell = UINib(nibName: "MonthViewCell", bundle: nil)
        tableView.register(customCell, forCellReuseIdentifier: "MonthViewCell")
        
        view.backgroundColor = .black
        title = "History"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMonthsLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonthViewCell", for: indexPath) as! MonthViewCell
        cell.monthInformation = allMonthsLists[indexPath.row]
        return cell
    }
    
}
