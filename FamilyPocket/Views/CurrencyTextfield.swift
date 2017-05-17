//
//  CurrencyTextfield.swift
//  FamilyPocket
//
//  Created by Sapozhnik Ivan on 13/05/17.
//  Copyright © 2017 Ivan Sapozhnik. All rights reserved.
//

import UIKit

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
extension Formatter {
    static var currency: NumberFormatter {
        let result = NumberFormatter(numberStyle: .currency)
//        result.paddingPosition = .afterPrefix
        return result
    }
}
extension String {
    var digits: [UInt8] { return characters.flatMap{ UInt8(String($0)) } }
}
extension Collection where Iterator.Element == UInt8 {
    var string: String { return map(String.init).joined() }
    var decimal: Decimal { return Decimal(string: string) ?? 0 }
}
extension Decimal {
    var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
}

protocol AlphaAnimatable {
    func animate()
}

class CurrencyTextfield: UITextField, AlphaAnimatable {

    var valueHandler: ((Bool) -> ())?
    var string: String { return text ?? "" }
    var decimal: Decimal {
        return string.digits.decimal /
            Decimal(pow(10, Double(Formatter.currency.maximumFractionDigits)))
    }
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue   }
    let maximum: Decimal = 999_999_999.99
    private var lastValue: String = ""

    override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged()
    }
    
    override func deleteBackward() {
        text = string.digits.dropLast().string
        editingChanged()
    }
    
    func editingChanged() {
        guard decimal <= maximum else {
            text = lastValue
            return
        }
        lastValue = Formatter.currency.string(for: decimal) ?? ""
        text = lastValue
        valueHandler?(decimal > 0.0)
    }
    
    internal func animate() {
        alpha = 0.0
        UIView.animate(withDuration: 0.3, delay: 0.15, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func reset() {
        text = ""
        editingChanged()
    }
    
}
