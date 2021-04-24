//
//  ViewController.swift
//  Example
//
//  Created by Felipe Lefèvre Marino on 4/24/18.
//  Copyright © 2018 Felipe Lefèvre Marino. All rights reserved.
//

import UIKit

import CurrencyUITextFieldDelegate
import CurrencyFormatter

/// - note: When using CocoaPods you can import the main spec, or each sub-spec as below:
/// // main spec
/// import CurrencyText
///
/// // each sub-spec
/// import CurrencyFormatter
/// import CurrencyUITextField

final class UIKitExampleViewController: UIViewController {

    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center

        return stackView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )

        return stackView
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Play with me..."

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

        title = "UIKit"
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

        outerStackView.addArrangedSubview(stackView)
        view.addSubview(outerStackView)

        outerStackView.topAnchor
            .constraint(equalTo: view.layoutMarginsGuide.topAnchor)
            .isActive = true
        outerStackView.trailingAnchor
            .constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
            .isActive = true
        outerStackView.leadingAnchor
            .constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
            .isActive = true
        outerStackView.bottomAnchor
            .constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
            .isActive = true
    }
    
    private func setupTextFieldWithCurrencyDelegate() {
        let currencyFormatter = CurrencyFormatter {
            $0.maxValue = 100000000
            $0.minValue = 5
            $0.currency = .euro
            $0.locale = CurrencyLocale.germanGermany
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
