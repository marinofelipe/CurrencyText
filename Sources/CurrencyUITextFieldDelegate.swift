//
//  CurrencyUITextFieldDelegate.swift
//  CurrencyText
//
//  Created by Felipe Lefèvre Marino on 12/26/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

public class CurrencyUITextFieldDelegate: NSObject {
    
    public var numberFormatter = NumberFormatter()
    
    /// if true text field is cleared when resign as first responder with value = 0
    public var hasAutoclear: Bool = false
    
    /// define maximum amount of integer numbers
    public var maxIntegers: Int? {
        didSet {
            guard let maxIntegers = maxIntegers else { return }
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

extension CurrencyUITextFieldDelegate: UITextFieldDelegate {
    
    @discardableResult
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let previousSelectedTextRangeOffsetFromEnd = textField.selectedTextRangeOffsetFromEnd
        
        guard !string.isEmpty else {
            handleDeletion(in: textField, at: range)
            updateSelectedTextRange(in: textField, previousOffsetFromEnd: previousSelectedTextRangeOffsetFromEnd)
            return false
        }
        guard string.hasNumbers else { return false }
        
        setFormattedText(in: textField, inputString: string, range: range)
        updateSelectedTextRange(in: textField, previousOffsetFromEnd: previousSelectedTextRangeOffsetFromEnd)
        
        return false
    }
    
    @discardableResult
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isZero && hasAutoclear {
            textField.text = ""
        }
        return true
    }
}

// add to another file??
extension CurrencyUITextFieldDelegate {
    
    private func handleDeletion(in textField: UITextField, at range: NSRange) {
        if var text = textField.text {
            if let textRange = Range(range, in: text) {
                text.removeSubrange(textRange)
            } else {
                text.removeLast()
            }
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
