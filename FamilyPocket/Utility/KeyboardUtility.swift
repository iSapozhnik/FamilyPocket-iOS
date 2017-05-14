//
//  KeyboardUtility.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

class KeyboardUtility: NSObject {
    
    typealias KeyboardHandler = (_ height: CGFloat, _ duration: TimeInterval) -> ()
    
    var keyboardHandler: KeyboardHandler?
    
    init(withHandler handler: KeyboardHandler?) {
        super.init()
        
        keyboardHandler = handler
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardUtility.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardUtility.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if
            let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval) {
            
            keyboardHandler?((keyboardSize.height, duration))
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if
            let duration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval) {
            
            keyboardHandler?(0.0, duration)
        }
    }
}
