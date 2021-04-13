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

/// - note: When using CocoaPods you can import the main spec, or each sub-spec as below:
/// // main spec
/// import CurrencyText
///
/// // each sub-spec
/// import CurrencyFormatter
/// import CurrencyTextField

import Combine

struct SwiftUIExampleView: View {
    @State private var text: String?
    @State private var unformattedText: String?
    @State private var inputAmount: Decimal?

    static var currencyFormatter: CurrencyFormatter = .init()
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()

    var body: some View {
        Form {
            Section {
                CurrencyTextField(
                    configuration: .init(
                        placeholder: "Play with me...",
                        text: $text,
                        unformattedText: $unformattedText,
                        inputAmount: $inputAmount,
                        onCommitHandler: nil,
                        onEditingChangedHandler: nil
                    ),
                    formatter: CurrencyTextFieldFormatter(
                        formatter: CurrencyFormatter {
                            $0.maxValue = 100000000
                            $0.minValue = 5
                            $0.currency = .dollar
                            $0.locale = CurrencyLocale.englishUnitedStates
                            $0.hasDecimals = true
                        },
                        clearsWhenValueIsZero: true
                    )
                )
                .frame(
                    maxWidth: 200
                )
                .fixedSize()
                .textFieldStyle(
                    RoundedBorderTextFieldStyle()
                )

                Text("Formatted value: \(String(describing: text))")
                Text("Unformatted value: \(String(describing: unformattedText))")
                Text("Input amount: \(String(describing: inputAmount))")
            }
        }
        .navigationTitle("SwiftUI")
        .navigationBarTitleDisplayMode(.inline)
        .contentShape(Rectangle()) // makes the whole view area tappable
        .onTapGesture(perform: endEditing)
    }
}

import UIKit

extension View {
    func endEditing() {
        UIApplication.shared.endEditing()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(
            #selector(Self.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
