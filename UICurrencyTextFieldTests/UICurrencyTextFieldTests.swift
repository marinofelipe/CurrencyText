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
    var numberFormatter: NumberFormatter?
    
    override func setUp() {
        super.setUp()
        textField = UICurrencyTextField(frame: CGRect.zero)
        
        numberFormatter = NumberFormatter()
        numberFormatter?.locale = Locale(identifier: "en_US")
        numberFormatter?.minimumFractionDigits = 2
        numberFormatter?.maximumFractionDigits = 2
        numberFormatter?.maximumIntegerDigits = 7
        numberFormatter?.minimumIntegerDigits = 1
        numberFormatter?.alwaysShowsDecimalSeparator = true
        numberFormatter?.numberStyle = .currency
    }
    
    override func tearDown() {
        textField = nil
        numberFormatter = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(textField, "currency text field should not be nil")
    }
    
    // MARK: max digits
    func testMaxDigitsCount() {
        for _ in 0...20 {
            textField?.text?.append("1")
            textField!.textDidChange(textField!)
        }
        
        if let onlyDigitsText = textField?.text?.numeralFormat() {
            let maxDigits = (textField?.maximumIntegers ?? 7) + 2
            
            XCTAssertEqual(onlyDigitsText.count, maxDigits, "text count should not be more than maximumIntegerDigits + maximumFractionDigits")
        }
    }
    
    func testCustomMaxDigitsCount() {
        textField?.maximumIntegers = 4
        
        for _ in 0...20 {
            textField?.text?.append("1")
            textField!.textDidChange(textField!)
        }
        
        if let onlyDigitsText = textField?.text?.numeralFormat() {
            let maxDigits = (textField?.maximumIntegers ?? 7) + 2
            
            XCTAssertEqual(onlyDigitsText.count, maxDigits, "text count should not be more than maximumIntegerDigits + maximumFractionDigits")
        }
    }
    
    // MARK: Deletion
    func testDeletingDigits() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter!, frame: CGRect.zero)
        
        for _ in 0...9 {
            textField!.text!.append("1")
            textField!.textDidChange(textField!)
        }
        
        textField!.text!.removeLast()
        textField!.textDidChange(textField!)
        
        textField!.text!.removeLast()
        textField!.textDidChange(textField!)
        
        XCTAssertEqual(textField?.text, numberFormatter!.currencySymbol + "11,111.11", "deleting digits should keep formating and count as expected")
    }
    
    func testDeletingNotAtEndIndex() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter!, frame: CGRect.zero)
        
        for _ in 0...9 {
            textField!.text!.append("1")
            textField!.textDidChange(textField!)
        }
        
        if var text = textField?.text {
            text.replaceSubrange(text.index(text.endIndex, offsetBy: -5)..<text.index(text.endIndex, offsetBy: -4), with: "")
            textField?.text = text
            textField!.textDidChange(textField!)
            XCTAssertEqual(textField?.text, numberFormatter!.currencySymbol + "111,111.11", "deleting digits should keep formating and count as expected")
        }
    }
    
    func testSelectingAndDeletingAll() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter!, frame: CGRect.zero)
        
        for _ in 0...9 {
            textField!.text!.append("1")
            textField!.textDidChange(textField!)
        }
        
        textField?.text = ""
        textField!.textDidChange(textField!)
        
        XCTAssertNotNil(textField)
        XCTAssertEqual(textField!.text!.count, 0)
    }
    
    // MARK: input/paste
    func testFormatAfterFirstNumber() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter!, frame: CGRect.zero)
        
        textField!.text!.append("1")
        textField!.textDidChange(textField!)
        
        XCTAssertEqual(textField?.text, numberFormatter!.currencySymbol + "0.01", "after first input the text should be correctly formated")
    }
    
    func testPastingNonNumeralValues() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter!, frame: CGRect.zero)
        
        //without content
        textField!.text = ",,,,"
        textField!.textDidChange(textField!)
        
        XCTAssertEqual(textField!.text, "")
        
        //middle of the string
        textField?.text = numberFormatter!.currencySymbol + "3.456,45"
        textField!.text?.append(",,,,")
        textField!.textDidChange(textField!)
        
        if let comparableText = textField?.text {
            XCTAssertEqual(comparableText, numberFormatter!.currencySymbol + "3,456.45")
        }
        
        //middle of the string
        textField?.text = numberFormatter!.currencySymbol + "3.4,,,.56,45"
        textField!.textDidChange(textField!)
        
        if let comparableText = textField?.text {
            XCTAssertEqual(comparableText, numberFormatter!.currencySymbol + "3,456.45")
        }
    }
    
    func testInputingNotAtEndIndex() {
        textField = UICurrencyTextField(numberFormatter: numberFormatter!, frame: CGRect.zero)
        
        for _ in 0...9 {
            textField!.text!.append("1")
            textField!.textDidChange(textField!)
        }
        
        textField!.text!.replaceSubrange(textField!.text!.index(textField!.text!.endIndex, offsetBy: -5)..<textField!.text!.index(textField!.text!.endIndex, offsetBy: -4), with: "15")
        textField!.textDidChange(textField!)
        
        XCTAssertEqual(textField?.text, numberFormatter!.currencySymbol + "1,111,115.11", "deleting digits should keep formating and count as expected")
    }
    
    // MARK: Cursor
    func testCursorPosition() {
        
    }
    
    func testPerformanceExample() {
        self.measure {
            
        }
    }
    
}
