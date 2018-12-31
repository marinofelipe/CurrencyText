//
//  UITextField.swift
//  CurrencyTextDemoTests
//
//  Created by Felipe Lefèvre Marino on 12/29/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

extension UITextField {
    
    var textLength: Int {
        return text?.count ?? 0
    }
    
    func sendTextLastCharDeleteAction() {
        let _ = delegate?.textField?(self, shouldChangeCharactersIn: NSRange(location: textLength, length: 1), replacementString: "")
    }
}
