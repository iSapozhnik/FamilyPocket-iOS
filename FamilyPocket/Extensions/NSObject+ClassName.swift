//
//  NSObject+ClassName.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 4/20/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

extension UIViewController {
    class var className: String {
        return String(describing: self)
    }
}
