//
//  CurrencyFormatterTests.swift
//  CurrencyTextDemoTests
//
//  Created by Felipe Lefèvre Marino on 2/11/19.
//  Copyright © 2019 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import CurrencyText

class CurrencyFormatterTests: XCTestCase {
    
    var formatter: CurrencyFormatter!

    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    func testComposing() {
        formatter = CurrencyFormatter {
            $0.locale = CurrencyLocale.italian
            $0.hasDecimals = false
        }
        
        XCTAssert(formatter.decimalDigits == 0)
        XCTAssert(formatter.hasDecimals == false)
        XCTAssert(formatter.locale.locale == CurrencyLocale.italian.locale)
    }
    
    func testFormatting() {
        formatter.locale = CurrencyLocale.portugueseBrazil
        formatter.currency = .euro
        formatter.hasDecimals = true
        
        let formattedString = formatter.string(from: 300000.54)
        XCTAssertEqual(formattedString, "€ 300.000,54")
        
        let unformattedString = formatter.unformatted(string: formattedString!)
        XCTAssertEqual(unformattedString, "30000054")
        
        let doubleValue = formatter.double(from: "30000054")
        XCTAssertEqual(doubleValue, 30000054.00)
    }
}
