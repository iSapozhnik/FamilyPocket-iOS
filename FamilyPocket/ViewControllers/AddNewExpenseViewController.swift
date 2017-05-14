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

class AddNewExpenseViewController: UIViewController, CategoryDelegate {

    @IBOutlet weak var titleLabel: ALabel!
    @IBOutlet weak var saveButton: AButton!
    @IBOutlet weak var currencyTextfield: CurrencyTextfield!
    @IBOutlet weak var overlayButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: CategoryCollectionViewDataSource!
    var delegate: CategoryCollectionViewDelegate!
    
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
        
        CategoryManager().allObjects { (categories) in
            if let categories = categories {
                self.dataSource.items = categories
                self.delegate.items = categories
            }
        }
        
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
        
        titleLabel.animate()
        saveButton.animate()
        
        collectionView.layoutIfNeeded()
        
        animator = (CubeAttributesAnimator(), true, 1, 1)
        if let layout = collectionView?.collectionViewLayout as? AnimatedCollectionViewLayout {
            layout.scrollDirection = direction
            layout.animator = animator?.0
        }
    }
    
    @IBAction func onExpense(_ sender: AnyObject) {
        currencyTextfield.text = "-8"
        currencyTextfield.editingChanged()
    }
    
    @IBAction func onSave(_ sender: AnyObject) {
        print("save!")
        currencyTextfield.reset()
        view.endEditing(true)
    }

    func wantAddNewCategory() {
        
        let paletteVC = ColorPaletteTableViewController()
        present(paletteVC, animated: true, completion: nil)
        
    }
    
}
