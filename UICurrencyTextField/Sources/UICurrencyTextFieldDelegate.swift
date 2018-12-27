//
//  CurrencyTextField.swift
//  CurrencyTextField
//
//  Created by Felipe Lefèvre Marino on 3/21/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

// can be extended
class UICurrencyTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    private var numberFormatter = NumberFormatter()
    
    /// if true text field is cleared when resign first responder with value = 0
    public var hasAutoclear: Bool = false
    // should autoclear ?? block to decide when?? or condition ??
    
    /// define maximum amount of integer numbers
    public var maximumIntegers: Int? {
        didSet {
            guard let maxIntegers = maximumIntegers else { return }
            numberFormatter.maximumIntegerDigits = maxIntegers
        }
    }
    
    override init() {
        super.init()
        numberFormatter = NumberFormatter()
        configureFormatter()
    }
    
    private func configureFormatter() {
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.maximumIntegerDigits = 7
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.alwaysShowsDecimalSeparator = true
        
        numberFormatter.numberStyle = .currency
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard string.isNumber else { return false }
        
        let offset = textField.text!.count <= 0 ? 0 : textField.offset(from: textField.endOfDocument, to: textField.selectedTextRange!.end)
        
        var textToReplace = ""
        if string.count == 1 { textToReplace = "0.0" + string }
        
        textToReplace = textToReplace.numeralFormat()
        
        let maxDigitsCount = numberFormatter.maximumIntegerDigits + numberFormatter.maximumFractionDigits
        if textToReplace.numeralFormat().count > maxDigitsCount {
            textField.text?.removeLast()
            return false
        }
        
        textToReplace.addDecimalSeparator()
        if let doubleValue = Double(textToReplace.replacingOccurrences(of: numberFormatter.currencySymbol, with: "")) {
            textField.text = numberFormatter.string(from: NSNumber(value: doubleValue))
        }
        
        textField.updateSelectedTextRange(offset: offset)
        
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isZero && hasAutoclear {
            textField.text = ""
        }
        return true
    }
}
