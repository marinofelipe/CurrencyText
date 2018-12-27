//
//  ViewController.swift
//  UICurrencyTextFieldDemo
//
//  Created by Felipe Lefèvre Marino on 4/24/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UICurrencyTextField
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldWithCurrencyDelegate()
    }
    
    private func setupTextFieldWithCurrencyDelegate() {

        let currencyDelegate = UICurrencyTextFieldDelegate()
        currencyDelegate.maximumIntegers = 4
        currencyDelegate.hasAutoclear = true
        
        textField.delegate = currencyDelegate
        textField.keyboardType = .numberPad
    }
}
