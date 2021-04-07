//
//  ViewController.swift
//  Example
//
//  Created by Felipe Lefèvre Marino on 4/24/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import SwiftUI
import CurrencyText

import Combine

struct SwiftUIExampleView: View {
    @State private var text = ""

    static var currencyFormatter: CurrencyFormatter = .init()
    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()

    var body: some View {
        VStack(alignment: .center) {
            Spacer()

            TextField(
                "Play with me...",
                text: $text,
                onEditingChanged: { _ in },
                onCommit: {
                    endEditing()
                }
            )
            .frame(
                maxWidth: 200
            )
            .fixedSize()
            .textFieldStyle(
                RoundedBorderTextFieldStyle()
            )

            Text(text)

            Spacer()
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
