//
//  Animator.swift
//  FamilyPocket
//
//  Created by Sapozhnik Ivan on 13/05/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {return }
        
        transitionContext.containerView.addSubview(toVC.view)
        
        transitionContext.containerView.addConstraint(NSLayoutConstraint.init(item: toVC.view, attribute: .width, relatedBy: .equal, toItem: transitionContext.containerView, attribute: .width, multiplier: 1, constant: 0))
        transitionContext.containerView.addConstraint(NSLayoutConstraint.init(item: toVC.view, attribute: .height, relatedBy: .equal, toItem: transitionContext.containerView, attribute: .height, multiplier: 1, constant: 0))
        transitionContext.containerView.addConstraint(NSLayoutConstraint.init(item: toVC.view, attribute: .left, relatedBy: .equal, toItem: transitionContext.containerView, attribute: .left, multiplier: 1, constant: 0))
        transitionContext.containerView.addConstraint(NSLayoutConstraint.init(item: toVC.view, attribute: .top, relatedBy: .equal, toItem: transitionContext.containerView, attribute: .top, multiplier: 1, constant: 0))

        
        toVC.view.alpha = 0.0
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            toVC.view.alpha = 1.0
        }) { (finished) in
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
}
