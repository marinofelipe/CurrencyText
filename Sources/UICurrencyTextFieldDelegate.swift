//
//  UICurrencyTextFieldDelegate.swift
//  CurrencyTextField
//
//  Created by Felipe Lefèvre Marino on 12/26/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

// can be extended
public class UICurrencyTextFieldDelegate: NSObject, UITextFieldDelegate {
    
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
    
    var maxDigitsCount: Int {
        return numberFormatter.maximumIntegerDigits + numberFormatter.maximumFractionDigits
    }
    
    override public init() {
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
        
        var textToReplace = ""
        
        guard !string.isEmpty else {
            textToReplace = textField.text!
            textToReplace.removeLast()
            
            textField.text = numberFormatter.string(from: Double(textToReplace.currencyFormat()))
            return false
        }
        guard string.isNumber else { return false }
        
        let offset = textField.text!.count <= 0 ? 0 : textField.offset(from: textField.endOfDocument, to: textField.selectedTextRange!.end)
        
        if textField.text!.isEmpty {
            textToReplace = "0.0" + string
        } else {
            textToReplace = textField.text!.appending(string)
        }
        
        if textToReplace.numeralFormat().count > maxDigitsCount {
            textToReplace.removeLast()
        }
        
        textField.text = numberFormatter.string(from: Double(textToReplace.currencyFormat()))
        
        textField.updateSelectedTextRange(offset: offset)
        
        return false
    }
    
    private func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isZero && hasAutoclear {
            textField.text = ""
        }
        return true
    }
}
