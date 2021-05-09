//
//  Fixtures+CurrencyTextFieldConfiguration.swift
//  
//
//  Created by Marino Felipe on 25.04.21.
//

import SwiftUI

#if canImport(CurrencyFormatter)
import CurrencyFormatter
#endif

#if canImport(CurrencyTextField)
import CurrencyTextField
#endif

@available(iOS 13.0, *)
public extension CurrencyTextFieldConfiguration {
    static func makeFixture(
        placeholder: String = "some",
        textBinding: Binding<String> = .init(
            get: { "text" },
            set: { _ in }
        ),
        unformattedTextBinding: Binding<String?> = .init(
            get: { "unformatted" },
            set: { _ in }
        ),
        inputAmountBinding: Binding<Double?> = .init(
            get: { .zero },
            set: { _ in }
        ),
        clearsWhenValueIsZero: Bool = true,
        formatter: CurrencyFormatter,
        textFieldConfiguration: ((UITextField) -> Void)? = { _ in },
        onEditingChanged: ((Bool) -> Void)? = { _ in },
        onCommit: (() -> Void)? = { }
    ) -> Self {
        .init(
            placeholder: placeholder,
            text: textBinding,
            unformattedText: unformattedTextBinding,
            inputAmount: inputAmountBinding,
            clearsWhenValueIsZero: clearsWhenValueIsZero,
            formatter: formatter,
            textFieldConfiguration: textFieldConfiguration,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }
}
