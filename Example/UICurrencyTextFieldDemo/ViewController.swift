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

    @IBOutlet weak var textField: UICurrencyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configCurrencyTextField()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configCurrencyTextField() {
        textField.maximumIntegers = 4
        textField.hasAutoclear = true
    }
}
