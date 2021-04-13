//
//  RootView.swift
//  Example
//
//  Created by Marino Felipe on 05.04.21.
//  Copyright © 2021 Felipe Lefèvre Marino. All rights reserved.
//

import SwiftUI

enum CurrencyTextExample: Int, CaseIterable, Identifiable {
    case uiKit
    case swiftUI

    var id: Int { rawValue }
}

extension CurrencyTextExample {
    var title: String {
        switch self {
        case .uiKit:
            return "UIKit example"
        case .swiftUI:
            return "SwiftUI example"
        }
    }

    @ViewBuilder
    func makeBaseView() -> some View {
        switch self {
        case .uiKit:
            UIKitExampleView()
                .navigationTitle("UIKit")
                .navigationBarTitleDisplayMode(.inline)
        case .swiftUI:
            SwiftUIExampleView()
        }
    }
}

struct RootView: View {
    var body: some View {
        NavigationView {
            List(CurrencyTextExample.allCases) { example in
                NavigationLink(
                    example.title,
                    destination: example.makeBaseView()
                )
            }.navigationBarTitle("Try CurrencyText!")
        }
    }
}
