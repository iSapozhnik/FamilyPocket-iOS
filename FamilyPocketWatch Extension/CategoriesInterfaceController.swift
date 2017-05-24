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

class CategoriesInterfaceController: WKInterfaceController {

    @IBOutlet var tableView: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        
//        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Ivan.Sapozhnik.FamilyPocket")!
//        let realmPath = directory.path.appending("db.realm")
//        var configuration = Realm.Configuration.defaultConfiguration
//        configuration.fileURL = URL(string: realmPath)
//        Realm.Configuration.defaultConfiguration = configuration
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
