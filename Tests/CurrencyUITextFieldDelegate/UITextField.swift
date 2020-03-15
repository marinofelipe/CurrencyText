//
//  UITextField.swift
//  ExampleTests
//
//  Created by Felipe Lefèvre Marino on 12/29/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UITextField {
    
    var textLength: Int {
        return text?.count ?? 0
    }
    
    func sendDeleteKeyboardAction(at location: Int? = nil) {
        let _ = delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: location ?? textLength, length: 1), replacementString: "")
    }
}
