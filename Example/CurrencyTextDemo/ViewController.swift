//
//  ViewController.swift
//  UICurrencyTextFieldDemo
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

        textFieldDelegate = CurrencyUITextFieldDelegate()
        textFieldDelegate.maxIntegers = 4
        textFieldDelegate.hasAutoclear = true
        
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
