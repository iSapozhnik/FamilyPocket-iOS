//
//  UIColor+FamilyPocket.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/14/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func mainGreenColor() -> UIColor {
        return "#57CE86".hexColor
    }
    
}

extension UIColor
{
    func hexString() -> String
    {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0
        return NSString(format:"#%06x", rgb) as String
    }
}
