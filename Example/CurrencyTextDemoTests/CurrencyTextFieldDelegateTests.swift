//
//  CurrencyTextFieldDelegateTests.swift
//  CurrencyTextFieldTests
//
//  Created by Felipe Lefèvre Marino on 3/21/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import CurrencyText

class CurrencyTextFieldDelegateTests: XCTestCase {
    
    var textField: UITextField!
    var delegate: CurrencyUITextFieldDelegate!
    var numberFormatter = NumberFormatter()
    
    override func setUp() {
        super.setUp()
//        textField = UITextField()
//
//        delegate = CurrencyUITextFieldDelegate()
//
//        numberFormatter.locale = Locale(identifier: "en_US")
//        numberFormatter.minimumFractionDigits = 2
//        numberFormatter.maximumFractionDigits = 2
//        numberFormatter.maximumIntegerDigits = 7
//        numberFormatter.minimumIntegerDigits = 1
//        numberFormatter.alwaysShowsDecimalSeparator = true
//        numberFormatter.numberStyle = .currency
//
//        delegate.numberFormatter = numberFormatter
//
//        textField.delegate = delegate
    }
    
    override func tearDown() {
        textField = nil
        delegate = nil
        super.tearDown()
    }
    
    func testInit() {
//        XCTAssertNotNil(delegate.numberFormatter, "number formatter should not be nil")
//        XCTAssertNil(delegate.maxIntegers, "max integers should be nil")
    }
    
    // MARK: max digits
    func testMaxDigitsCount() {
        for _ in 0...20 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "1")
        }

        if let numericalText = textField.text?.numeralFormat() {
//            XCTAssertEqual(numericalText.count, delegate.maxDigitsCount, "text count should not be more than maxDigitsCount")
        }
    }

    func testCustomMaxDigitsCount() {
//        delegate?.maxIntegers = 4
        
        for _ in 0...20 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "1")
        }

        if let onlyDigitsText = textField.text?.numeralFormat() {
//            XCTAssertEqual(onlyDigitsText.count, delegate.maxDigitsCount, "text count should not be more than maxDigitsCount")
        }
    }

    // MARK: Deletion
    func testDeleting() {
        for _ in 0...9 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "1")
        }

        textField.sendTextLastCharDeleteAction()
        textField.sendTextLastCharDeleteAction()

        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "11,111.11", "deleting digits should keep formating and count as expected")

        // removing beyond decimal separator
        textField.text = "$0.19"
        
        textField.sendTextLastCharDeleteAction()

        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "0.01", "deleting digits should keep formating and count as expected")

        textField.sendTextLastCharDeleteAction()
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "0.00", "deleting digits should keep formating and count as expected")
    }

    func testDeletingNotAtEndIndex() {
        for position in 0...9 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: String(position))
        }
        
        // inputed string = $1,234,567.89, deleting location at 4 = "3"
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: 4, length: 1), replacementString: "")
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "124,567.89", "deleting digits should keep formating and count as expected")
    }

    func testSelectingAndDeletingAll() {
        for position in 0...9 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: String(position))
        }

        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: textField.textLength), replacementString: "")

        XCTAssertNotNil(textField)
        if let text = textField.text {
            XCTAssertEqual(text.count, 0)
        }
    }

    // MARK: input/paste
    func testFormatAfterFirstNumber() {
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "1")

        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "0.01", "after first input the text should be correctly formated")
    }
    
    private func sendTextFieldChanges(at range: NSRange, inputString: String) {
        delegate.textField(textField, shouldChangeCharactersIn: range, replacementString: inputString)
    }

    func testPastingNonNumeralValues() {
        //without content
        sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: ",,,,")

        XCTAssertEqual(textField.text, "")

        //middle of the string - at location 4 = "5"
        textField.text = numberFormatter.currencySymbol + "3,456.45"
        sendTextFieldChanges(at: NSRange(location: 4, length: 4), inputString: ",,,,")

        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "3,456.45")

        //end of the string
        sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 4), inputString: ",,,,")
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "3,456.45")
    }

    func testInputingNotAtEndIndex() {
        for position in 0...9 {
            sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: String(position))
        }

        // expected string = "$1,234,567.89". input at location 3 = "2"
        sendTextFieldChanges(at: NSRange(location: 3, length: 2), inputString: "15")

        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "1,154,567.89", "deleting digits should keep formating and count as expected")
    }
    
    func testInputingNotAtEndIndexSurpassingIntegersLimit() {
        // value should be adjusted overlapping digits to the right once a the range had a comma that was changed by a new number. So this numbers gets the next space at right and so on with the next numbers, until the last decimal digit is overlapped
        for position in 0...9 {
            sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: String(position))
        }
        
        // expected string = "$1,234,567.89". input at location 5 = "4"
        sendTextFieldChanges(at: NSRange(location: 5, length: 3), inputString: "150")
        
        XCTAssertEqual(textField.text, numberFormatter.currencySymbol + "1,231,506.78", "deleting digits should keep formating and count as expected")
    }

    // MARK: End of editing
    func testAutoclear() {
//        delegate.hasAutoclear = true

        for _ in 0...2 {
            sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: "0")
        }

        delegate.textFieldShouldEndEditing(textField)
        XCTAssertTrue(textField.textLength == 0, "Text field text count should be zero because hasAutoclear is enabled")


//        delegate.hasAutoclear = false
        for _ in 0...2 {
            sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: "0")
        }

        delegate.textFieldShouldEndEditing(textField)
        XCTAssertFalse(textField.textLength == 0, "Text field text count should not be zero when autoclear is disabled")
    }

    // MARK: Cursor
    func testSelectedTextRange() {
        sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: "3")

        XCTAssertEqual(textField.selectedTextRange, textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument), "After first input selected range should be endOfDocument")
        
        textField.text = "3523623623"
        textField.selectedTextRange = textField.textRange(from: textField.position(from: textField.endOfDocument, offset: -5)!, to: textField.position(from: textField.endOfDocument, offset: -5)!)
        
        sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: "3")
        XCTAssertEqual(textField.selectedTextRangeOffsetFromEnd, -5, "Selected text range offset from end should not change after inputs")
    }
}
