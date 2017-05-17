//
//  Expense.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import RealmSwift

enum Importance: Int {
    case veryImportant
    case notImportant
    case uselessButDesired // for fun :)
}

class Expense: Object {
    
    dynamic var category: Category!
    dynamic var value: Double = 0.0
    dynamic var date: Date!
    dynamic var expenseDescription: String? = nil
    dynamic var importanceRaw = Importance.veryImportant.rawValue
    var importance: Importance {
        get {
            return Importance(rawValue: importanceRaw)!
        }
        set {
            importanceRaw = newValue.rawValue
        }
    }
}
