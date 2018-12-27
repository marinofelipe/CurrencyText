//
//  NumberFormatterTests.swift
//  UICurrencyTextFieldDemoTests
//
//  Created by Felipe Lefèvre Marino on 12/27/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest

class NumberFormatterTests: XCTestCase {

    func testStringFromDouble() {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        // nil double
        XCTAssertNil(formatter.string(from: nil))
        
        // double
        XCTAssertEqual(formatter.string(from: 3500.32), "R$3.500,32")
    }
}
