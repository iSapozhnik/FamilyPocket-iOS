//
//  AddNewExpenseViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit
import SegmentedProgressView

public protocol LayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}

class AddNewExpenseViewController: UIViewController {

    @IBOutlet weak var titleLabel: ALabel!
    @IBOutlet weak var saveButton: AButton!
    @IBOutlet weak var currencyTextfield: CurrencyTextfield!
    @IBOutlet weak var overlayButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedProgress: SegmentedProgressView!
    
    var dataSource: CategoryCollectionViewDataSource!
    var delegate: CategoryCollectionViewDelegate!
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionViewScrollDirection = .horizontal
    let cellIdentifier = "CategoryCollectionViewCell"
    
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
        delegate = CategoryCollectionViewDelegate()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        
        collectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        CategoryManager().allObjects { (categories) in
            if let categories = categories {
                self.dataSource.items = categories
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewExpenseViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewExpenseViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        saveButton.isEnabled = false
        currencyTextfield.valueHandler = { isValid in
            self.saveButton.isEnabled = isValid
        }
        
        var items: [ProgressItem] = []
        for _ in 0...4 {
            items.append(ProgressItem(withDuration: 3))
        }
        
        segmentedProgress.itemSpace = 3.0
        segmentedProgress.items = items
        
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

    func keyboardWillShow(notification: NSNotification) {
        if
            let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval) {
            UIView.animate(withDuration: duration, animations: { 
                self.saveButtonBottomConstraint.constant = keyboardSize.height
                self.overlayButton.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if
            let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval) {
            UIView.animate(withDuration: duration, animations: {
                self.saveButtonBottomConstraint.constant = 0
                self.overlayButton.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
}
