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
}

final class CurrencyViewModel: ObservableObject {
    @Published var data = CurrencyData()
}

struct SwiftUIExampleView: View {
    @ObservedObject private var viewModel = CurrencyViewModel()

    var body: some View {
        Form {
            Section {
                CurrencyTextField(
                    configuration: .init(
                        placeholder: "Play with me...",
                        text: $viewModel.data.text,
                        unformattedText: $viewModel.data.unformatted,
                        inputAmount: $viewModel.data.input,
                        clearsWhenValueIsZero: true,
                        formatter: .default,
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
                            if isEditing == false {
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

                Text("Formatted value: \(String(describing: $viewModel.data.text.wrappedValue))")
                Text("Unformatted value: \(String(describing: $viewModel.data.unformatted.wrappedValue))")
                Text("Input amount: \(String(describing: $viewModel.data.input.wrappedValue))")
            }
        }
        .navigationTitle("SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
        .contentShape(Rectangle()) // makes the whole view area tappable
        .onTapGesture {
            endEditing()
        }
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
            $0.maxValue = 100000000
            $0.minValue = 5
            $0.currency = .euro
            $0.locale = CurrencyLocale.germanGermany
            $0.hasDecimals = true
        }
    }()
}
