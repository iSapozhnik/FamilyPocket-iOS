//
//  Category.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    
    dynamic var name: String!
    dynamic var dateOfCreation: Date!
    dynamic var popularity: Int = 0
    dynamic var color: String?
    dynamic var iconName: String?
}
