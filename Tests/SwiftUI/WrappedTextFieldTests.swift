//
//  WrappedTextFieldTests.swift
//
//
//  Created by Marino Felipe on 24.04.21.
//

import SwiftUI
import XCTest

import CurrencyFormatter

@testable import CurrencyTextField

@available(iOS 13.0, *)
final class WrappedTextFieldTests: XCTestCase {
    private var sut: WrappedTextField!
    private var formatter: CurrencyFormatter!

    // MARK: - Accessors

    private var textSetValues: [String]!
    private var unformattedTextSetValues: [String?]!
    private var inputAmountSetValues: [Double?]!
    private var underlyingTextFieldConfigurationReceivedValues: [UITextField]!
    private var onEditingChangedReceivedValues: [Bool]!
    private var onCommitCallsCount: Int!

    // MARK: - Life cycle

    override func setUpWithError() throws {
        try super.setUpWithError()

        textSetValues = []
        unformattedTextSetValues = []
        inputAmountSetValues = []
        underlyingTextFieldConfigurationReceivedValues = []
        onEditingChangedReceivedValues = []
        onCommitCallsCount = 0
        formatter = .init()
        assembleSut()
    }

    override func tearDownWithError() throws {
        textSetValues = nil
        unformattedTextSetValues = nil
        inputAmountSetValues = nil
        underlyingTextFieldConfigurationReceivedValues = nil
        onEditingChangedReceivedValues = nil
        onCommitCallsCount = nil
        formatter = nil
        sut = nil

        try super.tearDownWithError()
    }

    private func assembleSut() {
        sut = WrappedTextField(
            configuration: .makeFixture(
                textBinding: Binding<String>(
                    get: { "" },
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
                underlyingTextFieldConfiguration: { textField in
                    self.underlyingTextFieldConfigurationReceivedValues.append(textField)
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

    func testInit() {
        XCTAssertNotNil(sut.delegate)
    }

    func testShouldChangeCharactersInRange() {
        _ = sut.delegate?.textField?(
            sut,
            shouldChangeCharactersIn: NSRange(location: 0, length: 1),
            replacementString: "3"
        )

        XCTAssertEqual(textSetValues, ["$0.03"])
        XCTAssertEqual(unformattedTextSetValues, ["0.03"])
        XCTAssertEqual(inputAmountSetValues, [0.03])
        XCTAssertTrue(underlyingTextFieldConfigurationReceivedValues.isEmpty)
        XCTAssertTrue(onEditingChangedReceivedValues.isEmpty)
        XCTAssertEqual(onCommitCallsCount, 0)
    }

    func testTextFieldDidBeginEditing() {
        sut.becomeFirstResponder()
        _ = sut.delegate?.textFieldDidBeginEditing?(sut)

        XCTAssertTrue(textSetValues.isEmpty)
        XCTAssertTrue(unformattedTextSetValues.isEmpty)
        XCTAssertTrue(inputAmountSetValues.isEmpty)
        XCTAssertTrue(underlyingTextFieldConfigurationReceivedValues.isEmpty)
        XCTAssertEqual(onEditingChangedReceivedValues, [true])
        XCTAssertEqual(onCommitCallsCount, 0)
        XCTAssertFalse(sut.isFirstResponder)
    }

    func testTextFieldDidEndEditing() {
        sut.becomeFirstResponder()
        _ = sut.delegate?.textFieldDidEndEditing?(sut)

        XCTAssertTrue(textSetValues.isEmpty)
        XCTAssertTrue(unformattedTextSetValues.isEmpty)
        XCTAssertTrue(inputAmountSetValues.isEmpty)
        XCTAssertTrue(underlyingTextFieldConfigurationReceivedValues.isEmpty)
        XCTAssertEqual(onEditingChangedReceivedValues, [false])
        XCTAssertEqual(onCommitCallsCount, 0)
        XCTAssertFalse(sut.isFirstResponder)
    }

    func testTextFieldShouldReturn() {
        sut.becomeFirstResponder()
        let shouldReturn = sut.delegate?.textFieldShouldReturn?(sut)

        XCTAssertEqual(shouldReturn, true)
        XCTAssertTrue(textSetValues.isEmpty)
        XCTAssertTrue(unformattedTextSetValues.isEmpty)
        XCTAssertTrue(inputAmountSetValues.isEmpty)
        XCTAssertTrue(underlyingTextFieldConfigurationReceivedValues.isEmpty)
        XCTAssertTrue(onEditingChangedReceivedValues.isEmpty)
        XCTAssertEqual(onCommitCallsCount, 1)
        XCTAssertFalse(sut.isFirstResponder)
    }
}
