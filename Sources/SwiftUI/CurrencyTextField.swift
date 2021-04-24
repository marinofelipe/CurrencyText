//
//  CurrencyTextField.swift
//  
//
//  Created by Marino Felipe on 12.04.21.
//

import Combine
import SwiftUI

@available(iOS 13.0, *)
public struct CurrencyTextField: UIViewRepresentable {
    private let configuration: CurrencyTextFieldConfiguration

    public init(configuration: CurrencyTextFieldConfiguration) {
        self.configuration = configuration
    }

    public func makeUIView(
        context: UIViewRepresentableContext<CurrencyTextField>
    ) -> UITextField {
        let textField = WrappedTextField(configuration: configuration)
        textField.placeholder = configuration.placeholder
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.text = configuration.text
        textField.keyboardType = .numberPad
        configuration.underlyingTextFieldConfiguration?(textField)

        return textField
    }

    public func updateUIView(
        _ uiView: UITextField,
        context: UIViewRepresentableContext<CurrencyTextField>
    ) {
        guard configuration.text != uiView.text else { return }

        uiView.text = configuration.text
        updateUnformattedTextAndInputValue()
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
