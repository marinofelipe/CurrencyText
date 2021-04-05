//
//  ViewController.swift
//  Example
//
//  Created by Felipe Lefèvre Marino on 4/24/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit
import CurrencyText
/// - note: When using SPM you need to import each target, such as below:
/// import CurrencyUITextFieldDelegate
/// import CurrencyFormatter
///
/// If you are using CocoaPods you are able to import both `CurrencyText` and the sub-specs mentioned above.

final class UIKitExampleViewController: UIViewController {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        return stackView
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Play with me..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor
            .constraint(equalToConstant: 50)
            .isActive = true
        textField.widthAnchor
            .constraint(equalToConstant: 200)
            .isActive = true

        return textField
    }()

    private let formattedValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let unformattedValueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private var textFieldDelegate: CurrencyUITextFieldDelegate!

    override init(
        nibName nibNameOrNil: String?,
        bundle nibBundleOrNil: Bundle?
    ) {
        super.init(nibName: nil, bundle: nil)

        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUp() {
        view.backgroundColor = .white

        setUpViewHierarchy()
        setupTextFieldWithCurrencyDelegate()
    }

    private func setUpViewHierarchy() {
        [
            textField,
            formattedValueLabel,
            unformattedValueLabel
        ].forEach(stackView.addArrangedSubview)

        view.addSubview(stackView)

        stackView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
            .isActive = true
        stackView.topAnchor
            .constraint(equalTo: view.layoutMarginsGuide.topAnchor)
            .isActive = true
        stackView.trailingAnchor
            .constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            .isActive = true
        stackView.leadingAnchor
            .constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
            .isActive = true
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
        resignAnyFirstResponder()
    }
    
    @objc func resignAnyFirstResponder() {
        view.endEditing(false)
    }
}

extension UIKitExampleViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let unformattedValue = textFieldDelegate
            .formatter
            .unformatted(
                string: textField.text ?? "0"
            ) ?? "0"
        formattedValueLabel.text = "Formatted value: \(textField.text ?? "0")"
        unformattedValueLabel.text = "Unformatted value: \(unformattedValue)"
    }
}
