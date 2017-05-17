//
//  CategoryPersistance.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import RealmSwift

protocol Persistable {
    associatedtype ObjectClass
    
    func allObjects(withCompletion completion: @escaping  ([ObjectClass]?) -> ())
    func add(object: Object)
    func delete(object: Object)
    
}
