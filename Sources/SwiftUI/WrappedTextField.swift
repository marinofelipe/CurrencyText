//
//  WrappedTextField.swift
//  
//
//  Created by Marino Felipe on 24.04.21.
//

import Combine
import UIKit

#if canImport(CurrencyFormatter)
import CurrencyFormatter
#endif

#if canImport(CurrencyUITextFieldDelegate)
import CurrencyUITextFieldDelegate
#endif

@available(iOS 13.0, *)
final class WrappedTextField: UITextField {
    private let currencyTextFieldDelegate: CurrencyUITextFieldDelegate
    private var configuration: CurrencyTextFieldConfiguration

    init(configuration: CurrencyTextFieldConfiguration) {
        self.configuration = configuration
        self.currencyTextFieldDelegate = CurrencyUITextFieldDelegate(formatter: configuration.formatter)
        self.currencyTextFieldDelegate.clearsWhenValueIsZero = configuration.clearsWhenValueIsZero

        super.init(frame: .zero)

        delegate = currencyTextFieldDelegate
        currencyTextFieldDelegate.passthroughDelegate = self
        updateText()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateConfigurationIfNeeded(latest configuration: CurrencyTextFieldConfiguration) {
        guard configuration !== self.configuration else { return }

        self.configuration = configuration
    }

    func updateTextIfNeeded() {
        guard configuration.text != text else { return }

        updateText()
    }
}

// MARK: - UITextFieldDelegate

@available(iOS 13.0, *)
extension WrappedTextField: UITextFieldDelegate {
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
}

// MARK: - Private

@available(iOS 13.0, *)
private extension WrappedTextField {
    func updateText() {
        let nsRange: NSRange
        if let textRange = text?.range(of: text ?? "") {
            nsRange = .init(
                textRange,
                in: text ?? ""
            )
        } else {
            nsRange = .init(location: 0, length: 0)
        }

        _ = delegate?.textField?(
            self,
            shouldChangeCharactersIn: nsRange,
            replacementString: configuration.$text.wrappedValue
        )
    }

    func updateUnformattedTextAndInputValue() {
        let unformattedText = configuration.formatter.unformatted(
            string: text ?? ""
        ) ?? ""
        configuration.unformattedText?.wrappedValue = unformattedText

        configuration.inputAmount?.wrappedValue = configuration.formatter.double(
            from: unformattedText
        )
    }
}
