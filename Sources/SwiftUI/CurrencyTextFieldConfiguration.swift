//
//  CurrencyTextField.swift
//  
//
//  Created by Marino Felipe on 11.04.21.
//

import Foundation
import struct SwiftUI.Binding

@available(iOS 13.0, *)
public struct CurrencyTextFieldConfiguration {
    let placeholder: String
    let text: Binding<String?>

    let unformattedText: Binding<String?>?
    let inputAmount: Binding<Decimal?>?

    let onCommitHandler: (() -> Void)?
    let onEditingChangedHandler: ((Bool) -> Void)?

    public static func makeDefault(
        text: Binding<String?>
    ) -> Self {
        .init(
            text: text,
            onCommitHandler: nil,
            onEditingChangedHandler: nil
        )
    }

    public init(
        placeholder: String = "",
        text: Binding<String?>,
        unformattedText: Binding<String?>? = nil,
        inputAmount: Binding<Decimal?>? = nil,
        onCommitHandler: (() -> Void)?,
        onEditingChangedHandler: ((Bool) -> Void)?
    ) {
        self.placeholder = placeholder
        self.text = text
        self.unformattedText = unformattedText
        self.inputAmount = inputAmount
        self.onCommitHandler = onCommitHandler
        self.onEditingChangedHandler = onEditingChangedHandler
    }
}

@available(iOS 13.0, *)
extension CurrencyTextFieldConfiguration: Equatable {
    public static func == (
        lhs: CurrencyTextFieldConfiguration,
        rhs: CurrencyTextFieldConfiguration
    ) -> Bool {
        lhs.placeholder == rhs.placeholder
            && lhs.text.wrappedValue == rhs.text.wrappedValue
            && lhs.unformattedText?.wrappedValue == rhs.unformattedText?.wrappedValue
            && lhs.inputAmount?.wrappedValue == rhs.inputAmount?.wrappedValue
    }
}
