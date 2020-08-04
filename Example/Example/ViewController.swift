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
    @IBOutlet weak private var formattedLabel: UILabel!
    @IBOutlet weak private var unformattedLabel: UILabel!

    private var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldWithCurrencyDelegate()
    }
    
    private func setupTextFieldWithCurrencyDelegate() {
        let currencyFormatter = CurrencyFormatter {
            $0.maxValue = 100000000
            $0.minValue = 1
            $0.currency = .dollar
            $0.locale = CurrencyLocale.englishUnitedStates
            $0.hasDecimals = true
        }
        
        textFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
        textFieldDelegate.clearsWhenValueIsZero = true
        textFieldDelegate.passthroughDelegate = self
        
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

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        formattedLabel.text = textField.text
        unformattedLabel.text = textFieldDelegate.formatter.unformatted(string: textField.text ?? "0")
    }
}
