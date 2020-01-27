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

class FieldDisplay: NSObject {
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var formattedLabel: UILabel!
    @IBOutlet weak private var unformattedLabel: UILabel!
    private var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    fileprivate func setupCurrencyDelegate(currency: CurrencyText.Currency, locale: CurrencyText.CurrencyLocale) {
        let currencyFormatter = CurrencyFormatter {
            $0.maxValue = 100000000
            $0.minValue = 1
            $0.currency = currency
            $0.locale = locale
            $0.hasDecimals = false
        }
        
        textFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
        textFieldDelegate.clearsWhenValueIsZero = true
        textFieldDelegate.passthroughDelegate = self
        
        textField.delegate = textFieldDelegate
        textField.keyboardType = .numbersAndPunctuation
    }
    
    fileprivate func setupDecimalMode() {
        let formatter = textFieldDelegate.formatter as! CurrencyFormatter
        formatter.hasDecimals = true
    }
    
    fileprivate func setupEditingText() {
        guard let formatter = textFieldDelegate.formatter as? CurrencyFormatter else { return }
        let initialText = formatter.hasDecimals ? "123456.78" : "123456"
        textField.text = formatter.updated(formattedString: initialText)
    }

}

extension FieldDisplay: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        formattedLabel.text = textField.text
        unformattedLabel.text = textFieldDelegate.formatter.unformatted(string: textField.text ?? "0")
    }
}
    

class ViewController: UIViewController {

    @IBOutlet weak private var euroFieldNew: FieldDisplay!
    @IBOutlet weak private var euroFieldEditing: FieldDisplay!
    @IBOutlet weak private var euroFieldDecimalNew: FieldDisplay!
    @IBOutlet weak private var euroFieldDecimalEditing: FieldDisplay!

    @IBOutlet weak private var dollarFieldNew: FieldDisplay!
    @IBOutlet weak private var dollarFieldEditing: FieldDisplay!
    @IBOutlet weak private var dollarFieldDecimalNew: FieldDisplay!
    @IBOutlet weak private var dollarFieldDecimalEditing: FieldDisplay!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = true
        
        euroFieldNew.setupCurrencyDelegate(currency: .euro, locale: .french)
        euroFieldEditing.setupCurrencyDelegate(currency: .euro, locale: .french)
        euroFieldDecimalNew.setupCurrencyDelegate(currency: .euro, locale: .french)
        euroFieldDecimalNew.setupDecimalMode()
        euroFieldDecimalEditing.setupCurrencyDelegate(currency: .euro, locale: .french)
        euroFieldDecimalEditing.setupDecimalMode()
        
        dollarFieldNew.setupCurrencyDelegate(currency: .dollar, locale: .englishUnitedStates)
        dollarFieldEditing.setupCurrencyDelegate(currency: .dollar, locale: .englishUnitedStates)
        dollarFieldDecimalNew.setupCurrencyDelegate(currency: .dollar, locale: .englishUnitedStates)
        dollarFieldDecimalNew.setupDecimalMode()
        dollarFieldDecimalEditing.setupCurrencyDelegate(currency: .dollar, locale: .englishUnitedStates)
        dollarFieldDecimalEditing.setupDecimalMode()

        euroFieldEditing.setupEditingText()
        euroFieldDecimalEditing.setupEditingText()
        dollarFieldEditing.setupEditingText()
        dollarFieldDecimalEditing.setupEditingText()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignAnyFirstReponder()
    }
    
    @objc func resignAnyFirstReponder() {
        self.view.endEditing(false)
    }
}


