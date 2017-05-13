//
//  HostingViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class HostingViewController: UIViewController {

    public private(set) var viewControllers: [UIViewController]!
    public private(set) var selectedViewController: UIViewController? {
        willSet {
            transitionToChildViewController(newValue)
        }
        didSet {
            UIView.animate(withDuration: 0.3) { 
                self.selectedViewController?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    fileprivate var contentView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    
    init(with viewControllers: [UIViewController]) {
        
        self.viewControllers = viewControllers
        self.selectedViewController = viewControllers.first
        
        super.init(nibName: nil, bundle: nil)
        
        for c in viewControllers {
            let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(HostingViewController.swipedLeft(_:)))
            leftSwipe.direction = .right
            
            let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(HostingViewController.swipedRight(_:)))
            rightSwipe.direction = .left
            
            c.view.addGestureRecognizer(leftSwipe)
            c.view.addGestureRecognizer(rightSwipe)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
        selectedViewController = selectedViewController ?? viewControllers.first
    }
    
    override func loadView() {
        
        super.loadView()
        
        contentView = UIView()
        contentView.backgroundColor = .blue
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(contentView)
        
        view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: contentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        
    }
    
    fileprivate func transitionToChildViewController(_ toVC: UIViewController!) {
        
        let fromVC: UIViewController? = childViewControllers.count > 0 ? childViewControllers[0] : nil
        
        if toVC == fromVC || !isViewLoaded { return }
        
        guard let toView = toVC.view else { return }
        
        toView.translatesAutoresizingMaskIntoConstraints = false
//        toView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        toView.frame = contentView.bounds
        
        fromVC?.willMove(toParentViewController: nil)
        addChildViewController(toVC)
        
        // Initial display without animation
        if fromVC == nil {
            contentView.addSubview(toView)
            
            contentView.addConstraint(NSLayoutConstraint.init(item: toView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint.init(item: toView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .height, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint.init(item: toView, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0))
            contentView.addConstraint(NSLayoutConstraint.init(item: toView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
            
            toVC.didMove(toParentViewController: self)
            return
        }
        
        guard let formVCUnw = fromVC else { return }
        guard let fromIndex = viewControllers.index(of: formVCUnw) else { return }
        guard let toIndex = viewControllers.index(of: toVC) else { return }
        
        let animator = Animator()
        
        let context = PrivateTransitionContext(withFromViewController: formVCUnw, toViewController: toVC, goingRight: toIndex > fromIndex)
        context.completionBlock = {

            formVCUnw.view.removeFromSuperview()
            formVCUnw.removeFromParentViewController()
            toVC.didMove(toParentViewController: self)
        }
        
        animator.animateTransition(using: context)
    }
    
    func swipedLeft(_ gesture: UIGestureRecognizer) {
        
        guard let selectedVC = selectedViewController else { return }
        guard var toIndex = viewControllers.index(of: selectedVC) else { return }
        
        toIndex -= 1
        
        if toIndex >= 0 && toIndex < viewControllers.count {
            selectedViewController = viewControllers[toIndex]
        }
    }
    
    func swipedRight(_ gesture: UIGestureRecognizer) {
        
        guard let selectedVC = selectedViewController else { return }
        guard var toIndex = viewControllers.index(of: selectedVC) else { return }
        
        toIndex += 1
        
        if toIndex < viewControllers.count {
            selectedViewController = viewControllers[toIndex]
        }
    }
}
