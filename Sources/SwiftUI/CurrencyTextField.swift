//
//  CurrencyTextField.swift
//  
//
//  Created by Marino Felipe on 12.04.21.
//

import Combine
import SwiftUI

@available(iOS 13.0, *)
public struct CurrencyTextField: View {
    public init(
        configuration: CurrencyTextFieldConfiguration,
        formatter: CurrencyTextFieldFormatter
    ) {
        self.configuration = configuration
        self.formatter = formatter
        self.editingValue = configuration.text
    }

    let configuration: CurrencyTextFieldConfiguration
    let formatter: CurrencyTextFieldFormatter

    @State private var editingValue: String = "" {
        didSet {
            guard editingValue != oldValue else { return }
            self.configuration.$text.wrappedValue = editingValue
            self.configuration.unformattedText?.wrappedValue = formatter.unformattedValue(
                for: editingValue
            ) ?? ""
            self.configuration.inputAmount?.wrappedValue = formatter.double(
                for: configuration.unformattedText?.wrappedValue ?? ""
            ) ?? 0
        }
    }

    public var body: some View {
        VStack {
            TextField(
                configuration.placeholder,
                text: configuration.$text,
                onEditingChanged: { isEditing in
                    defer {
                        configuration.onEditingChangedHandler?(isEditing)
                    }

                    let updatedText = formatter.editingChangedUpdatedFormattedText(
                        isEditing: isEditing,
                        currentText: configuration.$text.wrappedValue
                    )

                    configuration.$text.wrappedValue = updatedText ?? ""
                    editingValue = updatedText ?? ""
                },
                onCommit: {
                    configuration.onCommitHandler?()
                }
            )
            .onReceive(
                Just(configuration.text)
            ) { newValue in
                let val = formatter.getUpdatedFormattedText(
                    for: newValue,
                    previousValue: editingValue
                )
                configuration.$text.wrappedValue = val ?? ""
                editingValue = val ?? ""
            }
        }
    }
}
