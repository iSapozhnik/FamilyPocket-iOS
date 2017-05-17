//
//  Income.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import RealmSwift

class Income: Object {
    dynamic var category: IncomeCategory!
    dynamic var value: Double = 0.0
    dynamic var date: Date!
}
