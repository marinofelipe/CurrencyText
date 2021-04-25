//
//  CurrencyFormatterTests.swift
//  ExampleTests
//
//  Created by Felipe Lefèvre Marino on 2/11/19.
//  Copyright © 2019 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import CurrencyFormatter

class CurrencyFormatterTests: XCTestCase {
    
    var formatter: CurrencyFormatter!

    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
        formatter.locale = CurrencyLocale.englishIreland
        formatter.currency = .euro
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    func testComposing() {
        formatter = CurrencyFormatter {
            $0.locale = CurrencyLocale.italianItaly
            $0.currency = .euro
            $0.hasDecimals = false
        }
        
        XCTAssertEqual(formatter.decimalDigits, 0)
        XCTAssertEqual(formatter.hasDecimals, false)
        XCTAssertEqual(formatter.locale.locale, CurrencyLocale.italianItaly.locale)
        XCTAssertEqual(formatter.currencySymbol, "€")
        
        formatter.decimalSeparator = ";"
        XCTAssertEqual(formatter.numberFormatter.currencyDecimalSeparator, ";")
        
        formatter.currencyCode = "^"
        XCTAssertEqual(formatter.numberFormatter.currencyCode, "^")
        
        formatter.alwaysShowsDecimalSeparator = true
        XCTAssertEqual(formatter.numberFormatter.alwaysShowsDecimalSeparator, true)
        
        formatter.groupingSize = 4
        XCTAssertEqual(formatter.numberFormatter.groupingSize, 4)
        
        formatter.secondaryGroupingSize = 1
        XCTAssertEqual(formatter.numberFormatter.secondaryGroupingSize, 1)
        
        formatter.groupingSeparator = "-"
        XCTAssertEqual(formatter.numberFormatter.currencyGroupingSeparator, "-")
        
        formatter.hasGroupingSeparator = false
        XCTAssertEqual(formatter.numberFormatter.usesGroupingSeparator, false)
        
        formatter.currencySymbol = "%"
        formatter.showCurrencySymbol = false
        XCTAssertEqual(formatter.showCurrencySymbol, false)
        XCTAssertEqual(formatter.numberFormatter.currencySymbol, "")
        
        formatter.showCurrencySymbol = true
        formatter.currencySymbol = "%"
        XCTAssertEqual(formatter.showCurrencySymbol, true)
        XCTAssertEqual(formatter.numberFormatter.currencySymbol, "%")
    }
    
    func testMinAndMaxValues() {
        formatter.minValue = nil
        formatter.maxValue = nil
        
        var formattedString = formatter.string(from: 300000.54)
        XCTAssertEqual(formattedString, "€300,000.54")
        
        formatter.minValue = 10
        formatter.maxValue = 100.31
        
        formattedString = formatter.formattedStringAdjustedToFitAllowedValues(from: "€300,000.54")
        XCTAssertEqual(formattedString, "€100.31")
        
        formattedString = formatter.formattedStringAdjustedToFitAllowedValues(from: "€2.03")
        XCTAssertEqual(formattedString, "€10.00")
        
        formattedString = formatter.string(from: 88888888)
        XCTAssertEqual(formattedString, "€100.31")
        
        formattedString = formatter.string(from: 1)
        XCTAssertEqual(formattedString, "€10.00")
        
        formatter.minValue = -351
        formattedString = formatter.string(from: -24)
        XCTAssertEqual(formattedString, "-€24.00")
        
        formattedString = formatter.string(from: -400)
        XCTAssertEqual(formattedString, "-€351.00")
    }
    
    func testFormatting() {
        formatter.locale = CurrencyLocale.portugueseBrazil
        formatter.currency = .euro
        formatter.hasDecimals = true
        
        let formattedString = formatter.string(from: 300000.54)
        XCTAssertEqual(formattedString, "€ 300.000,54")
        
        let unformattedString = formatter.unformatted(string: formattedString!)
        XCTAssertEqual(unformattedString, "300000.54")
        
        let doubleValue = formatter.double(from: "300000.54")
        XCTAssertEqual(doubleValue, 300000.54)
    }

    func testUnformattedValueWhenHasDecimal() {
        formatter.locale = CurrencyLocale.portugueseBrazil
        formatter.currency = .euro
        formatter.hasDecimals = true

        XCTAssertEqual(
            formatter.unformatted(string: "€ 300.000,54"),
            "300000.54"
        )
        XCTAssertEqual(
            formatter.unformatted(string: "¥ 0,99"),
            "0.99"
        )
        XCTAssertEqual(
            formatter.unformatted(string: "$333,84"),
            "333.84"
        )
    }

    func testUnformattedValueWhenDecimalsAreDisabled() {
        formatter.hasDecimals = false

        XCTAssertEqual(
            formatter.unformatted(string: "€ 300.000"),
            "300000"
        )
        XCTAssertEqual(
            formatter.unformatted(string: "¥3.953"),
            "3953"
        )
        XCTAssertEqual(
            formatter.unformatted(string: "$999"),
            "999"
        )
    }
    
    func testDoubleFromStringForDifferentFormatters() {
        formatter.locale = CurrencyLocale.portugueseBrazil
        formatter.currency = .euro
        formatter.hasDecimals = true
        
        var doubleValue = formatter.double(from: "00.02")
        XCTAssertEqual(doubleValue, 0.02)
        
        formatter.locale = CurrencyLocale.dutchBelgium
        formatter.currency = .dollar
        formatter.hasDecimals = false
        
        doubleValue = formatter.double(from: "00.02")
        XCTAssertEqual(doubleValue, 0.02)
        
        formatter.locale = CurrencyLocale.zarma
        formatter.hasDecimals = false
        
        doubleValue = formatter.double(from: "100.12")
        XCTAssertEqual(doubleValue, 100.12)
    }
}
