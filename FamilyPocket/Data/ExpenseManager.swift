//
//  ExpenseIncomeManager.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import RealmSwift

class ExpenseManager: Persistable {
    
    typealias ObjectClass = Expense
    typealias ExpenseHandler = ([Expense]?) -> ()
    
    var notificationToken: NotificationToken? = nil
    var dataHandler: ExpenseHandler?
    
    deinit {
        notificationToken?.stop()
    }
    
    func addExpense(with value: Double, category: Category!, date: Date! = Date(), description: String? = nil, importance: Importance = Importance.veryImportant) {
        
        let expense = Expense()
        expense.value = value
        expense.category = category
        expense.date = date
        expense.expenseDescription = description
        expense.importanceRaw = importance.rawValue
        
        add(object: expense)
        
    }
    
    func addIncome(with value: Double, category: IncomeCategory!, date: Date! = Date()) {
        let income = Income()
        income.value = value
        income.category = category
        income.date = date
        
        add(object: income)
    }
    
    // MARK: Persistable
    
    func allObjects(withCompletion completion: @escaping ([Expense]?) -> ()) {
        
        let realm = try! Realm()
        
        let expenses = realm.objects(Expense.self).sorted(byKeyPath: "date", ascending: false)
        
        notificationToken = expenses.addNotificationBlock { (changes: RealmCollectionChange) in
            
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                completion(Array(expenses))

                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
            
    }
    
    func add(object: Object) {
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
        
    }
    
    func delete(object: Object) {
        
    }
}
