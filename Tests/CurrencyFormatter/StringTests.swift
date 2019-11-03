//
//  String.swift
//  GroceryListTests
//
//  Created by Felipe Lefèvre Marino on 4/5/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import CurrencyFormatter

class StringTests: XCTestCase {
    
    func testNumeralFormat() {
        let nonNumeralString = "*235&Q@6634(355$Q9_-$0_Q8$*64_!@1:'/.,.a"
        XCTAssertEqual(nonNumeralString.numeralFormat(), "2356634355908641", "numeralFormat() should restrict string to only numerals")
    }
    
    func testAddingDecimalSeparator() {
        var text = "14349"
        text.updateDecimalSeparator(decimalDigits: 2)
        XCTAssertEqual(text, "143.49", "Text format should be 143.49")
        
        text = "349"
        text.updateDecimalSeparator(decimalDigits: 1)
        XCTAssertEqual(text, "34.9", "Text format should be 34.9")
        
        text = "99"
        text.updateDecimalSeparator(decimalDigits: 0)
        XCTAssertEqual(text, "99", "Text format should be 99")
        
        text = "9"
        text.updateDecimalSeparator(decimalDigits: 2)
        XCTAssertEqual(text, "9", "When there aren't enough characters the text should stay the same")
        
        text = "9"
        text.updateDecimalSeparator(decimalDigits: 1)
        XCTAssertEqual(text, ".9", "When there aren't enough characters the text should stay the same")
    }
    
    func testRepresentsZero() {
        var currencyValue = "R$ 34.00"
        
        XCTAssertFalse(currencyValue.representsZero, "value \(currencyValue) should not represent zero")
        
        currencyValue = "00,34"
        XCTAssertFalse(currencyValue.representsZero, "value \(currencyValue) should not represent zero")
        
        currencyValue = "0.000,00"
        XCTAssertTrue(currencyValue.representsZero, "value \(currencyValue) should represent zero")
    }
    
    func testHasNumbers() {
        var string = "R$"
        XCTAssertFalse(string.hasNumbers)
        
        string = ","
        XCTAssertFalse(string.hasNumbers)
        
        string = "#$a"
        XCTAssertFalse(string.hasNumbers)
        
        string = "34164"
        XCTAssertTrue(string.hasNumbers)
        
        string = "sa12"
        XCTAssertTrue(string.hasNumbers)
    }
}

// MARK: All Tests
extension StringTests {
    static var allTests = {
        return [
            ("testNumeralFormat", testNumeralFormat),
            ("testAddingDecimalSeparator", testAddingDecimalSeparator),
            ("testRepresentsZero", testRepresentsZero),
            ("testHasNumbers", testHasNumbers),
        ]
    }
}
