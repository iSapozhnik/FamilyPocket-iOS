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

        categoryNameTextfield.paddingRight = 35.0
        
        guard let category = self.category else { return }
        self.deleteButton.isHidden = false
        self.deleteButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.3).cgColor
        self.deleteButton.layer.borderWidth = 1.0
        
        titleLabel.text = NSLocalizedString("Edit category:", comment: "")
        self.view.layer.backgroundColor = category.color?.hexColor.cgColor
        self.colorButton.layer.backgroundColor = category.color?.hexColor.cgColor
        self.categoryNameTextfield.text = category.name
        self.saveButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
        self.iconView.image = UIImage(named: category.iconName ?? "")
    }

    override func saveCategory(_ sender: Any) {
        
        guard
            let category = self.category,
            let name = categoryNameTextfield.text else { return }
        
        categoryNameTextfield.resignFirstResponder()
        
        guard let newName = name.characters.count > 0 ? name : category.name else {
            completion?(self, nil, false)
            return
        }

        CategoryManager().update(object: category, name: newName, colorString: self.categoryColorName ?? category.color!)
        completion?(self, category, false)
    }
    
    override func deleteCategory(_ sender: Any) {
        
        guard let category = self.category else { return }
        CategoryManager().delete(object: category)
        completion?(self, nil, false)
    }
}
