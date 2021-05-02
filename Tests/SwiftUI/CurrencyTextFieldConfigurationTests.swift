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
final class CurrencyTextFieldConfigurationTests: XCTestCase {
    func testMakeDefault() {
        let textBinding = Binding<String>(
            get: { "" },
            set: { _ in }
        )
        let formatter = CurrencyFormatter()
        let sut = CurrencyTextFieldConfiguration.makeDefault(
            text: textBinding,
            formatter: formatter
        )

        XCTAssertEqual(sut.placeholder, "")
        XCTAssertEqual(sut.text, "")
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
        let sut = CurrencyTextFieldConfiguration.makeFixture(formatter: formatter)

        XCTAssertEqual(sut.placeholder, "some")
        XCTAssertEqual(sut.text, "text")
        XCTAssertEqual(sut.unformattedText?.wrappedValue, "unformatted")
        XCTAssertEqual(sut.inputAmount?.wrappedValue, .zero)
        XCTAssertTrue(sut.formatter === formatter)
        XCTAssertTrue(sut.clearsWhenValueIsZero)
        XCTAssertNotNil(sut.textFieldConfiguration)
        XCTAssertNotNil(sut.onEditingChanged)
        XCTAssertNotNil(sut.onCommit)
    }
}
