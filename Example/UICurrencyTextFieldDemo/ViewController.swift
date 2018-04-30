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
    @IBOutlet weak var programaticallyAddedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTextFieldOutlet()
        programaticallyAddTextField()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configTextFieldOutlet() {
        textField.maximumIntegers = 4
        textField.hasAutoclear = true
    }
    
    private func programaticallyAddTextField() {
        let textFieldFrame = CGRect(x: view.frame.width / 2 - 87.5, y: programaticallyAddedLabel.frame.origin.y + programaticallyAddedLabel.frame.height + 30, width: 175, height: 30)
        let currencyTextField = UICurrencyTextField(frame: textFieldFrame)
        currencyTextField.borderStyle = .roundedRect
        
        view.addSubview(currencyTextField)
    }
}
