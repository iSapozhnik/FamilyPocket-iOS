//
//  CategoryPersistance.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation

protocol Persistable {
    associatedtype Object
    
    func allObjects(withCompletion completion: ([Object]?) -> ())
    func add(object: Object)
    func delete(object: Object)
    
}
