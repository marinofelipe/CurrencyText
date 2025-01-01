//
//  CurrencyTextFieldConfigurationTests.swift
//  
//
//  Created by Marino Felipe on 24.04.21.
//

import SwiftUI
import XCTest

import CurrencyFormatter
import CurrencyTextFieldTestSupport

@testable import CurrencyTextField

@available(iOS 13.0, *)
@MainActor
final class CurrencyTextFieldConfigurationTests: XCTestCase {
    func testMakeDefault() {
        let textBinding = Binding<String>(
            get: { "" },
            set: { _ in }
        )
        let hasFocusBinding = Binding<Bool?>(
            get: { false },
            set: { _ in }
        )
        let formatter = CurrencyFormatter()
        let sut = CurrencyTextFieldConfiguration.makeDefault(
            text: textBinding,
            hasFocus: hasFocusBinding,
            formatter: .init(
                get: { formatter },
                set: { _ in }
            )
        )

        XCTAssertEqual(sut.placeholder, "")
        XCTAssertEqual(sut.text, "")
        XCTAssertEqual(sut.hasFocus?.wrappedValue, false)
        XCTAssertTrue(sut.formatter === formatter)
        XCTAssertFalse(sut.clearsWhenValueIsZero)
        XCTAssertNil(sut.unformattedText)
        XCTAssertNil(sut.inputAmount)
        XCTAssertNil(sut.textFieldConfiguration)
        XCTAssertNil(sut.onEditingChanged)
        XCTAssertNil(sut.onCommit)
    }

    func testInit() {
        let formatter = CurrencyFormatter()
        let sut = CurrencyTextFieldConfiguration.makeFixture(
            formatter: .init(
                get: { formatter },
                set: { _ in }
            )
        )

        XCTAssertEqual(sut.placeholder, "some")
        XCTAssertEqual(sut.text, "text")
        XCTAssertEqual(sut.unformattedText?.wrappedValue, "unformatted")
        XCTAssertEqual(sut.inputAmount?.wrappedValue, .zero)
        XCTAssertEqual(sut.hasFocus?.wrappedValue, true)
        XCTAssertTrue(sut.formatter === formatter)
        XCTAssertTrue(sut.clearsWhenValueIsZero)
        XCTAssertNotNil(sut.textFieldConfiguration)
        XCTAssertNotNil(sut.onEditingChanged)
        XCTAssertNotNil(sut.onCommit)
    }

    func testText() {
        var textSetCalls: [String] = []
        var textValue = ""
        let textBinding = Binding<String>(
            get: { textValue },
            set: { value in textSetCalls.append(value) }
        )

        let sut = CurrencyTextFieldConfiguration.makeFixture(textBinding: textBinding)

        sut.text = "val"
        sut.text = "anotherVal"

        XCTAssertEqual(textSetCalls, ["val", "anotherVal"])

        textValue = "new"
        XCTAssertEqual(sut.text, "new")
    }

    func testUnformattedText() {
        var unformattedText = "unformatted"
        let unformattedTextBinding = Binding<String?>(
            get: { unformattedText },
            set: { _ in }
        )

        let sut = CurrencyTextFieldConfiguration.makeFixture(
            unformattedTextBinding: unformattedTextBinding
        )

        XCTAssertEqual(sut.unformattedText?.wrappedValue, "unformatted")

        unformattedText = "newValue"

        XCTAssertEqual(sut.unformattedText?.wrappedValue, "newValue")
    }

    func testInputAmount() {
        var inputAmount: Double? = .zero
        let inputAmountBinding = Binding<Double?>(
            get: { inputAmount },
            set: { _ in }
        )

        let sut = CurrencyTextFieldConfiguration.makeFixture(
            inputAmountBinding: inputAmountBinding
        )

        XCTAssertEqual(sut.inputAmount?.wrappedValue, .zero)

        inputAmount = nil

        XCTAssertNil(sut.inputAmount?.wrappedValue)
    }

    func testHasFocus() {
        var hasFocus: Bool? = true
        let hasFocusBinding = Binding<Bool?>(
            get: { hasFocus },
            set: { _ in }
        )

        let sut = CurrencyTextFieldConfiguration.makeFixture(
            hasFocusBinding: hasFocusBinding
        )

        XCTAssertEqual(sut.hasFocus?.wrappedValue, true)

        hasFocus = false

        XCTAssertEqual(sut.hasFocus?.wrappedValue, false)
    }

    func testTextFieldConfiguration() {
        var textFieldConfigurationReceivedValues: [UITextField] = []
        let textFieldConfiguration: ((UITextField) -> Void)? = { textField in
            textFieldConfigurationReceivedValues.append(textField)
        }

        let sut = CurrencyTextFieldConfiguration.makeFixture(
            textFieldConfiguration: textFieldConfiguration
        )

        let textField = UITextField()
        sut.textFieldConfiguration?(textField)

        XCTAssertEqual(textFieldConfigurationReceivedValues, [textField])
    }

    func testOnEditingChanged() {
        var onEditingChangedReceivedValues: [Bool] = []
        let onEditingChanged: ((Bool) -> Void)? = { isEditing in
            onEditingChangedReceivedValues.append(isEditing)
        }

        let sut = CurrencyTextFieldConfiguration.makeFixture(
            onEditingChanged: onEditingChanged
        )

        sut.onEditingChanged?(true)
        sut.onEditingChanged?(false)
        sut.onEditingChanged?(true)

        XCTAssertEqual(
            onEditingChangedReceivedValues,
            [true, false, true]
        )
    }

    func testOnCommit() {
        var onCommitCallsCount = 0
        let onCommit: (() -> Void)? = {
            onCommitCallsCount += 1
        }

        let sut = CurrencyTextFieldConfiguration.makeFixture(
            onCommit: onCommit
        )

        sut.onCommit?()
        sut.onCommit?()

        XCTAssertEqual(onCommitCallsCount, 2)
    }
}
