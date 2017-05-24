//
//  RealmDataImporter.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit
import RealmSwift

let initialDataImportedKey: String = "familypocket.initialDataImportedKey"

class RealmDataImporter {
    
    static func setDefaultRealmConfig() {
        let directory: URL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Ivan.Sapozhnik.FamilyPocket")!
        let realmPath = directory.path.appending("db.realm")
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.fileURL = URL(string: realmPath)
        Realm.Configuration.defaultConfiguration = configuration
    }
    
    static func databaseURL() {
        if let url = Realm.Configuration.defaultConfiguration.fileURL {
            print("Realm database: \(url.absoluteString)")
        }
    }
    
    func initialDataImported() -> Bool {
        return UserDefaults.standard.bool(forKey: initialDataImportedKey)
    }
    
    func importCategories() {
        
        importExpenseCategories()
        importIncomeCategories()
        syncData()
    }
    
    // TODO: Should be changed with generics!!
    
    private func importExpenseCategories() {
        print("Checking expense categories...")
        
        let realm = try! Realm()
        let realmCategories = realm.objects(Category.self)
        
        print("There are \(realmCategories.count) categories found!")
        
        if realmCategories.count < 1 {
            
            guard let jsonResult = dictionaryFromJSON(withName: "categories") else { return }
            
            guard let categories: Array<Dictionary<String,Any>> = jsonResult["categories"] as? Array<Dictionary<String,Any>> else { return }
            
            realm.beginWrite()
            
            for category in categories {
                
                let rmCategory = Category()
                rmCategory.name = category["name"] as! String
                rmCategory.color = category["color"] as? String
                rmCategory.popularity = category["popularity"] as! Int
                rmCategory.iconName = category["iconName"] as? String
                
                realm.add(rmCategory)
            }
            
            do {
                try realm.commitWrite()
                let realmCategories = realm.objects(Category.self)
                print("\(realmCategories.count) categories were written")
            } catch let error {
                print("Error writing: \(error.localizedDescription)")
            }
        } else {
            print("No import needed")
        }
    }
    
    private func importIncomeCategories() {
        
        print("Checking expense categories...")
        
        let realm = try! Realm()
        let realmCategories = realm.objects(IncomeCategory.self)
        
        print("There are \(realmCategories.count) categories found!")
        
        if realmCategories.count < 1 {
            
            guard let jsonResult = dictionaryFromJSON(withName: "incomeCategories") else { return }
            
            guard let categories: Array<Dictionary<String,Any>> = jsonResult["categories"] as? Array<Dictionary<String,Any>> else { return }
            
            realm.beginWrite()
            
            for category in categories {
                
                let rmCategory = IncomeCategory()
                rmCategory.name = category["name"] as! String
                rmCategory.color = category["color"] as? String
                rmCategory.popularity = category["popularity"] as! Int
                rmCategory.iconName = category["iconName"] as? String
                
                realm.add(rmCategory)
            }
            
            do {
                try realm.commitWrite()
                let realmCategories = realm.objects(IncomeCategory.self)
                print("\(realmCategories.count) categories were written")
            } catch let error {
                print("Error writing: \(error.localizedDescription)")
            }
        } else {
            print("No import needed")
        }
    }
    
    private func dictionaryFromJSON(withName name: String) -> Dictionary<String,Any>? {
        
        let jsonFilePathOptional = Bundle.main.path(forResource: name, ofType: "json")
        guard let jsonFilePath = jsonFilePathOptional else { return nil }
        
        let jsonDataOptional = try? NSData(contentsOfFile: jsonFilePath, options: NSData.ReadingOptions.mappedIfSafe)
        guard let jsonData = jsonDataOptional else { return nil }
        
        let jsonResult: Dictionary = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
        
        return jsonResult
    }
    
    func removeData() {
        
        if let url = Realm.Configuration.defaultConfiguration.fileURL {
            do {
                try FileManager.default.removeItem(at: url)
                UserDefaults.standard.set(false, forKey: initialDataImportedKey)
                UserDefaults.standard.synchronize()
                print("Old database removed!")
            } catch let error {
                print("Error deleting Realm database: \(error.localizedDescription)")
            }
        }
    }
    
    fileprivate func syncData() {
        UserDefaults.standard.set(true, forKey: initialDataImportedKey)
        UserDefaults.standard.synchronize()
    }
}
