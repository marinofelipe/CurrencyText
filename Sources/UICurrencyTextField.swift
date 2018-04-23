//
//  CurrencyTextField.swift
//  CurrencyTextField
//
//  Created by Felipe Lefèvre Marino on 3/21/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

public class UICurrencyTextField: UITextField {
    
    private var numberFormatter = NumberFormatter()
    
    // MARK: Open vars
    public var hasAutoclear: Bool = false
    public var maximumIntegers: Int? {
        didSet {
            guard let maxIntegers = maximumIntegers else { return }
            numberFormatter.maximumIntegerDigits = maxIntegers
        }
    }
    
    //Cursor
    var cursorOffsetFromEnd: Int = 0

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    // MARK: Init
    public convenience init(numberFormatter: NumberFormatter, frame: CGRect) {
        self.init(frame: frame)
        self.numberFormatter = numberFormatter
        configureKeyboard()
        addTarget()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initComponents()
    }
    
    // MARK: Configuration
    private func initComponents() {
        configureFormatter()
        configureKeyboard()
        addTarget()
    }
    
    private func configureFormatter() {
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.maximumIntegerDigits = 7
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.alwaysShowsDecimalSeparator = true
        
        numberFormatter.numberStyle = .currency
    }
    
    private func configureKeyboard() {
        keyboardType = UIKeyboardType.numberPad
    }
    
    // MARK: Text Did Change target
    private func addTarget() {
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }

    // MARK: Text Events
    @objc func textDidChange(_ textField: UICurrencyTextField) {
        
        if var text = textField.text {
            
            var isFirstInput: Bool = false
            cursorOffsetFromEnd = offset(from: endOfDocument, to: selectedTextRange!.end)
            
            guard text.numeralFormat().count > 0 else {
                textField.text?.removeAll()
                return
            }
            
            if text.count == 1 {
                text = "0.0\(text)"
                isFirstInput = true
            }
            
            text = text.numeralFormat()
                
            let maxDigitsCount = numberFormatter.maximumIntegerDigits + numberFormatter.maximumFractionDigits
            if text.numeralFormat().count > maxDigitsCount {
                text.removeLast()
            }
            
            text.addDecimalSeparator()
            if let doubleValue = Double(text.replacingOccurrences(of: numberFormatter.currencySymbol, with: "")) {
                textField.text = numberFormatter.string(from: NSNumber(value: doubleValue))
            }
            
            isFirstInput ? cursorOffsetFromEnd = 0 : ()
            updateSelectedTextRange()
        }
    }
    
    @objc func didEndEditing(_ textField: UICurrencyTextField) {
        if let text = textField.text, text.numeralFormat().representsZero() {
            textField.text = ""
        }
    }
}

// MARK: Update selected text range
extension UICurrencyTextField {
    
    func updateSelectedTextRange() {
        if let updatedCursorPosition = position(from: endOfDocument, offset: cursorOffsetFromEnd) {
            selectedTextRange = textRange(from: updatedCursorPosition, to: updatedCursorPosition)
        }
    }
}
