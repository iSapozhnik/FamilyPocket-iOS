//
//  NewCategoryViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class NewCategoryViewController: BaseViewController, UIScrollViewDelegate {
    
    typealias CategoryHandler = (_ sender: UIViewController, _ category: Category?) -> ()

    @IBOutlet weak var bottomContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var titleLabel: ALabel!
    @IBOutlet weak var categoryNameTextfield: PaddingTextfield!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var saveButton: UIButton!
    
    var categoryColorName: String?
    var categoryColor: UIColor?
    
    var completion: CategoryHandler?
    var kbUtility: KeyboardUtility!
    
    init(withCompletion completion: CategoryHandler?) {
        super.init(nibName: "NewCategoryViewController", bundle: nil)
        self.completion = completion
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        colorButton.layer.cornerRadius = 3.0
        colorButton.layer.borderColor = UIColor.white.cgColor
        colorButton.layer.borderWidth = 1.0
        
        scrollView.contentOffset = CGPoint(x: 0, y: 20)
        
        categoryNameTextfield.paddingLeft = 16.0
        
        kbUtility = KeyboardUtility { (height: CGFloat, duration :TimeInterval) in
            
            UIView.animate(withDuration: duration, animations: {
                self.bottomContainerConstraint.constant = height
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func animate() {
        titleLabel.animate()
    }
    
    @IBAction func pickeColor(_ sender: Any) {
        
        let palette = ColorPaletteTableViewController { (color) in
            
            self.animateOnAppearence = false
            print("selected \(color.hexString())")
            
            self.categoryColorName = color.hexString()
            self.categoryColor = color
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layer.backgroundColor = color.cgColor
                    self.colorButton.layer.backgroundColor = color.cgColor
                })
            }
        }
        navigationController?.pushViewController(palette, animated: true)
    }
    
    @IBAction func saveCategory(_ sender: Any) {
    
        categoryNameTextfield.resignFirstResponder()
        
        guard
            let categoryColorName = self.categoryColorName,
            let categoryName = self.categoryNameTextfield.text else { return }
        
        let newCategory = Category()
        newCategory.color = categoryColorName
        newCategory.name = categoryName
        newCategory.dateOfCreation = Date()
        newCategory.iconName = "Edit User Male-80.png" //default icon
        
        let categoryManager = CategoryManager()
        if categoryManager.canAdd(object: newCategory) {
            CategoryManager().add(object: newCategory)
            completion?(self, newCategory)
        } else {
            print("Object already exists")
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        completion?(self, nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -50 {
            completion?(self, nil)
        }
    }
}
