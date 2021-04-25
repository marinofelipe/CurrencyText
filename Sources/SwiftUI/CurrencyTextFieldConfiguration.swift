//
//  CurrencyTextField.swift
//  
//
//  Created by Marino Felipe on 11.04.21.
//

import CurrencyFormatter

import Foundation
import struct SwiftUI.Binding

import UIKit

@available(iOS 13.0, *)
public final class CurrencyTextFieldConfiguration {
    let placeholder: String

    @Binding
    var text: String

    @OptionalBinding
    private(set) var unformattedText: Binding<String?>?

    @OptionalBinding
    private(set) var inputAmount: Binding<Double?>?

    /// Text field clears its text when value value is equal to zero.
    let clearsWhenValueIsZero: Bool

    // Formatter
    let formatter: CurrencyFormatter

    let onCommit: (() -> Void)?
    let onEditingChanged: ((Bool) -> Void)?

    // underlying `UITextField` configuration block
    let underlyingTextFieldConfiguration: ((UITextField) -> Void)?

    public static func makeDefault(
        text: Binding<String>,
        formatter: CurrencyFormatter
    ) -> Self {
        .init(
            text: text,
            formatter: formatter,
            underlyingTextFieldConfiguration: nil,
            onEditingChanged: nil,
            onCommit: nil
        )
    }

    public init(
        placeholder: String = "",
        text: Binding<String>,
        unformattedText: Binding<String?>? = nil,
        inputAmount: Binding<Double?>? = nil,
        clearsWhenValueIsZero: Bool = false,
        formatter: CurrencyFormatter,
        underlyingTextFieldConfiguration: ((UITextField) -> Void)?,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.unformattedText = unformattedText
        self.inputAmount = inputAmount
        self.formatter = formatter
        self.clearsWhenValueIsZero = clearsWhenValueIsZero
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.underlyingTextFieldConfiguration = underlyingTextFieldConfiguration
    }
}
