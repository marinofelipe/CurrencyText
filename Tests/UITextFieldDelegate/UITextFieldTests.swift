//
//  UITextFieldTests.swift
//  ExampleTests
//
//  Created by Felipe Lefèvre Marino on 12/27/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import XCTest
@testable import CurrencyUITextFieldDelegate

class UITextFieldTests: XCTestCase {
    
    var textField: UITextField!

    override func setUp() {
        super.setUp()
        textField = UITextField()
    }

    override func tearDown() {
        textField = nil
        super.tearDown()
    }

    func testUpdatingSelectedTextRange() {
        textField.text?.append("352450260")
        
        textField.updateSelectedTextRange(lastOffsetFromEnd: 0)
        XCTAssertEqual(textField.selectedTextRange?.end, textField.position(from: textField.endOfDocument, offset: 0))
        
        textField.updateSelectedTextRange(lastOffsetFromEnd: -5)
        XCTAssertEqual(textField.selectedTextRange?.end, textField.position(from: textField.endOfDocument, offset: -5))
    }
    
    func testGettingOffsetFromEnd() {
        textField.text?.append("450")
        
        var position = textField.position(from: textField.endOfDocument, offset: 0)
        textField.selectedTextRange = textField.textRange(from: position!, to: position!)
        
        XCTAssertEqual(textField.selectedTextRangeOffsetFromEnd, 0)
        
        textField.text?.append("35")
        position = textField.position(from: textField.endOfDocument, offset: -4)
        textField.selectedTextRange = textField.textRange(from: position!, to: position!)
        XCTAssertEqual(textField.selectedTextRangeOffsetFromEnd, -4)
        
        textField.text?.removeLast()
        position = textField.position(from: textField.endOfDocument, offset: -1)
        textField.selectedTextRange = textField.textRange(from: position!, to: position!)
        XCTAssertEqual(textField.selectedTextRangeOffsetFromEnd, -1)
    }
}
