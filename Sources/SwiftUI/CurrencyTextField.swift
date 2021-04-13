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
    }

    let configuration: CurrencyTextFieldConfiguration
    let formatter: CurrencyTextFieldFormatter

    @State private var editingValue: String = "" {
        didSet {
            guard editingValue != oldValue else { return }
            self.configuration.text.wrappedValue = editingValue
            self.configuration.unformattedText?.wrappedValue = formatter.unformattedValue(
                for: editingValue
            )
            self.configuration.inputAmount?.wrappedValue = Decimal(
                formatter.double(for: configuration.unformattedText?.wrappedValue ?? "") ?? 0
            )
        }
    }

    public var body: some View {
        VStack {

            TextField(
                configuration.placeholder,
                text: $editingValue,
                onEditingChanged: { isEditing in
                    defer {
                        configuration.onEditingChangedHandler?(isEditing)
                    }

                    let updatedText = formatter.editingChangedUpdatedFormattedText(
                        isEditing: isEditing,
                        currentText: self.editingValue
                    )

                    self.editingValue = updatedText ?? ""
                },
                onCommit: {
                    configuration.onCommitHandler?()
                }
            )
            .onReceive(
                Just(editingValue)
            ) { newValue in
                let val = self.formatter.getUpdatedFormattedText(
                    for: newValue,
                    previousValue: self.configuration.text.wrappedValue
                )
                self.editingValue = val ?? ""
            }
        }
    }
}

