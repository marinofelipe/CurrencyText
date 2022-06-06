//
//  ViewController.swift
//  Example
//
//  Created by Felipe Lefèvre Marino on 4/24/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import SwiftUI

import CurrencyTextField
import CurrencyFormatter

/// - note: When using CocoaPods one should import the spec, with access to the full library or defined sub-specs
/// import CurrencyText

import Combine
import UIKit

struct CurrencyData {
    var text: String = ""
    var unformatted: String?
    var input: Double?
    var hasFocus: Bool?
}

final class CurrencyViewModel: ObservableObject {
    @Published var data = CurrencyData()
}

struct SwiftUIExampleView: View {
    @ObservedObject private var viewModel = CurrencyViewModel()
    @State private var currencyFormatter = CurrencyFormatter.default
    @State private var shouldClearTextField = false
    @State private var currency: Currency = .euro

    var body: some View {
        Form {
            Section {
                makeCurrencyTextField()

                Text("Formatted value: \(String(describing: $viewModel.data.text.wrappedValue))")
                Text("Unformatted value: \(String(describing: $viewModel.data.unformatted.wrappedValue))")
                Text("Input amount: \(String(describing: $viewModel.data.input.wrappedValue))")

                Picker(
                    "Change currency",
                    selection: $currency
                ) {
                    ForEach(
                        [
                            Currency.euro,
                            Currency.dollar,
                            Currency.brazilianReal,
                            Currency.yen
                        ],
                        id: \.self
                    ) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: currency) { newValue in
                    currencyFormatter = .init {
                        $0.currency = newValue
                    }
                }

                Button("Toggle clear text field on focus change") {
                    shouldClearTextField.toggle()
                }
                .buttonStyle(.plain)
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.data.hasFocus = true
        }
    }

    private func makeCurrencyTextField() -> some View {
        CurrencyTextField(
            configuration: .init(
                placeholder: "Play with me...",
                text: $viewModel.data.text,
                unformattedText: $viewModel.data.unformatted,
                inputAmount: $viewModel.data.input,
                hasFocus: $viewModel.data.hasFocus,
                clearsWhenValueIsZero: true,
                formatter: $currencyFormatter,
                textFieldConfiguration: { uiTextField in
                    uiTextField.borderStyle = .roundedRect
                    uiTextField.font = UIFont.preferredFont(forTextStyle: .body)
                    uiTextField.textColor = .blue
                    uiTextField.layer.borderColor = UIColor.red.cgColor
                    uiTextField.layer.borderWidth = 1
                    uiTextField.layer.cornerRadius = 4
                    uiTextField.keyboardType = .numbersAndPunctuation
                    uiTextField.layer.masksToBounds = true
                },
                onEditingChanged: { isEditing in
                    if isEditing == false && shouldClearTextField {
                        // How to programmatically clear the text of CurrencyTextField:
                        // The Binding<String>.text that is passed into CurrencyTextField.configuration can
                        // manually cleared / updated with an empty String
                        clearTextFieldText()
                    }
                },
                onCommit: {
                    print("onCommit")
                }
            )
        )
        .disabled(false)
    }
}

private extension SwiftUIExampleView {
    func clearTextFieldText() {
        viewModel.data.text = ""
    }
}

private extension CurrencyFormatter {
    static let `default`: CurrencyFormatter = {
        .init {
            $0.currency = .euro
            $0.locale = CurrencyLocale.germanGermany
            $0.hasDecimals = true
            $0.minValue = 5
            $0.maxValue = 100000000
        }
    }()
}
