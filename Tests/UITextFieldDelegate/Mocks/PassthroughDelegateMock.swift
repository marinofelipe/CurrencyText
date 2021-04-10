//
//  CurrencyTextFieldDelegateTests.swift
//  CurrencyTextFieldTests
//
//  Created by Felipe Lefèvre Marino on 3/15/20.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
@testable import CurrencyUITextFieldDelegate
@testable import CurrencyFormatter

final class PassthroughDelegateMock: NSObject, UITextFieldDelegate {

    private(set) var lastTextField: UITextField?
    private(set) var didCallTextFieldShouldBeginEditing: Bool = false
    private(set) var didCallTextFieldDidBeginEditing: Bool = false
    private(set) var didCallTextFieldShouldEndEditing: Bool = false
    private(set) var didCallTextFieldDidEndEditing: Bool = false
    private(set) var didCallTextFieldShouldClear: Bool = false
    private(set) var didCallTextFieldShouldReturn: Bool = false
    private(set) var didCallTextFieldShouldChangeCharacters: Bool = false
    private(set) var lastRange: NSRange?
    private(set) var lastReplacementString: String?

    @discardableResult
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        didCallTextFieldShouldBeginEditing = true
        lastTextField = textField

        return true
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        didCallTextFieldDidBeginEditing = true
        lastTextField = textField
    }

    @discardableResult
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        didCallTextFieldShouldEndEditing = true
        lastTextField = textField

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        didCallTextFieldDidEndEditing = true
        lastTextField = textField
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        didCallTextFieldShouldClear = true
        lastTextField = textField

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didCallTextFieldShouldReturn = true
        lastTextField = textField

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        didCallTextFieldShouldChangeCharacters = true
        lastTextField = textField
        lastRange = range
        lastReplacementString = string

        return true
    }
}
