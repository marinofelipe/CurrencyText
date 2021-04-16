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
    @Binding private(set) var text: String

    let unformattedText: Binding<String>?
    let inputAmount: Binding<Double>?

    let onCommitHandler: (() -> Void)?
    let onEditingChangedHandler: ((Bool) -> Void)?

    public static func makeDefault(
        text: Binding<String>
    ) -> Self {
        .init(
            text: text,
            onCommitHandler: nil,
            onEditingChangedHandler: nil
        )
    }

    public init(
        placeholder: String = "",
        text: Binding<String>,
        unformattedText: Binding<String>? = nil,
        inputAmount: Binding<Double>? = nil,
        onCommitHandler: (() -> Void)?,
        onEditingChangedHandler: ((Bool) -> Void)?
    ) {
        self.placeholder = placeholder
        self._text = text
        self.unformattedText = unformattedText
        self.inputAmount = inputAmount
        self.onCommitHandler = onCommitHandler
        self.onEditingChangedHandler = onEditingChangedHandler
    }
}
