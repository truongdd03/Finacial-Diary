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
    var thisMonthTotalMoney = 0
    var lastMonthTotalMoney = allMonthsLists.last!.totalMoney
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildNamesOfExpenditures()
        
        //print(namesOfExpenditures[0])
    }

    func buildNamesOfExpenditures() {
        for item in list {
            thisMonthExpenditure.append(Expenditure(name: item.name, amountOfMoneySpent: item.amountOfMoneySpent, isExpenditure: item.isExpenditure, history: item.history, textColor: item.textColor))
            dictionary[item.name] = item
            namesOfExpenditures.append(item.name)
            thisMonthTotalMoney += item.amountOfMoneySpent
        }
        
        sortNamesOfExpenditures()
        
        previousMonthExpenditure = previousMonthExpenditure.sorted {
            $0.amountOfMoneySpent < $1.amountOfMoneySpent
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
            dictionary[$0]!.amountOfMoneySpent < dictionary[$1]!.amountOfMoneySpent
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return namesOfExpenditures.count
    }
    
    func findExpenditureInList(expenditure: Expenditure, list: [Expenditure]) -> Expenditure? {
        for item in list {
            if item.name == expenditure.name {
                return item
            }
        }
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExpenditureCell", for: indexPath) as! ExpenditureCell
        
        var color:UIColor = .systemGreen
        let expenditure = dictionary[namesOfExpenditures[indexPath.item]]!
        if expenditure.isExpenditure {
            color = .red
        }
        
        cell.titleLabel.text = "\(namesOfExpenditures[indexPath.item])"
        cell.titleLabel.textColor = color
        
        let thisMonth = findExpenditureInList(expenditure: expenditure, list: thisMonthExpenditure)
        let lastMonth = findExpenditureInList(expenditure: expenditure, list: allMonthsLists.last!.list)
        
        showLabel(labelName: cell.thisMonthTotalMoneyLabel, amountOfMoney: thisMonth?.amountOfMoneySpent ?? 0, color: color)
        showLabel(labelName: cell.lastMonthTotalMoneyLabel, amountOfMoney: lastMonth?.amountOfMoneySpent ?? 0, color: color)
        
        
        return cell
    }
    
    func showLabel(labelName: UILabel, amountOfMoney: Int, color: UIColor) {
        var formattedNumber = reformatNumber(number: amountOfMoney)
        
        if color == UIColor.red && amountOfMoney == 0 {
            formattedNumber = "-\(formattedNumber)"
        } else if amountOfMoney >= 0 {
            formattedNumber = "+\(formattedNumber)"
        }
        
        labelName.text = "\(formattedNumber)VND"
        labelName.textColor = color
        
    }
    
    func reformatNumber(number: Int) -> String {
        let formater = NumberFormatter()
        
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: NSNumber(value: number))!
        
        return formattedNumber
    }

}
