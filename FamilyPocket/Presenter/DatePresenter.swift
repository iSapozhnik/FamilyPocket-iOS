//
//  DatePresenter.swift
//  FamilyPocket
//
//  Created by Ivan Sapozhnik on 5/17/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import Foundation

class DatePresenter {
    let dateFormatter = DateFormatter()
    
    init(withFormat format: String) {
        dateFormatter.dateFormat = format
    }
    
    func string(fromDate date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
