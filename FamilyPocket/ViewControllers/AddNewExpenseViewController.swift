//
//  AddNewExpenseViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

public protocol LayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}

class AddNewExpenseViewController: BaseViewController, CategoryDelegate {

    @IBOutlet weak var titleLabel: ALabel!
    @IBOutlet weak var saveButton: AButton!
    @IBOutlet weak var currencyTextfield: CurrencyTextfield!
    @IBOutlet weak var overlayButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var expenseSegmentedControl: UISegmentedControl!
    
    var dataSource: CategoryCollectionViewDataSource!
    var delegate: CategoryCollectionViewDelegate!
    
    var selectedCategory: Category?
    var categories: [Category]?
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionViewScrollDirection = .horizontal
    let cellIdentifier = "CategoryCollectionViewCell"
    
    var kbUtility: KeyboardUtility!
    
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init() {
        super.init(nibName: AddNewExpenseViewController.className, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func endEditing(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("AddNewExpenseViewController viewDidLoad")

        dataSource = CategoryCollectionViewDataSource(withCellIdentifier: cellIdentifier, items: nil, collectionView: collectionView)
        delegate = CategoryCollectionViewDelegate(withController: self)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        collectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        updateCategories(forSegmen: 0)
        
        kbUtility = KeyboardUtility { (height: CGFloat, duration :TimeInterval) in
            
            UIView.animate(withDuration: duration, animations: {
                self.saveButtonBottomConstraint.constant = height
                self.overlayButton.alpha = height > 0 ? 1.0 : 0.0
                self.view.layoutIfNeeded()
            })
        }
        
        saveButton.isEnabled = false
        currencyTextfield.valueHandler = { isValid in
            self.saveButton.isEnabled = isValid
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.layoutIfNeeded()
        
        animator = (CubeAttributesAnimator(), true, 1, 1)
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator?.0
        }
    }
    
    override func animate() {
        titleLabel.animate()
        saveButton.animate()
    }
    
    @IBAction func onCategoryTypeChange(_ sender: UISegmentedControl) {
        updateCategories(forSegmen: sender.selectedSegmentIndex)
    }
    
    @IBAction func onSave(_ sender: AnyObject) {
        
        if selectedCategory == nil {
            print("Select category!")
        } else {
        
            print("save!")
            
            let isExpense = expenseSegmentedControl.selectedSegmentIndex == 0
            
            let value = currencyTextfield.doubleValue
            let signedValue = isExpense ? -1*value : value
            let category = selectedCategory
            // description
            // importance
            
            let manager = ExpenseManager()
            
            if isExpense {
                manager.addExpense(with: signedValue, category: category)
            } else {
                manager.addIncome(with: signedValue, category: selectedCategory as! IncomeCategory)
            }
            
            print("added value \(signedValue)")
            
            currencyTextfield.reset()
            view.endEditing(true)
        }

    }

    private func updateCategories(forSegmen index: Int) {
        
        switch index {
        case 0:
            updateExpenseCategories()
        case 1:
            updateIncomeCategories()
        default:
            updateExpenseCategories()
        }
        
    }
    
    private func updateExpenseCategories() {
        CategoryManager().allObjects { (categories) in
            if let categories = categories {
                self.categories = categories
                self.dataSource.items = categories
                self.delegate.items = categories
            }
        }
    }
    
    private func updateIncomeCategories() {
        IncomeCategoryManager().allObjects { (categories) in
            if let categories = categories {
                self.categories = categories
                self.dataSource.items = categories
                self.delegate.items = categories
            }
        }
    }
    
    // MARK: CategoryDelegate
    
    func wantAddNewCategory() {
        
        let newCategoryVC = NewCategoryViewController { (sender, category) in
            
            self.animateOnAppearence = false
            
            if let category = category {
                self.selectedCategory = category
                self.updateCategories(forSegmen: self.expenseSegmentedControl.selectedSegmentIndex)
                
                guard
                    let categories = self.categories,
                    let index = categories.index(of: category) else { return }
                
                let indexPath = IndexPath(row: index, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            }
            
            sender.dismiss(animated: true, completion: nil)
        }
        
        let navController = UINavigationController(rootViewController: newCategoryVC)
        navController.setNavigationBarHidden(true, animated: false)
        
        present(navController, animated: true, completion: nil)
    }
    
    func didSelect(categoryItem category: Category?) {
    
        selectedCategory = category
    }
    
}
