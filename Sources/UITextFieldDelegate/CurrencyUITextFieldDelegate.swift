//
//  CurrencyUITextFieldDelegate.swift
//  CurrencyText
//
//  Created by Felipe Lefèvre Marino on 12/26/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
#if canImport(CurrencyFormatter)
import CurrencyFormatter
#endif


/// Custom text field delegate
public class CurrencyUITextFieldDelegate: NSObject {
    
    public var formatter: CurrencyFormatterProtocol!
    
    /// Text field clears its text when value value is equal to zero
    public var clearsWhenValueIsZero: Bool = false
    
    weak public var passthroughDelegate: UITextFieldDelegate?
    
    override public init() {
        super.init()
        self.formatter = CurrencyFormatter()
    }
    
    public init(formatter: CurrencyFormatter) {
        self.formatter = formatter
    }
}

// MARK: - UITextFieldDelegate

extension CurrencyUITextFieldDelegate: UITextFieldDelegate {
    
    @discardableResult
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return passthroughDelegate?.textFieldShouldBeginEditing?(textField) ?? true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setInitialSelectedTextRange()
        passthroughDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    @discardableResult
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.representsZero && clearsWhenValueIsZero {
            textField.text = ""
        }
        return passthroughDelegate?.textFieldShouldEndEditing?(textField) ?? true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        passthroughDelegate?.textFieldDidEndEditing?(textField)
    }
    
    @discardableResult
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return passthroughDelegate?.textFieldShouldClear?(textField) ?? true
    }
    
    @discardableResult
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return passthroughDelegate?.textFieldShouldReturn?(textField) ?? true
    }
    
    @discardableResult
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !(passthroughDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true) {
            return false
        }
        
        guard !string.isEmpty else {
            handleCursor(textField: textField, changingCharactersIn: range) {
                handleDeletion(in: textField, at: range)
            }
            return false
        }
        guard string.hasNumbers else {
            handleCursor(textField: textField, changingCharactersIn: range) {
                addNegativeSymbolIfNeeded(in: textField, at: range, replacementString: string)
            }
            return false
        }
        
        handleCursor(textField: textField, changingCharactersIn: range) {
            setFormattedText(in: textField, inputString: string, range: range)
        }
        
        return false
    }
}

// MARK: - Private

extension CurrencyUITextFieldDelegate {
    
    /// Capture current cursor position, allow the field to be altered, 
    /// then restore the cursor position to the correct location.
    ///
    /// - Parameters:
    ///   - textField: text field that user interacted with
    ///   - range: range of characters changing
    ///   - textFieldUpdate: closure that updates text field text
    private func handleCursor(on textField: UITextField, changingCharactersIn range: NSRange, after textFieldUpdate: () -> Void) {
        let preFormatLength = textField.text?.count ?? 0
        fieldAlterationAction()
        let postFormatLength = textField.text?.count ?? 0
        let lengthChange = postFormatLength - preFormatLength
        let cursorPosition = range.location + range.length + lengthChange
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    /// Verifies if user inputed a negative symbol at the first lowest
    /// bound of the text field and add it.
    ///
    /// - Parameters:
    ///   - textField: text field that user interacted with
    ///   - range: user input range
    ///   - string: user input string
    private func addNegativeSymbolIfNeeded(in textField: UITextField, at range: NSRange, replacementString string: String) {
        guard textField.keyboardType == .numbersAndPunctuation else { return }
        
        if string == .negativeSymbol && textField.text?.isEmpty == true {
            textField.text = .negativeSymbol
        } else if range.lowerBound == 0 && string == .negativeSymbol &&
            textField.text?.contains(String.negativeSymbol) == false {
            
            textField.text = .negativeSymbol + (textField.text ?? "")
        }
    }
    
    /// Correctly delete characters when user taps remove key.
    ///
    /// - Parameters:
    ///   - textField: text field that user interacted with
    ///   - range: range to be removed
    private func handleDeletion(in textField: UITextField, at range: NSRange) {
        if var text = textField.text {
            if let textRange = Range(range, in: text) {
                text.removeSubrange(textRange)
            } else {
                text.removeLast()
            }
            
            if text.isEmpty {
                textField.text = text
            } else {
                textField.text = formatter.updated(formattedString: text)
            }
        }
    }
    
    /// Formats text field's text with new input string and changed range
    ///
    /// - Parameters:
    ///   - textField: text field that user interacted with
    ///   - inputString: typed string
    ///   - range: range where the string should be added
    private func setFormattedText(in textField: UITextField, inputString: String, range: NSRange) {
        var updatedText = ""
        
        if let text = textField.text {
            if text.isEmpty {
                updatedText = formatter.string(from: Double(inputString)) ?? "0.0"
            } else if let range = Range(range, in: text) {
                updatedText = text.replacingCharacters(in: range, with: inputString)
            } else {
                updatedText = text.appending(inputString)
            }
        }
        
        if updatedText.numeralFormat().count > formatter.maxDigitsCount {
            updatedText.removeLast()
        }
        
        textField.text = formatter.updated(formattedString: updatedText)
    }
}
