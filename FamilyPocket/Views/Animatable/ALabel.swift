//
//  ALabel.swift
//  FamilyPocket
//
//  Created by Sapozhnik Ivan on 13/05/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

protocol Animatable {
    
    var initialLayoutingDone: Bool { get set }
    func animate(withCompletion completion: ((Bool) -> ())?)
}

protocol TopAnimatable: Animatable {
    
    var topConstraint: NSLayoutConstraint! { get set }
    var initialTopConstant: CGFloat! { get }
    var finalTopConstant: CGFloat! { get }
}

class ALabel: UILabel, TopAnimatable {

    @IBOutlet var topConstraint: NSLayoutConstraint!
    
    internal var finalTopConstant: CGFloat!
    internal var initialTopConstant: CGFloat!
    internal var initialLayoutingDone: Bool = false
    
    func animate(withCompletion completion: ((Bool) -> ())? = nil) {
        topConstraint.constant = initialTopConstant
        superview?.layoutIfNeeded()
        alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.15, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.topConstraint.constant = self.finalTopConstant
            self.alpha = 1.0
            self.superview?.layoutIfNeeded()
        }, completion: completion)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !initialLayoutingDone {
            finalTopConstant = topConstraint.constant
            
            let labelHeight = bounds.height
            let topConstant = topConstraint.constant
            
            initialTopConstant = -(topConstant + labelHeight)
            topConstraint.constant -= topConstant + labelHeight
            
            initialLayoutingDone = true
        }
    }
}
