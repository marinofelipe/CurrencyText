//
//  CurrencyTests.swift
//  CurrencyTextDemoTests
//
//  Created by Felipe Lefèvre Marino on 2/11/19.
//  Copyright © 2019 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import CurrencyText

class CurrencyTests: XCTestCase {

    func testInit() {
        XCTAssertNil(Currency(rawValue: "INVALID"))
        XCTAssertNotNil(Currency(rawValue: Currency.afghani.rawValue))
    }
}
