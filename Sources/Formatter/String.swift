//
//  String.swift
//  CurrencyText
//
//  Created by Felipe Lefèvre Marino on 4/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

protocol CurrencyString {
    var representsZero: Bool {get}
    var hasNumbers: Bool {get}
    func numeralFormat() -> String
    mutating func updateDecimalSeparator(decimalDigits: Int)
}

//Currency String Extension
extension String: CurrencyString {
    
    /// Informs with the string represents the value of zero
    var representsZero: Bool {
        return numeralFormat().replacingOccurrences(of: "0", with: "").count == 0
    }
    
    /// Returns if the string does have any character that represents numbers
    var hasNumbers: Bool {
        return numeralFormat().count > 0
    }
    
    /// Updates a currency string decimal separator position based on
    /// the amount of decimal digits desired
    ///
    /// - Parameter decimalDigits: The amount of decimal digits of the currency formatted string
    mutating func updateDecimalSeparator(decimalDigits: Int) {
        guard decimalDigits != 0 && count >= decimalDigits else { return }
        let decimalsRange = index(endIndex, offsetBy: -decimalDigits)..<endIndex
        
        let decimalChars = self[decimalsRange]
        replaceSubrange(decimalsRange, with: "." + decimalChars)
    }
    
    /// The numeral format of a string - remove all non numerical ocurrences
    ///
    /// - Returns: itself without the non numerical characters ocurrences
    func numeralFormat() -> String {
        return replacingOccurrences(of:"[^0-9]", with: "", options: .regularExpression)
    }
}

extension String {
    static let negativeSymbol = "-"
}
