//
//  CurrencyUITextFieldDelegate.swift
//  CurrencyText
//
//  Created by Felipe Lefèvre Marino on 12/26/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

/// Custom text field delegate
public class CurrencyUITextFieldDelegate: NSObject {
    
    public var formatter: CurrencyFormatterProtocol!
    
    /// Text field clears its text when value value is equal to zero
    public var clearsWhenValueIsZero: Bool = false
    
    /// Text field clears when this condition is satisfied
    public var clearCondition: (() -> Void)?
    
    override public init() {
        super.init()
        self.formatter = CurrencyFormatter()
    }
    
    public init(formatter: CurrencyFormatter) {
        self.formatter = formatter
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
        if let text = textField.text, text.isZero && clearsWhenValueIsZero {
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
            textField.text = formatter.string(from: Double(text.currencyFormat()))
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
        
        if updatedText.numeralFormat().count > formatter.maxDigitsCount {
            updatedText.removeLast()
        }
        
        textField.text = formatter.string(from: Double(updatedText.currencyFormat()))
    }
}
