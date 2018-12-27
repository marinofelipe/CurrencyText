//
//  NumberFormatter.swift
//  UICurrencyTextField
//
//  Created by Felipe Lefèvre Marino on 12/27/18.
//

extension NumberFormatter {
    
    func string(from doubleValue: Double?) -> String? {
        if let doubleValue = doubleValue {
            return string(from: NSNumber(value: doubleValue))
        }
        return nil
    }
}
