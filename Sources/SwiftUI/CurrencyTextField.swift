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
        textField.keyboardType = .numberPad
        configuration.underlyingTextFieldConfiguration?(textField)

        return textField
    }

    public func updateUIView(
        _ uiView: UITextField,
        context: UIViewRepresentableContext<CurrencyTextField>
    ) {
        guard let textField = uiView as? WrappedTextField else { return }

        textField.updateConfigurationIfNeeded(latest: configuration)
        textField.updateTextIfNeeded()
    }
}
