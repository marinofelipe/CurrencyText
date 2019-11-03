//
//  ViewController.swift
//  Example
//
//  Created by Felipe Lefèvre Marino on 4/24/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
import CurrencyText
/// *Note*: When using SPM you need to import each target, such as below:
///import CurrencyUITextFieldDelegate
///import CurrencyFormatter
///
/// If you are using CocoaPods you are able to import both `CurrencyText` and the subspecs mentioned above.

class ViewController: UIViewController {

    @IBOutlet weak private var textField: UITextField!
    
    private var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldWithCurrencyDelegate()
    }
    
    private func setupTextFieldWithCurrencyDelegate() {
        let currencyFormatter = CurrencyFormatter {
            $0.maxValue = 1000000
            $0.minValue = -1000000
            $0.currency = .euro
            $0.locale = CurrencyLocale.german
            $0.hasDecimals = false
        }
        
        textFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
        textFieldDelegate.clearsWhenValueIsZero = true
        
        textField.delegate = textFieldDelegate
        textField.keyboardType = .numbersAndPunctuation
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignAnyFirstReponder()
    }
    
    @objc func resignAnyFirstReponder() {
        self.view.endEditing(false)
    }
}
