//
//  Constants.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/24/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation

public enum Constants {
    public static func bundle() -> String {
        return "Ivan.Sapozhnik.FamilyPocket"
    }
    
    public enum SharedKeys: Int {
        case category
        
        public func key() -> String {
            switch self {
            case .category:
                return "Category"
            }
        }
    }
}
