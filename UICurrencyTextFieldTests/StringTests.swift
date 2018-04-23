//
//  String.swift
//  GroceryListTests
//
//  Created by Felipe Lefèvre Marino on 4/5/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import UICurrencyTextField

class StringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNumeralFormat() {
        let nonNumeralString = "*235&Q@6634(355$Q9_-$0_Q8$*64_!@1:'/.,.a"
        XCTAssertEqual(nonNumeralString.numeralFormat(), "2356634355908641", "numeralFormat() should restrict string to only numerals")
    }
    
    func testAddingDecimalSeparator() {
        
    }
    
    func testRemovingCurrencySeparators() {
        
    }
}
