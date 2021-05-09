//
//  CurrencyTextField.swift
//  
//
//  Created by Marino Felipe on 12.04.21.
//

import Combine
import SwiftUI

/// A control that displays an editable currency text.
///
/// You create a text field with a configuration for setting its properties and behavior.
/// The configuration requires a placeholder text that is shown to describe the text field purpose
/// whenever it's empty, a text binding and currency formatter that holds all the currency formatting
/// related settings.
///
/// The configuration also allows you to provide two closures that customize its
/// behavior. The `onEditingChanged` property informs your app when the user
/// begins or ends editing the text. The `onCommit` property executes when the
/// user commits their edits.
///
/// The following example shows a currency text field that performs and action to store the
/// amount inputted by the user at the moment the user commits the entry:
///
///     @State private var text: String = ""
///     @State private var unformattedText: String?
///     @State private var value: Double?
///
///     var body: some View {
///         CurrencyTextField(
///             configuration: .init(
///                 placeholder: "Currency value",
///                 text: $text,
///                 unformattedText: $unformattedText,
///                 inputAmount: $value,
///                 formatter: CurrencyFormatter.myFormatter,
///                 textFieldConfiguration: { uiTextField in
///                    uiTextField.font = UIFont.preferredFont(forTextStyle: .body)
///                    uiTextField.textColor = .blue
///                 },
///                 onEditingChanged: { isEditing in
///                    if isEditing == false {
///                       clearTextFieldText()
///                    }
///                 },
///                 onCommit: {
///                    storeValue()
///                 }
///             )
///         )
///         .autocapitalization(.none)
///         .disableAutocorrection(true)
///         .border(Color(UIColor.separator))
///         Text(username)
///             .foregroundColor(isEditing ? .red : .blue)
///     }
///
/// ### Styling Currency Text Fields
///
/// Given that so far SwiftUI doesn't provide API for customizing the text field selectedTextRange, CurrencyTextField bridges
/// CurrencyText's UIKit implementation to SwiftUI, so it can control the selectedTextRange to provide a better experience for all
/// formatter configurations, even when the currency symbol sits at the end of the formatted text.
///
/// Because of that to customize the style of a currency text field,`most` SwiftUI modifiers that work on TextField `doesn't work`
/// with CurrencyTextField. To overcome such limitation all styling and additional configurations can be done via the underlying UITextField
/// configuration block:
/// `textFieldConfiguration` block:
///
///         var body: some View {
///            CurrencyTextField(
///               configuration: .init(
///                  placeholder: "Currency value",
///                  text: $text,
///                  formatter: CurrencyFormatter.myFormatter,
///                  textFieldConfiguration: { uiTextField in
///                     uiTextField.borderStyle = .roundedRect
///                     uiTextField.font = UIFont.preferredFont(forTextStyle: .body)
///                     uiTextField.textColor = .blue
///                     uiTextField.layer.borderColor = UIColor.red.cgColor
///                     uiTextField.layer.borderWidth = 1
///                     uiTextField.layer.cornerRadius = 4
///                     uiTextField.keyboardType = .numbersAndPunctuation
///                     uiTextField.layer.masksToBounds = true
///                 }
///             )
///         )
///
@available(iOS 13.0, *)
public struct CurrencyTextField: UIViewRepresentable {
    private let configuration: CurrencyTextFieldConfiguration

    /// Creates a currency text field instance with given configuration.
    ///
    /// - Parameter configuration: The configuration holding settings and properties to configure the text field with.
    public init(configuration: CurrencyTextFieldConfiguration) {
        self.configuration = configuration
    }

    public func makeUIView(
        context: UIViewRepresentableContext<CurrencyTextField>
    ) -> UITextField {
        let textField = WrappedTextField(configuration: configuration)
        textField.placeholder = configuration.placeholder
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.keyboardType = .numberPad
        configuration.textFieldConfiguration?(textField)

        return textField
    }

    public func updateUIView(
        _ uiView: UITextField,
        context: UIViewRepresentableContext<CurrencyTextField>
    ) {
        guard let textField = uiView as? WrappedTextField else { return }

        textField.updateConfigurationIfNeeded(latest: configuration)
        textField.updateTextIfNeeded()
    }
}
