//
//  ContextTransitioning.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        
        var containerView = transitionContext.containerView
        var fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        var toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        var button = fromViewController.button
        
        containerView.addSubview((toViewController?.view)!)
        
        var circleMaskPathInitial = UIBezierPath(ovalIn: (button?.frame)!)
        var extremePoint = CGPoint(x: (button?.center.x)! - 0, y: (button?.center.y)! - toViewController.view.bounds.height)
        var radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
        var circleMaskPathFinal = UIBezierPath(ovalIn: (button?.frame)!.insetBy(dx: -radius, dy: -radius))
        
        var maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toViewController?.view.layer.mask = maskLayer
        
        var maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnimation.toValue = circleMaskPathFinal.cgPath
        maskLayerAnimation.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnimation.delegate = self as! CAAnimationDelegate
        maskLayer.add(maskLayerAnimation, forKey: "path")
        
        
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled())
        self.transitionContext?.viewController(forKey: UITransitionContextFromViewControllerKey)?.view.layer.mask = nil
    }
    
}
