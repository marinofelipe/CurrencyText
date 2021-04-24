//
//  WrappedTextField.swift
//  
//
//  Created by Marino Felipe on 24.04.21.
//

import Combine
import UIKit

import CurrencyFormatter
import CurrencyUITextFieldDelegate

@available(iOS 13.0, *)
final class WrappedTextField: UITextField, UITextFieldDelegate {
    private let currencyDelegate: CurrencyUITextFieldDelegate
    private let configuration: CurrencyTextFieldConfiguration

    init(configuration: CurrencyTextFieldConfiguration) {
        self.configuration = configuration
        self.currencyDelegate = CurrencyUITextFieldDelegate(formatter: configuration.formatter)
        self.currencyDelegate.clearsWhenValueIsZero = configuration.clearsWhenValueIsZero

        super.init(frame: .zero)

        self.delegate = currencyDelegate
        self.currencyDelegate.passthroughDelegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        configuration.$text.wrappedValue = textField.text ?? ""
        updateUnformattedTextAndInputValue()

        return false
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        configuration.onEditingChanged?(true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        configuration.onEditingChanged?(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        configuration.onCommit?()
        textField.resignFirstResponder()
        return true
    }


    private func updateUnformattedTextAndInputValue() {
        let unformattedText = configuration.formatter.unformatted(
            string: configuration.text
        ) ?? ""
        configuration.unformattedText?.wrappedValue = unformattedText

        configuration.inputAmount?.wrappedValue = configuration.formatter.double(
            from: unformattedText
        )
    }
}
