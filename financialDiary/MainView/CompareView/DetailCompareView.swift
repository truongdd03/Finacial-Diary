//
//  DetailCompareView.swift
//  financialDiary
//
//  Created by Dong Truong on 4/2/21.
//

import UIKit

private let reuseIdentifier = "Cell"

class DetailCompareView: UICollectionViewController {
    var thisMonthExpenditure = [Expenditure]()
    var previousMonthExpenditure = allMonthsLists.last!.list
    var dictionary = [String: Expenditure]()
    var namesOfExpenditures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if previousMonthExpenditure[0].name == "" {
            previousMonthExpenditure.removeAll()
        }
        
        buildNamesOfExpenditures()
    }

    func buildNamesOfExpenditures() {
        for item in list {
            thisMonthExpenditure.append(Expenditure(name: item.name, amountOfMoneySpent: item.amountOfMoneySpent, isExpenditure: item.isExpenditure, history: item.history))
            dictionary[item.name] = item
            namesOfExpenditures.append(item.name)
        }
        
        sortNamesOfExpenditures()
        
        previousMonthExpenditure = previousMonthExpenditure.sorted {
            $0.amountOfMoneySpent.amount < $1.amountOfMoneySpent.amount
        }
        
        for item in previousMonthExpenditure {
            if dictionary[item.name] == nil {
                dictionary[item.name] = item
                namesOfExpenditures.append(item.name)
            }
        }
    }
    
    func sortNamesOfExpenditures() {
        namesOfExpenditures = namesOfExpenditures.sorted {
            dictionary[$0]!.amountOfMoneySpent.amount > dictionary[$1]!.amountOfMoneySpent.amount
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return namesOfExpenditures.count
    }
    
    func findExpenditureInList(expenditure: Expenditure, list: [Expenditure]) -> Expenditure {
        for item in list {
            if item.name == expenditure.name {
                return item
            }
        }
        return Expenditure(name: "", amountOfMoneySpent: Money(amount: 0), isExpenditure: false, history: [])
    }
    
    func calculatePercent(thisMonth: Double, lastMonth: Double) -> (String, UIColor) {
        var color: UIColor
        var percent: Double
        
        if lastMonth == 0 {
            percent = abs(thisMonth *  100.0)
        } else {
            percent = abs((thisMonth - lastMonth) / lastMonth) * 100.0
        }
        percent = round(percent * 100) / 100
        
        var string = String(percent)

        if thisMonth >= lastMonth {
            color = .systemGreen
            string = "+\(string)%"
        } else {
            color = .red
            string = "-\(string)%"
        }
        
        return ("(\(string)) ", color)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpenditureCell", for: indexPath) as! ExpenditureCell
        
        var color:UIColor = .systemGreen
        let expenditure = dictionary[namesOfExpenditures[indexPath.item]]!
        if expenditure.isExpenditure {
            color = .red
        }
        
        let thisMonth = findExpenditureInList(expenditure: expenditure, list: thisMonthExpenditure)
        let lastMonth = findExpenditureInList(expenditure: expenditure, list: allMonthsLists.last!.list)
        
        thisMonth.amountOfMoneySpent.show(label: cell.thisMonthTotalMoneyLabel, color: color)
        lastMonth.amountOfMoneySpent.show(label: cell.lastMonthTotalMoneyLabel, color: color)
        
        let percent = calculatePercent(thisMonth: thisMonth.amountOfMoneySpent.amount, lastMonth: lastMonth.amountOfMoneySpent.amount)
        cell.titleLabel.text = percent.0 + namesOfExpenditures[indexPath.item]
        cell.titleLabel.textColor = percent.1
        
        return cell
    }

}
