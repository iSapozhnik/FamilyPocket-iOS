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

        let category = expense.category
        let categoryName = category?.name ?? "-/-"
        let colorString = category?.color
        let color = colorString?.hexColor ?? UIColor.mainGreenColor()
        let categoryIconName = category?.iconName ?? ""
        let categoryIcon = UIImage(named: categoryIconName)
        
        cell.bind(withValue: Formatter.currency.string(for: expense.value) ?? "-/-", dateString: presenter.string(fromDate: expense.date), categoryImage: categoryIcon, categoryColor: color, categoryName: categoryName)
        
        return cell
    }
    
}
