//
//  AppHelpers.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/24/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation

extension UserDefaults {
    class func groupUserDefaults() -> UserDefaults {
        return UserDefaults(suiteName: "group.\(Constants.bundle())")!
    }
}
