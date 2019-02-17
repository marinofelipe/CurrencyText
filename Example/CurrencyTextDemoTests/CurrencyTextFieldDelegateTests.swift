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
    var formatter: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        textField = UITextField()

        formatter = CurrencyFormatter {
            $0.currency = .dollar
            $0.locale = CurrencyLocale.englishUnitedStates
            $0.hasDecimals = true
        }
        
        delegate = CurrencyUITextFieldDelegate(formatter: formatter)
        delegate.clearsWhenValueIsZero = true
        
        textField.delegate = delegate
        textField.keyboardType = .numberPad
    }
    
    override func tearDown() {
        textField = nil
        delegate = nil
        formatter = nil
        super.tearDown()
    }
    
    func testInit() {
        XCTAssertNotNil(delegate.formatter, "formatter should not be nil")
        
        delegate = CurrencyUITextFieldDelegate()
        XCTAssertNotNil(delegate.formatter, "formatter should not be nil")
    }
    
    // MARK: max digits
    func testMaxDigitsCount() {
        formatter.maxIntegers = 5
        
        for _ in 0...20 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "1")
        }

        if let onlyDigitsText = textField.text?.numeralFormat() {
            XCTAssertEqual(onlyDigitsText.count, formatter.maxDigitsCount, "text count should not be more than maxDigitsCount")
        }
    }

    // MARK: Deletion
    func testDeleting() {
        // simulates keyboard actions - expected to set textField text to "$11,111,111.11"
        for _ in 0...9 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "1")
        }

        textField.sendDeleteKeyboardAction()
        textField.sendDeleteKeyboardAction()

        XCTAssertEqual(textField.text, formatter.currencySymbol + "111,111.11", "deleting digits should keep formating and count as expected")

        // removing beyond decimal separator
        textField.text = "$0.19"

        textField.sendDeleteKeyboardAction()

        XCTAssertEqual(textField.text, formatter.currencySymbol + "0.01", "deleting digits should keep formating and count as expected")

        textField.sendDeleteKeyboardAction()
        XCTAssertEqual(textField.text, formatter.currencySymbol + "0.00", "deleting digits should keep formating and count as expected")
    }

    func testDeletingNotAtEndIndex() {
        for position in 0...9 {
            delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: String(position))
        }

        // inputed string = $1,234,567.89, deleting location at 4 = "3"
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: 4, length: 1), replacementString: "")
        XCTAssertEqual(textField.text, formatter.currencySymbol + "124,567.89", "deleting digits should keep formating and count as expected")
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
    
    func testAddingNegativeSymbol() {
        // testing with numeric pad
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: .negativeSymbol)
        
        XCTAssertEqual(textField.text, "", "after first input the text should be correctly formated")
        
        // testing with numbersAndPunctuation pad
        textField.keyboardType = .numbersAndPunctuation
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: .negativeSymbol)
        XCTAssertEqual(textField.text, .negativeSymbol, "after first input the text should be correctly formated")
        
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "3451")
        XCTAssertEqual(textField.text, .negativeSymbol + formatter.currencySymbol + "34.51")
        
        //delete negative symbol
        textField.sendDeleteKeyboardAction(at: 0)
        XCTAssertEqual(textField.text, formatter.currencySymbol + "34.51")
        
        //try to add negative symbol to non negative value
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 0), replacementString: .negativeSymbol)
        XCTAssertEqual(textField.text, .negativeSymbol + formatter.currencySymbol + "34.51")
        
        // add negative symbol with range selected - should be added when range contains first index
        textField.sendDeleteKeyboardAction(at: 0)
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: 0, length: 3), replacementString: .negativeSymbol)
        XCTAssertEqual(textField.text, .negativeSymbol + formatter.currencySymbol + "34.51")
        
        // add negative symbol with range selected - should not be added when range does contains first index
        textField.sendDeleteKeyboardAction(at: 0)
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: 1, length: 2), replacementString: .negativeSymbol)
        XCTAssertEqual(textField.text, formatter.currencySymbol + "34.51")
    }
    
    func testFormatAfterFirstNumber() {
        delegate.textField(textField, shouldChangeCharactersIn: NSRange(location: textField.textLength, length: 0), replacementString: "1")

        XCTAssertEqual(textField.text, formatter.currencySymbol + "0.01", "after first input the text should be correctly formated")
    }

    private func sendTextFieldChanges(at range: NSRange, inputString: String) {
        delegate.textField(textField, shouldChangeCharactersIn: range, replacementString: inputString)
    }

    func testPastingNonNumeralValues() {
        //without content
        sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: ",,,,")

        XCTAssertEqual(textField.text, "")

        //middle of the string - at location 4 = "5"
        textField.text = formatter.currencySymbol + "3,456.45"
        sendTextFieldChanges(at: NSRange(location: 4, length: 4), inputString: ",,,,")

        XCTAssertEqual(textField.text, formatter.currencySymbol + "3,456.45")

        //end of the string
        sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 4), inputString: ",,,,")
        XCTAssertEqual(textField.text, formatter.currencySymbol + "3,456.45")
    }

    func testInputingNotAtEndIndex() {
        for position in 0...9 {
            sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: String(position))
        }

        // expected string = "$1,234,567.89". input at location 3 = "2"
        sendTextFieldChanges(at: NSRange(location: 3, length: 2), inputString: "15")

        XCTAssertEqual(textField.text, formatter.currencySymbol + "1,154,567.89", "deleting digits should keep formating and count as expected")
    }

    func testInputingNotAtEndIndexSurpassingIntegersLimit() {
        formatter.maxIntegers = 7
        
        // value should be adjusted overlapping digits to the right once a the range had a comma that was changed by a new number. So this numbers gets the next space at right and so on with the next numbers, until the last decimal digit is overlapped
        for position in 0...9 {
            sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: String(position))
        }

        // expected string = "$1,234,567.89". input at location 5 = "4"
        sendTextFieldChanges(at: NSRange(location: 5, length: 3), inputString: "150")

        XCTAssertEqual(textField.text, formatter.currencySymbol + "1,231,506.78", "deleting digits should keep formating and count as expected")
    }

    // MARK: End of editing
    func testClearsWhenValueIsZero() {
        delegate.clearsWhenValueIsZero = true

        for _ in 0...2 {
            sendTextFieldChanges(at: NSRange(location: textField.textLength, length: 0), inputString: "0")
        }

        delegate.textFieldShouldEndEditing(textField)
        XCTAssertTrue(textField.textLength == 0, "Text field text count should be zero because hasAutoclear is enabled")


        delegate.clearsWhenValueIsZero = false
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
