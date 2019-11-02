//
//  NumberFormatterTests.swift
//  ExampleTests
//
//  Created by Felipe Lefèvre Marino on 12/27/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest

class NumberFormatterTests: XCTestCase {

    func testStringFromDouble() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        // nil double
        XCTAssertNil(formatter.string(from: nil))
        
        // double
        XCTAssertEqual(formatter.string(from: 3500.32), "$3,500.32")
    }
}

// MARK: All Tests
extension NumberFormatterTests {
    static var allTests = {
        return [
            ("testStringFromDouble", testStringFromDouble),
        ]
    }
}
