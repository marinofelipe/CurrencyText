//
//  CurrencyTextFieldTests.swift
//  CurrencyTextFieldTests
//
//  Created by Felipe Lefèvre Marino on 3/21/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import UICurrencyTextField

class CurrencyTextFieldTests: XCTestCase {
    
    var textField: UICurrencyTextField?
    var numberFormatter = NumberFormatter()
    
    override func setUp() {
        super.setUp()
        textField = UICurrencyTextField(frame: CGRect.zero)
        
        numberFormatter.locale = Locale(identifier: "en_US")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.maximumIntegerDigits = 7
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.numberStyle = .currency
    }
    
    override func tearDown() {
        textField = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(textField, "currency text field should not be nil")
    }
    
    // MARK: max digits
    func testMaxDigitsCount() {
        guard let textField = textField else { return }
        
        for _ in 0...20 {
            textField.text?.append("1")
            textField.sendActions(for: .editingChanged)
        }
        
        if let onlyDigitsText = textField.text?.numeralFormat() {
            let maxDigits = (textField.maximumIntegers ?? 7) + 2
            
            XCTAssertEqual(onlyDigitsText.count, maxDigits, "text count should not be more than maximumIntegerDigits + maximumFractionDigits")
        }
    }
    
    func testCustomMaxDigitsCount() {
        textField?.maximumIntegers = 4
        guard let textField = textField else { return }
        
        for _ in 0...20 {
            textField.text?.append("1")
            textField.sendActions(for: .editingChanged)
        }
        
        if let onlyDigitsText = textField.text?.numeralFormat() {
            let maxDigits = (textField.maximumIntegers ?? 7) + 2
            
            XCTAssertEqual(onlyDigitsText.count, maxDigits, "text count should not be more than maximumIntegerDigits + maximumFractionDigits")
        }
    }
    
    // MARK: Deletion
    func testDeletingDigits() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter, frame: CGRect.zero)
        guard let textField = textField else { return }
        
        for _ in 0...9 {
            textField.text?.append("1")
            textField.sendActions(for: .editingChanged)
        }
        
        textField.text?.removeLast()
        textField.sendActions(for: .editingChanged)
        
        textField.text?.removeLast()
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "11,111.11", "deleting digits should keep formating and count as expected")
        
        //removing beyond decimal separator
        textField.text = "$0.19"
        textField.text?.removeLast()
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "0.01", "deleting digits should keep formating and count as expected")
        
        textField.text?.removeLast()
        textField.sendActions(for: .editingChanged)
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "0.00", "deleting digits should keep formating and count as expected")
    }
    
    func testDeletingNotAtEndIndex() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter, frame: CGRect.zero)
        guard let textField = textField else { return }
        
        for _ in 0...9 {
            textField.text?.append("1")
            textField.sendActions(for: .editingChanged)
        }
        
        if var text = textField.text {
            text.replaceSubrange(text.index(text.endIndex, offsetBy: -5)..<text.index(text.endIndex, offsetBy: -4), with: "")
            textField.text = text
            textField.sendActions(for: .editingChanged)
            XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "111,111.11", "deleting digits should keep formating and count as expected")
        }
    }
    
    func testSelectingAndDeletingAll() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter, frame: CGRect.zero)
        guard let textField = textField else { return }
        
        for _ in 0...9 {
            textField.text?.append("1")
            textField.sendActions(for: .editingChanged)
        }
        
        textField.text = ""
        textField.sendActions(for: .editingChanged)
        
        XCTAssertNotNil(textField)
        if let text = textField.text {
            XCTAssertEqual(text.count, 0)
        }
    }
    
    // MARK: input/paste
    func testFormatAfterFirstNumber() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter, frame: CGRect.zero)
        guard let textField = textField else { return }
        
        textField.text?.append("1")
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "0.01", "after first input the text should be correctly formated")
    }
    
    func testPastingNonNumeralValues() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter, frame: CGRect.zero)
        guard let textField = textField else { return }
        
        //without content
        textField.text = ",,,,"
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, "")
        
        //middle of the string
        textField.text = numberFormatter.currencySymbol + "3.456,45"
        textField.text?.append(",,,,")
        textField.sendActions(for: .editingChanged)
        
        if let comparableText = textField.text {
            XCTAssertEqual(comparableText, numberFormatter.currencySymbol + "3,456.45")
        }
        
        //middle of the string
        textField.text = numberFormatter.currencySymbol + "3.4,,,.56,45"
        textField.sendActions(for: .editingChanged)
        
        if let comparableText = textField.text {
            XCTAssertEqual(comparableText, numberFormatter.currencySymbol + "3,456.45")
        }
    }
    
    func testInputingNotAtEndIndex() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter, frame: CGRect.zero)
        guard let textField = textField else { return }
        
        for _ in 0...9 {
            textField.text?.append("1")
            textField.sendActions(for: .editingChanged)
        }
        
        textField.text!.replaceSubrange(textField.text!.index(textField.text!.endIndex, offsetBy: -5)..<textField.text!.index(textField.text!.endIndex, offsetBy: -4), with: "15")
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "1,111,115.11", "deleting digits should keep formating and count as expected")
    }
    
    // MARK: End of editing
    func testAutoclear() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter, frame: CGRect.zero)
        guard let textField = textField else { return }
        
        textField.hasAutoclear = true
        
        for _ in 0...2 {
            textField.text!.append("0")
            textField.sendActions(for: .editingChanged)
        }
        
        textField.sendActions(for: .editingDidEnd)
        XCTAssertTrue(textField.text!.count == 0, "Text field text count should be zero because hasAutoclear is enabled")
        
        
        textField.hasAutoclear = false
        for _ in 0...2 {
            textField.text?.append("0")
            textField.sendActions(for: .editingChanged)
        }
        
        textField.sendActions(for: .editingDidEnd)
        XCTAssertTrue(textField.text!.count > 0, "Text field text count should not be zero when autoclear is disabled")
    }
    
    // MARK: Cursor
    func testCursorPosition() {
        guard let textField = textField else { return }
        
        textField.text = "3"
        textField.sendActions(for: .editingChanged)
        
        XCTAssertEqual(textField.selectedTextRange, textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument), "After first input selected range should be endOfDocument")
        XCTAssertEqual(textField.cursorOffsetFromEnd, 0, "After first input cursorOffsetFromEnd should be 0")
    }
}
