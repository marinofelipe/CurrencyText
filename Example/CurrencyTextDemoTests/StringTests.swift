//
//  String.swift
//  GroceryListTests
//
//  Created by Felipe Lefèvre Marino on 4/5/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import CurrencyText

class StringTests: XCTestCase {
    
    func testNumeralFormat() {
        let nonNumeralString = "*235&Q@6634(355$Q9_-$0_Q8$*64_!@1:'/.,.a"
        XCTAssertEqual(nonNumeralString.numeralFormat(), "2356634355908641", "numeralFormat() should restrict string to only numerals")
    }
    
    func testAddingDecimalSeparator() {
        var text = "14349"
        text.addDecimalSeparator()
        XCTAssertEqual(text, "143.49", "Text format should be 143.49")
        
        text = "349"
        text.addDecimalSeparator()
        XCTAssertEqual(text, "3.49", "Text format should be 3.49")
        
        text = "99"
        text.addDecimalSeparator()
        XCTAssertEqual(text, ".99", "Text format should be .99")
        
        text = "9"
        text.addDecimalSeparator()
        XCTAssertEqual(text, "9", "When there aren't enough characters the text should stay the same")
    }
    
    func testRepresentsZero() {
        var currencyValue = "R$ 34.00"
        
        XCTAssertFalse(currencyValue.isZero, "value \(currencyValue) should not represent zero")
        
        currencyValue = "00,34"
        XCTAssertFalse(currencyValue.isZero, "value \(currencyValue) should not represent zero")
        
        currencyValue = "0.000,00"
        XCTAssertTrue(currencyValue.isZero, "value \(currencyValue) should represent zero")
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
