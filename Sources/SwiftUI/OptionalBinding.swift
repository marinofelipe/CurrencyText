//
//  OptionalBinding.swift
//  
//
//  Created by Marino Felipe on 16.04.21.
//

import struct SwiftUI.Binding

@available(iOS 13.0, *)
@propertyWrapper
struct OptionalBinding<T> {
    var wrappedValue: Binding<T>?

    init(wrappedValue: Binding<T>?) {
        self.wrappedValue = wrappedValue
    }
}
