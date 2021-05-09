//
//  WrappedTextFieldTests.swift
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
final class WrappedTextFieldTests: XCTestCase {
    private var sut: WrappedTextField!
    private var formatter: CurrencyFormatter!

    // MARK: - Accessors

    private var textSetValues: [String]!
    private var unformattedTextSetValues: [String?]!
    private var inputAmountSetValues: [Double?]!
    private var textFieldConfigurationReceivedValues: [UITextField]!
    private var onEditingChangedReceivedValues: [Bool]!
    private var onCommitCallsCount: Int!

    // MARK: - Life cycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        textSetValues = []
        unformattedTextSetValues = []
        inputAmountSetValues = []
        textFieldConfigurationReceivedValues = []
        onEditingChangedReceivedValues = []
        onCommitCallsCount = 0
        formatter = .init()
        assembleSut()
    }

    override func tearDownWithError() throws {
        textSetValues = nil
        unformattedTextSetValues = nil
        inputAmountSetValues = nil
        textFieldConfigurationReceivedValues = nil
        onEditingChangedReceivedValues = nil
        onCommitCallsCount = nil
        formatter = nil
        sut = nil

        try super.tearDownWithError()
    }

    private func assembleSut(text: String = "34") {
        sut = WrappedTextField(
            configuration: .makeFixture(
                textBinding: Binding<String>(
                    get: { text },
                    set: { text in
                        self.textSetValues.append(text)
                    }
                ),
                unformattedTextBinding: Binding<String?>(
                    get: { "unformatted" },
                    set: { text in
                        self.unformattedTextSetValues.append(text)
                    }
                ),
                inputAmountBinding: Binding<Double?>(
                    get: { .zero },
                    set: { value in
                        self.inputAmountSetValues.append(value)
                    }
                ),
                formatter: formatter,
                textFieldConfiguration: { textField in
                    self.textFieldConfigurationReceivedValues.append(textField)
                },
                onEditingChanged: { isEditing in
                    self.onEditingChangedReceivedValues.append(isEditing)
                },
                onCommit: {
                    self.onCommitCallsCount += 1
                }
            )
        )
    }

    // MARK: - Tests

    func testDelegate() {
        XCTAssertNotNil(sut.delegate)
    }

    func testInitialTextWhenValueIsInvalid() {
        assembleSut(text: "some")

        XCTAssertEqual(sut.text?.isEmpty, true)
    }

    func testInitialTextWhenValueIsValid() {
        XCTAssertEqual(sut.text, "$0.34")
    }

    func testShouldChangeCharactersInRange() {
        _ = sut.delegate?.textField?(
            sut,
            shouldChangeCharactersIn: NSRange(location: 5, length: 1),
            replacementString: "3"
        )

        XCTAssertEqual(
            textSetValues,
            [
                "$0.34",
                "$3.43"
            ]
        )
        XCTAssertEqual(
            unformattedTextSetValues,
            [
                "0.34",
                "3.43"
            ]
        )
        XCTAssertEqual(
            inputAmountSetValues,
            [
                0.34,
                3.43
            ]
        )
        XCTAssertTrue(textFieldConfigurationReceivedValues.isEmpty)
        XCTAssertTrue(onEditingChangedReceivedValues.isEmpty)
        XCTAssertEqual(onCommitCallsCount, 0)
    }

    func testTextFieldDidBeginEditing() {
        sut.becomeFirstResponder()
        _ = sut.delegate?.textFieldDidBeginEditing?(sut)

        XCTAssertEqual(textSetValues.count, 1)
        XCTAssertEqual(unformattedTextSetValues.count, 1)
        XCTAssertEqual(inputAmountSetValues.count, 1)
        XCTAssertTrue(textFieldConfigurationReceivedValues.isEmpty)
        XCTAssertEqual(onEditingChangedReceivedValues, [true])
        XCTAssertEqual(onCommitCallsCount, 0)
        XCTAssertFalse(sut.isFirstResponder)
    }

    func testTextFieldDidEndEditing() {
        sut.becomeFirstResponder()
        _ = sut.delegate?.textFieldDidEndEditing?(sut)

        XCTAssertEqual(textSetValues.count, 1)
        XCTAssertEqual(unformattedTextSetValues.count, 1)
        XCTAssertEqual(inputAmountSetValues.count, 1)
        XCTAssertTrue(textFieldConfigurationReceivedValues.isEmpty)
        XCTAssertEqual(onEditingChangedReceivedValues, [false])
        XCTAssertEqual(onCommitCallsCount, 0)
        XCTAssertFalse(sut.isFirstResponder)
    }

    func testTextFieldShouldReturn() {
        sut.becomeFirstResponder()
        let shouldReturn = sut.delegate?.textFieldShouldReturn?(sut)

        XCTAssertEqual(shouldReturn, true)
        XCTAssertEqual(textSetValues.count, 1)
        XCTAssertEqual(unformattedTextSetValues.count, 1)
        XCTAssertEqual(inputAmountSetValues.count, 1)
        XCTAssertTrue(textFieldConfigurationReceivedValues.isEmpty)
        XCTAssertTrue(onEditingChangedReceivedValues.isEmpty)
        XCTAssertEqual(onCommitCallsCount, 1)
        XCTAssertFalse(sut.isFirstResponder)
    }

    func testUpdateConfigurationAndUpdateTextIfNeeded() {
        formatter.hasDecimals = false
        sut.updateConfigurationIfNeeded(
            latest: .makeFixture(
                textBinding: Binding<String>(
                    get: { "56" },
                    set: { text in
                        self.textSetValues.append(text)
                    }
                ),
                unformattedTextBinding: Binding<String?>(
                    get: { "unformatted" },
                    set: { text in
                        self.unformattedTextSetValues.append(text)
                    }
                ),
                inputAmountBinding: Binding<Double?>(
                    get: { .zero },
                    set: { value in
                        self.inputAmountSetValues.append(value)
                    }
                ),
                formatter: formatter
            )
        )

        sut.updateTextIfNeeded()

        XCTAssertEqual(
            textSetValues,
            [
                "$0.34",
                "$56"
            ]
        )
        XCTAssertEqual(
            unformattedTextSetValues,
            [
                "0.34",
                "56"
            ]
        )
        XCTAssertEqual(
            inputAmountSetValues,
            [
                0.34,
                56.0
            ]
        )
        XCTAssertTrue(textFieldConfigurationReceivedValues.isEmpty)
        XCTAssertTrue(onEditingChangedReceivedValues.isEmpty)
        XCTAssertEqual(onCommitCallsCount, 0)
    }
}
