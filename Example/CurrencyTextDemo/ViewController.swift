//
//  ViewController.swift
//  CurrencyTextDemo
//
//  Created by Felipe Lefèvre Marino on 4/24/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import CurrencyText
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak private var textField: UITextField!
    
    private var textFieldDelegate: CurrencyUITextFieldDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldWithCurrencyDelegate()
    }
    
    private func setupTextFieldWithCurrencyDelegate() {
        let currencyFormatter = CurrencyFormatter {
            // TODO: handle both location and currency -
            // setting a currency should update locale based on it.
            // Also should be documented that one overlapps the other
            $0.locale = CurrencyLocale.portugueseBrazil
            $0.maxValue = 1000000 // TODO: improve express by string, float or int
            $0.minValue = 3
            $0.currency = .brazilianReal
//            $0.hasDecimals = true
        }
        
        textFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
        textFieldDelegate.clearsWhenValueIsZero = true
        
        textField.delegate = textFieldDelegate
        textField.keyboardType = .numberPad
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignAnyFirstReponder()
    }
    
    @objc func resignAnyFirstReponder() {
        self.view.endEditing(false)
    }
}
