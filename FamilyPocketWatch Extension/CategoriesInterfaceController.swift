//
//  CategoriesInterfaceController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/24/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import WatchKit
import Foundation
import RealmSwift

class CategoriesInterfaceController: WKInterfaceController, DataSourceChangedDelegate {

    @IBOutlet var tableView: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(delegate: self)
        if let category = UserDefaults.standard.value(forKey: Constants.SharedKeys.category.key()) as? Dictionary<String, Any> {
            self.tableView.setNumberOfRows(8, withRowType: "Categories")
        } else {
            self.tableView.setNumberOfRows(0, withRowType: "Categories")
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        
        WatchSessionManager.sharedManager.removeDataSourceChangedDelegate(delegate: self)
        
        super.didDeactivate()
    }
    
    // MARK: DataSourceUpdatedDelegate
    // update the food label once the data is changed!
    func dataSourceDidUpdate(dataSource: Dictionary<String, Any>) {
        if let category = dataSource["category"] {
            UserDefaults.standard.set(category, forKey: Constants.SharedKeys.category.key())
            UserDefaults.standard.synchronize()
        }
        self.tableView.setNumberOfRows(8, withRowType: "Categories")

    }

}
