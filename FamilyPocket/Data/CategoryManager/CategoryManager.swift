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
    typealias ObjectClass = Category
    
    func allObjects(withCompletion completion: @escaping ([Category]?) -> ()) {
        
        let realm = try! Realm()
        
        let dataImporter = RealmDataImporter()
        
        if !dataImporter.initialDataImported() {
            dataImporter.importCategories()
        }
        
        let categories = realm.objects(Category.self).sorted(byKeyPath: "popularity", ascending: false)
        completion(Array(categories))
    }
    
    func canAdd(object: Object) -> Bool {
        
        if let category = object as? Category {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "name = %@", category.name!)
            let categories = realm.objects(Category.self).filter(predicate)
            return categories.count == 0
        } else {
            return true
        }
    }
    
    func add(object: Object) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(object)
        }
    }
    
    func delete(object: Object) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func update(object: Category, name: String, colorString: String) {
        let realm = try! Realm()
        try! realm.write {
            object.name = name
            object.color = colorString
            realm.add(object, update: true)
        }
    }
}

class IncomeCategoryManager: Persistable {
    
    typealias ObjectClass = IncomeCategory
    
    func allObjects(withCompletion completion: @escaping ([IncomeCategory]?) -> ()) {
        
        let realm = try! Realm()
        
        let dataImporter = RealmDataImporter()
        
        if !dataImporter.initialDataImported() {
            dataImporter.importCategories()
        }
        
        let categories = realm.objects(IncomeCategory.self).sorted(byKeyPath: "popularity", ascending: false)
        completion(Array(categories))
    }
    
    func add(object: Object) {
        
    }
    
    func delete(object: Object) {
        
    }
    
}
