//
//  ExpenseSummaryViewController+DataSourse.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import UIKit

extension ExpenseSummaryViewController: UITableViewDataSource {
    
    static var datePresenter = DatePresenter(withFormat: "MMM dd yyyy")
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SummaryTableViewCell
        
        let expense = items[indexPath.row]
        
        let presenter = ExpenseSummaryViewController.datePresenter
        let color: UIColor
        let categoryIcon: UIImage?
        let categoryName: String
        if
            let category = expense.category,
            let colorString = category.color,
            let categoryIconName = category.iconName {
            categoryIcon = UIImage(named: categoryIconName)
            color = colorString.hexColor
            categoryName = category.name
        } else {
            color = .gray
            categoryIcon = nil
            categoryName = ""
        }
        cell.bind(withValue: Formatter.currency.string(for: expense.value) ?? "-/-", dateString: presenter.string(fromDate: expense.date), categoryImage: categoryIcon, categoryColor: color, categoryName: categoryName)
        
        return cell
    }
    
}
