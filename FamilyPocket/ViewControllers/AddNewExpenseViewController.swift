//
//  AddNewExpenseViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit
import SegmentedProgressView

extension UIColor {
    
    func lighterColor() -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}
        
        return UIColor(hue: h,
                       saturation: s,
                       brightness: b * 0.95,
                       alpha: a)
    }
    
    func darkerColor() -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0
        
        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}
        
        return UIColor(hue: h,
                       saturation: s,
                       brightness: b * 0.85,
                       alpha: a)
    }
}

extension String {
    var hexColor: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

public protocol LayoutAttributesAnimator {
    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes)
}

class AddNewExpenseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var titleLabel: ALabel!
    @IBOutlet weak var saveButton: AButton!
    @IBOutlet weak var currencyTextfield: CurrencyTextfield!
    @IBOutlet weak var overlayButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedProgress: SegmentedProgressView!
    
    var animator: (LayoutAttributesAnimator, Bool, Int, Int)?
    var direction: UICollectionViewScrollDirection = .horizontal
    let cellIdentifier = "SimpleCollectionViewCell"
    
    let vcs = [("03a9f4", "Internet"),
               ("9c27b0", "Food"),
               ("03a9f4", "Rent"),
               ("009688", "Travel"),
               ("FFEB3B", "Transport"),
               ("FF9800", "Car"),
               ("607D8B", "Games"),
               ("f44336", "Add new")]
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewExpenseViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewExpenseViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        saveButton.isEnabled = false
        currencyTextfield.valueHandler = { isValid in
            self.saveButton.isEnabled = isValid
        }
        
        collectionView.register(UINib.init(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let cell = c as? CategoryCollectionViewCell {
            let i = indexPath.row % vcs.count
            let v = vcs[i]

            cell.bind(categoryName: v.1)
            cell.clipsToBounds = animator?.1 ?? true
        }
        
        return c
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        let i = indexPath.row % vcs.count
        let v = vcs[i]
        
        cell.contentView.backgroundColor = v.0.hexColor

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
