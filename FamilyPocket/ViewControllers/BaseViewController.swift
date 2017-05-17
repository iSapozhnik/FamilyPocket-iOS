//
//  BaseViewController.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var animateOnAppearence: Bool = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if animateOnAppearence {
            animate()
        }
        animateOnAppearence = true
    }
    
    func animate() {
        
    }

}
