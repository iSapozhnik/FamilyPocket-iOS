//
//  EditCategoryViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class EditCategoryViewController: NewCategoryViewController {
    
    var category: Category?
    
    init(withCategory category: Category?, completion: CategoryHandler?) {
        super.init(withCompletion: nil)
        
        self.completion = completion
        self.category = category
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let category = self.category else { return }
        titleLabel.text = NSLocalizedString("Edit category:", comment: "")
        self.view.layer.backgroundColor = category.color?.hexColor.cgColor
        self.colorButton.layer.backgroundColor = category.color?.hexColor.cgColor
        self.categoryNameTextfield.text = category.name
        self.saveButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
    }

    override func saveCategory(_ sender: Any) {
        
        guard
            let category = self.category,
            let name = categoryNameTextfield.text else { return }
        
        categoryNameTextfield.resignFirstResponder()
        
        guard let newName = name.characters.count > 0 ? name : category.name else {
            completion?(self, nil)
            return
        }
        
        CategoryManager().update(object: category, name: newName)
        completion?(self, category)
    }
    
}
