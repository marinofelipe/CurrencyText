//
//  View+Extensions.swift
//  
//
//  Created by Marino Felipe on 18.04.21.
//

import SwiftUI
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
