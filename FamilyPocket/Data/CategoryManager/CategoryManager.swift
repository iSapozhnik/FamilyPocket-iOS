//
//  CategoryManager.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryManager: Persistable {
    typealias Object = Category
    
    func allObjects(withCompletion completion: ([Category]?) -> ()) {
        
        let realm = try! Realm()
        
        let dataImporter = RealmDataImporter()
        
        if !dataImporter.initialDataImported() {
            dataImporter.importCategories()
        }
        
        let categories = realm.objects(Category.self).sorted(byKeyPath: "popularity", ascending: false)
        completion(Array(categories))
    }
    
    func add(object: Category) {
        
    }
    
    func delete(object: Category) {
        
    }
}
