//
//  AButton.swift
//  FamilyPocket
//
//  Created by Sapozhnik Ivan on 13/05/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

protocol BottomAnimatable: Animatable {
    
    var bottomConstraint: NSLayoutConstraint! { get set }
    var initialBottomConstant: CGFloat! { get }
    var finalBottomConstant: CGFloat! { get }
    
}

class AButton: UIButton, BottomAnimatable {
    
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    internal var finalBottomConstant: CGFloat!
    internal var initialBottomConstant: CGFloat!
    internal var initialLayoutingDone: Bool = false
    
    func animate(withCompletion completion: ((Bool) -> ())? = nil) {
        bottomConstraint.constant = initialBottomConstant
        superview?.layoutIfNeeded()
        alpha = 0.0
        
        UIView.animate(withDuration: 0.3, delay: 0.15, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.bottomConstraint.constant = self.finalBottomConstant
            self.alpha = 1.0
            self.superview?.layoutIfNeeded()
            }, completion: completion)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !initialLayoutingDone {
            finalBottomConstant = bottomConstraint.constant
            
            let height = bounds.height
            let constant = bottomConstraint.constant
            
            initialBottomConstant = -(constant + height)
            bottomConstraint.constant -= constant + height
            
            initialLayoutingDone = true
        }
    }

}
