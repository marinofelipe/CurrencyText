//
//  XCTest.swift
//  Tests
//
//  Created by Marino Felipe on 04.08.19.
//

import XCTest

#if !canImport(ObjectiveC)
extension XCTest {
    static var allTests: [XCTestCaseEntry] {
        var tests = [XCTestCaseEntry]()
        tests += CurrencyFormatterTests.allTests
        tests += CurrencyTextFieldDelegateTests.allTests
        tests += NumberFormatterTests.allTests
        tests += StringTests.allTests
        tests += UITextFieldTests.allTests
        return tests
    }
}
#endif
