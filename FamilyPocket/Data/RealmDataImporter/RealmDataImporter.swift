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
    
    func initialDataImported() -> Bool {
        return UserDefaults.standard.bool(forKey: initialDataImportedKey)
    }
    
    func importCategories() {
        
        print("Checking categories...")
        
        let realm = try! Realm()
        let realmCategories = realm.objects(Category.self)
        
        print("There are \(realmCategories.count) categories found!")
        
        if realmCategories.count < 1 {
        
            let jsonFilePathOptional = Bundle.main.path(forResource: "categories", ofType: "json")
            guard let jsonFilePath = jsonFilePathOptional else { return }
            
            let jsonDataOptional = try? NSData(contentsOfFile: jsonFilePath, options: NSData.ReadingOptions.mappedIfSafe)
            guard let jsonData = jsonDataOptional else { return }
            
            let jsonResult: Dictionary = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
            
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
                syncData()
            } catch let error {
                print("Error writing: \(error.localizedDescription)")
            }
        } else {
            print("No import needed")
        }
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
