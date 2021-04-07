//
//  UIKitExampleView.swift
//  Example
//
//  Created by Marino Felipe on 05.04.21.
//  Copyright © 2021 Felipe Lefèvre Marino. All rights reserved.
//

import SwiftUI

struct UIKitExampleView: UIViewControllerRepresentable {
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<UIKitExampleView>
    ) -> UIKitExampleViewController {
        UIKitExampleViewController()
    }

    func updateUIViewController(
        _ uiViewController: UIKitExampleViewController,
        context: UIViewControllerRepresentableContext<UIKitExampleView>
    ) { }
}
