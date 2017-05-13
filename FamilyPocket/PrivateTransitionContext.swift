//
//  PrivateTransitionContext.swift
//  FamilyPocket
//
//  Created by Sapozhnik Ivan on 13/05/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class PrivateTransitionContext: NSObject, UIViewControllerContextTransitioning {

    typealias Completion = () -> ()
    
    var isAnimated: Bool = true
    var isInteractive: Bool = false
    var transitionWasCancelled: Bool = false
    var targetTransform: CGAffineTransform = .identity
    var containerView: UIView

    var privateViewControllers: [UITransitionContextViewControllerKey:UIViewController]!
    var privateDisappearingFromRect: CGRect
    var privateAppearingFromRect: CGRect
    var privateDisappearingToRect: CGRect
    var privateAppearingToRect: CGRect
    var presentationStyle: UIModalPresentationStyle = .custom
    
    var completionBlock: Completion?
    
    init(withFromViewController fromController: UIViewController, toViewController toController: UIViewController, goingRight: Bool) {
        assert(fromController.isViewLoaded && (fromController.view.superview != nil), "The fromViewController view must reside in the container view upon initializing the transition context.")
        
        self.containerView = fromController.view.superview!
        
        self.privateViewControllers = [UITransitionContextViewControllerKey.from:fromController,UITransitionContextViewControllerKey.to: toController]
        
        let travelDistance = goingRight ? -self.containerView.bounds.width : self.containerView.bounds.width
        
        self.privateAppearingToRect = self.containerView.bounds
        
        self.privateDisappearingFromRect = self.privateAppearingToRect
        
        self.privateDisappearingToRect = self.containerView.bounds.offsetBy(dx: travelDistance, dy: 0)
        self.privateAppearingFromRect = self.containerView.bounds.offsetBy(dx: -travelDistance, dy: 0)
        
    }
    
    func initialFrame(for vc: UIViewController) -> CGRect {
        if vc == viewController(forKey: UITransitionContextViewControllerKey.from) {
            return self.privateDisappearingFromRect
        } else {
            return self.privateAppearingFromRect
        }
    }
    
    func finalFrame(for vc: UIViewController) -> CGRect {
        if vc == viewController(forKey: UITransitionContextViewControllerKey.from) {
            return self.privateDisappearingToRect
        } else {
            return self.privateAppearingToRect
        }
    }
    
    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        return self.privateViewControllers[key]
    }
    
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        if key == UITransitionContextViewKey.from {
            return viewController(forKey: UITransitionContextViewControllerKey.from)?.view
        } else {
            return viewController(forKey: UITransitionContextViewControllerKey.to)?.view
        }
    }
    
    func completeTransition(_ didComplete: Bool) {
        completionBlock?()
    }
    
    public func updateInteractiveTransition(_ percentComplete: CGFloat) {}
    
    public func finishInteractiveTransition() {}
    
    public func cancelInteractiveTransition() {}
    
    func pauseInteractiveTransition() {}
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {}
    
}
