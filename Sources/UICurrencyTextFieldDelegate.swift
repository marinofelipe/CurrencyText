//
//  UICurrencyTextFieldDelegate.swift
//  CurrencyTextField
//
//  Created by Felipe Lefèvre Marino on 12/26/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

public class UICurrencyTextFieldDelegate: NSObject {
    
    public var numberFormatter = NumberFormatter()
    
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
}

extension UICurrencyTextFieldDelegate: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard !string.isEmpty else {
            handleDeletion(in: textField)
            return false
        }
        guard string.isNumber else { return false }
        
        let previousSelectedTextRangeOffsetFromEnd = textField.selectedTextRangeOffsetFromEnd
        setFormattedText(in: textField, inputString: string, range: range)
        updateSelectedTextRange(in: textField, previousOffsetFromEnd: previousSelectedTextRangeOffsetFromEnd)
        
        return false
    }
    
    private func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isZero && hasAutoclear {
            textField.text = ""
        }
        return true
    }
}

// add to another file??
extension UICurrencyTextFieldDelegate {
    
    private func handleDeletion(in textField: UITextField) {
        if var text = textField.text {
            text.removeLast()
            textField.text = numberFormatter.string(from: Double(text.currencyFormat()))
        }
    }
    
    private func updateSelectedTextRange(in textField: UITextField, previousOffsetFromEnd: Int) {
        var offset = previousOffsetFromEnd
        if let text = textField.text, text.isEmpty {
            offset = 0
        }
        textField.updateSelectedTextRange(offsetFromEnd: offset)
    }
    
    private func setFormattedText(in textField: UITextField, inputString: String, range: NSRange) {
        var updatedText = ""
        
        if let text = textField.text {
            if text.isEmpty {
                updatedText = "0.0" + inputString
            } else if let range = Range(range, in: text) {
                updatedText = text.replacingCharacters(in: range, with: inputString)
            } else {
                updatedText = text.appending(inputString)
            }
        }
        
        if updatedText.numeralFormat().count > maxDigitsCount {
            updatedText.removeLast()
        }
        
        textField.text = numberFormatter.string(from: Double(updatedText.currencyFormat()))
    }
}
