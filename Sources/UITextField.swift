//
//  UITextField.swift
//  UICurrencyTextField
//
//  Created by Felipe Lefèvre Marino on 12/26/18.
//

import UIKit

extension UITextField {
    
    func updateSelectedTextRange(offset: Int) {
        if let updatedCursorPosition = position(from: endOfDocument, offset: offset) {
            selectedTextRange = textRange(from: updatedCursorPosition, to: updatedCursorPosition)
        }
    }
}
