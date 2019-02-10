//
//  String.swift
//  CurrencyText
//
//  Created by Felipe Lefèvre Marino on 4/3/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

protocol CurrencyString {
    var isZero: Bool {get}
    var hasNumbers: Bool {get}
    mutating func addDecimalSeparator()
    func numeralFormat() -> String
}

//String Currency Extension
extension String: CurrencyString {
    
    var isZero: Bool {
        return numeralFormat().replacingOccurrences(of: "0", with: "").count == 0
    }
    
    var hasNumbers: Bool {
        return numeralFormat().count > 0
    }
    
    //moves separator one character to the right. Keeps currency formatted
    mutating func addDecimalSeparator() {
        guard count >= 2 else { return }
        let lastTwoChars = self[index(endIndex, offsetBy: -2)..<endIndex]
        replaceSubrange(index(endIndex, offsetBy: -2)..<endIndex, with: "." + lastTwoChars)
    }
    
    func currencyFormat() -> String {
        var currencyString = numeralFormat()
        currencyString.addDecimalSeparator()
        return currencyString
    }
    
    func numeralFormat() -> String {
        return replacingOccurrences(of:"[^0-9]", with: "", options: .regularExpression)
    }
}
