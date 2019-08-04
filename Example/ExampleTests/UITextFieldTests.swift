//
//  UITextFieldTests.swift
//  ExampleTests
//
//  Created by Felipe Lefèvre Marino on 12/27/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest

final class UITextFieldTests: XCTestCase {

    // System under test.
    let textField = UITextField()

    // MARK: - selectedTextRangeOffsetFromEnd

    func testOffsetFromEndWhenSelectedTextRangeIsAtTheEnd() {
        setTextFieldWithNumericText()

        // Set selected text range to the end
        textField.selectedTextRange = textField.textRange(from: textField.endOfDocument,
                                                          to: textField.endOfDocument)

        // Then
        XCTAssertEqual(textField.selectedTextRangeOffsetFromEnd, 0, "It has no offset from end")
    }

    func testOffsetFromEndWhenSelectedTextRangeIsNotAtTheEnd() throws {
        setTextFieldWithNumericText()

        // Set selected text range to a text position that is not at the end
        let offset = -4
        let textPosition = try XCTUnwrap(textField.position(from: textField.endOfDocument, offset: offset))
        textField.selectedTextRange = textField.textRange(from: textPosition,
                                                          to: textPosition)

        // Then
        XCTAssertEqual(textField.selectedTextRangeOffsetFromEnd, offset, "It has the correct offset from end")

    }

    // MARK: - Initial selected text range

    func testSettingInitialSelectedTextRangeWithLastNumberAtTheNEnd() {
        setTextFieldWithNumericText()

        // Set initial selected text range
        textField.setInitialSelectedTextRange()

        // Then
        XCTAssertEqual(textField.selectedTextRange,
                       textField.textRange(from: textField.endOfDocument,
                                           to: textField.endOfDocument),
                       "It has the selected text range at the end")
    }

    func testSettingInitialSelectedTextRangeWithLastNumberNotAtTheNEnd() throws {
        setTextFieldWithCurrencySymbolAtTheEnd()

        // Set initial selected text range
        textField.setInitialSelectedTextRange()

        // Then
        let lastNumberTextPosition = try XCTUnwrap(textField.position(from: textField.endOfDocument, offset: -2))
        XCTAssertEqual(textField.selectedTextRange,
                       textField.textRange(from: lastNumberTextPosition,
                                           to: lastNumberTextPosition),
                       "It has the correct selected text range")
    }

    // MARK: - Update selected text range

    func testUpdatingSelectedTextRangeWithoutOffsetFromEnd() {
        setTextFieldWithNumericText()

        // Call update selected text range with no offset
        textField.updateSelectedTextRange(lastOffsetFromEnd: 0)

        // Then
        XCTAssertEqual(textField.selectedTextRange,
                       textField.textRange(from: textField.endOfDocument,
                                           to: textField.endOfDocument),
                       "It has the correct selected text range")
    }

    func testUpdatingSelectedTextRangeWithoutOffsetFromEndButLastNumberNotAtTheEnd() throws {
        setTextFieldWithCurrencySymbolAtTheEnd()

        // Call update selected text range with no offset
        textField.updateSelectedTextRange(lastOffsetFromEnd: 0)

        // Then
        let lastNumberTextPosition = try XCTUnwrap(textField.position(from: textField.endOfDocument, offset: -2))
        XCTAssertEqual(textField.selectedTextRange,
                       textField.textRange(from: lastNumberTextPosition,
                                           to: lastNumberTextPosition),
                       "It has the correct selected text range")
    }

    func testUpdatingSelectedTextRangeWithOffsetFromEndAndBeforeLastNumber() throws {
        setTextFieldWithCurrencySymbolAtTheEnd()

        // Call update selected text range with offset before last number
        let offset = -6
        textField.updateSelectedTextRange(lastOffsetFromEnd: offset)

        // Then
        let textPositionForGivenOffset = try XCTUnwrap(textField.position(from: textField.endOfDocument, offset: offset))
        XCTAssertEqual(textField.selectedTextRange,
                       textField.textRange(from: textPositionForGivenOffset,
                                           to: textPositionForGivenOffset),
                       "It has the correct selected text range")
    }

    func testUpdatingSelectedTextRangeWithOffsetFromEndButAfterLastNumber() throws {
        setTextFieldWithCurrencySymbolAtTheEnd()

        // Call update selected text range with offset before last number
        let offset = -1
        textField.updateSelectedTextRange(lastOffsetFromEnd: offset)

        // Then
        let lastNumberTextPosition = try XCTUnwrap(textField.position(from: textField.endOfDocument, offset: -2))
        XCTAssertEqual(textField.selectedTextRange,
                       textField.textRange(from: lastNumberTextPosition,
                                           to: lastNumberTextPosition),
                       "It has the correct selected text range")
    }
}

// MARK: - Helpers

extension UITextFieldTests {

    func setTextFieldWithNumericText() {
        textField.text = "352450260"
    }

    func setTextFieldWithCurrencySymbolAtTheEnd() {
        textField.text = "3.524,50 $"
    }
}
