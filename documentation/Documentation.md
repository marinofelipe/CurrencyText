# Documentation

- [Introduction to `CurrencyFormatter`](#currencyformatter)
  - [Basic Setup](#basics)
  - [`Currency and locale` - easily defining style](#currencyandlocale)
  - [`Locale` - setting currency's locale](#locale)
  - [`Currency` - how to choose a specific currency from it's name](#currency)
  - [Advanced setup](#advancedsetup)
- [UIKit](#uikit)
  - [The `CurrencyTextFieldDelegate`](#delegate)
  - [Setting your text field to format the inputs](#setting)
  - [Using the passthrough delegate](#passthrough)
  - [Allowing users to input `negative values`](#negative)
  - [All properties of `CurrencyFormatter`](#properties)
- [SwiftUI](#swiftui)
  - [`CurrencyTextField` - how to configure and use it](#currencytextfield)
  - [Why do I have to import UIKit?](#whyuikit)
  - [Why is it only available for iOS?](#whyonlyios)

<a name="currencyformatter"/>

## Introduction to `CurrencyFormatter`

`CurrencyFormatter` is `CurrencyText`'s core. It is a wrapper around `NumberFormatter` with currency number style, that provides API for formatting content as/from currency, and can be used both in isolation, injected into `CurrencyUITextFieldDelegate` for UIKit text field, or passed in to a `CurrencyTextField` in `SwiftUI`.

<a name="basics"/>

### Basic setup

Creating a `CurrencyFormatter` instance is pretty simple; you can use the builder pattern approach where the init class require a callback in which the self instance is passed, allowing you to configure your properties by keeping the code clean and readable ([Inspired by SwiftRichString](https://github.com/malcommac/SwiftRichString)):

```swift
let formatter = CurrencyFormatter {
  $0.currency = .euro
  // set any other attribute available on CurrencyFormatter public API
}

let formattedString = formatter.string(from: 30.0) //€30.00
```

<a name="currencyandlocale"/>

### `Currency and locale` -  defining formatting style

To change the currency style (symbol, formatting, separators) you must make use of `.currency` and `.locale` properties. 
By default such properties are configured based on the user's system configurations, deriving the currency format from the user current locale (`Locale.autoUpdating`).
Therefore only set these properties in cases where you want granular control over how the currency is formatted, e.g. always in `currency.dollar` with `CurrencyLocale.englishUnitedStates`.

<a name="locale"/>

#### `Locale` - setting currency's locale
###### All locales were extracted from [jacobbubu - ioslocaleidentifiers](https://gist.github.com/jacobbubu/1836273)
`CurrencyLocale` is a String backed enum that wraps all available Locale identifiers. 
`CurrencyFormatter`'s `locale` property can be set by passing a common system Locale or one of CurrencyLocale's cases, such as .italian, .danish or .chinese. 
Note that you can set locale and compose it with a different currency of your choice, what is going to change is generally only the currency symbol.

```swift
public enum CurrencyLocale: String, LocaleConvertible {
    
    case current = "current"
    case autoUpdating = "currentAutoUpdating"
    
    case afrikaans = "af"
    case afrikaansNamibia = "af_NA"
    case afrikaansSouthAfrica = "af_ZA"
    //...
}
```

<a name="currency"/>

#### `Currency` - how to choose a specific currency from it's name
###### encapsulates the cases of [ISO 4217 international standard for currency codes](https://www.iso.org/iso-4217-currency-codes.html)
`Currency` type is also a String backed enum that matches all available currency codes, while keeping a type safe / simple API for setting currencies (e.g. _.euro, .dollar or .brazilianReal_).

```swift
public enum Currency: String {
    case afghani = "AFN",
    algerianDinar = "DZD",
    argentinePeso = "ARS"
    //...
}
```

Note that defining currency does not always goes as planned, because the most part of the format generally changes accordingly to user locale. For example, setting .euro as currency but with default user locale (Brazil), has the euro's currency symbol with separators and remaining style as used in Brazil.

```swift
let formatter = CurrencyFormatter {
  $0.currency = .dollar
  $0.locale = CurrencyLocale.englishUnitedStates
}

let formattedString = formatter.string(from: 30.0) //$30.00
```

Therefor prioritize setting locale in case you have a custom setup, and only update currency whenever you want to have full control of the format configuration.

<a name="advancedsetup"/>

### Advanced setup

For those cases where your design requires a custom presentation don't worry because the formatter is heavily customizable.
For example decimals can be removed, maximum and minimum allowed values can be set, grouping size can be customized or even a hole new currency symbol can be defined. It is all up to you and your use case:

```swift
let formatter = CurrencyFormatter {
  $0.hasDecimals = false
  $0.maxValue = 999999
  $0.groupingSize = 2
  $0.groupingSeparator = ";"
  $0.currencySymbol = "💶"
}

let formattedString = formatter.string(from: 100000000) //💶99;99;99
```

<a name="uikit"/>

## UIKit

The UIKit library provides an _easy to use_ and _extendable_ `UITextFieldDelegate` that can be plugged to _any_ text field without the need to use a specific `UITextField` subclass 😉.

<a name="delegate"/>

## The `CurrencyTextFieldDelegate` - formatting user input as currency

`CurrencyTextFieldDelegate` is a type that inherits from `UITextFieldDelegate`, and provide a simple interface to configure how the inputs are configured as currency.

<a name="setting"/>

### Setting your text field to format the inputs
To start formatting user's input as currency, you need to initialize a `CurrencyTextFieldDelegate` instance passing in a currency formatter configured as you wish, and then set it as the text field's delegate.

```Swift
let currencyFormatter = CurrencyFormatter()
textFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
textFieldDelegate.clearsWhenValueIsZero = true

textField.delegate = textFieldDelegate
```

Just by setting a currency text field delegate object to your text field, with given formatter behavior, the user inputs are going to be formatted as expected.

<a name="passthrough"/>

### Using the passthrough delegate
The `passthroughDelegate` property availble on `CurrencyTextFieldDelegate` instances, can be used to 
listen and pottentially handle `UITextFieldDelegate events` that are sent to `CurrencyUITextFieldDelegate`.
It can be useful to intercept the delegate calls when `e.g.` for when tracking analytics events.

But be **aware** and **make sure** the implementation of this object _does not wrongly interfere with currency formatting_, `e.g.` by returning `false` on`textField(textField:shouldChangeCharactersIn:replacementString:)` no currency formatting is done.

```Swift
let currencyTextFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
currencyTextFieldDelegate.passthroughDelegate = selfTextFieldDelegateListener

textField.delegate = currencyTextFieldDelegate

// all call to `currencyTextFieldDelegate` `UITextField` delegate methods will be forwarded to `selfTextFieldDelegateListener`.
```

<a name="negative"/>

### Allowing users to input `negative values`
If you want your users to be able to input negative values just set textField's `keyboardType` to `.numbersAndPunctuation`, so whenever users tap the negative symbol it will be correctly presented and handled.

```Swift
textField.keyboardType = .numbersAndPunctuation

// users inputs "-3456"
// -R$ 34.56
```

<a name="properties"/>

## Properties available via `CurrencyFormatter` class
The following properties are available:

| PROPERTY                      | TYPE                                  | DESCRIPTION                                                                                                                                | 
|-------------------------------|---------------------------------------|--------------------------------------------|
| locale                        | `LocaleConvertible`                   | Locale of the currency                     |
| currency                      | `Currency`                            | Currency used to format                    |                                                                     
| currencySymbol                | `String`                              | String shown as currency symbol            |
| showCurrencySymbol            | `Bool`                                | Show/hide currency symbol                  |                                                                       
| minValue                      | `Double?`                             | The lowest number allowed as input         |                                                            
| maxValue                      | `Double?`                             | The highest number allowed as input        |
| decimalDigits                 | `Int`                                 | The number of decimal digits shown         |                
| hasDecimals                   | `Bool?`                               | Decimal digits are shown or not            |                        
| decimalSeparator              | `String`                              | Text used to separate the decimal digits   |
| currencyCode                  | `String`                              | Currency raw code value                    | 
| alwaysShowsDecimalSeparator   | `Bool`                                | Shows decimal separator even when there are no decimal digits | 
| groupingSize                  | `Int`                                 | The amount of grouped numbers              |
| secondaryGroupingSize         | `Int`                                 | The amount of grouped numbers after the first group  |
| groupingSeparator             | `String`                              | String that is shown between groups of numbers  |
| hasGroupingSeparator          | `Bool`                                | Adds separator between all group of numbers |
| maxIntegers                   | `Int`                                 | Maximum allowed number of integers         |
| maxDigitsCount                | `Int`                                 | Returns the maximum amount of digits (integers + decimals) | 
| zeroSymbol                    | `String`                              | Text shown when string's value is equal zero |

<a name="swiftui"/>

## SwiftUI

`CurrencyText` can also be used on `SwiftUI` via library introduced from the version `2.2.0`.
Due to limitations on `SwiftUI` SDKs, like defining the selected text range, the `UIKit` version of the library was brigded to `SwiftUI` via `UIViewRepresentable` - more on the limitations can be seen in the [implementation PR description](https://github.com/marinofelipe/CurrencyText/pull/78).
This may change in the future whenever the same functionality can be provided on vanilla `SwiftUI`.

<a name="currencytextfield"/>

### `CurrencyTextField` - how to configure and use it

`CurrencyTextField` is a `SwiftUI.View` that formats user inputs as currency based on a given `CurrencyTextFieldConfiguration`. 
The configuration holds a `CurrencyFormatter` with all format related setup, bindings for text, closures for reacting to key text field events, and a configuration block for setting the looks and behavior of the underlying `UITextField`.

```swift
var body: some View {
   CurrencyTextField(
      configuration: .init(
         placeholder: "Play with me...",
         text: $viewModel.data.text,
         unformattedText: $viewModel.data.unformatted,
         inputAmount: $viewModel.data.input,
         clearsWhenValueIsZero: true,
         formatter: .default,

         // The configuration block allows defining the looks 
         // and doing additional configuration to
         // the underlying UITextField.
         // This is needed given that for most `SwiftUI` 
         // modifiers there's no API for converting
         // back to UIKit - e.g. `Font` is not transformable to `UIFont`.
         textFieldConfiguration: { uiTextField in
            uiTextField.borderStyle = .roundedRect
            uiTextField.font = UIFont.preferredFont(forTextStyle: .body)
            uiTextField.textColor = .blue
            uiTextField.layer.borderColor = UIColor.red.cgColor
            uiTextField.layer.borderWidth = 1
            uiTextField.layer.cornerRadius = 4
            uiTextField.keyboardType = .numbersAndPunctuation
            uiTextField.layer.masksToBounds = true
         },
         onEditingChanged: { isEditing in
            if isEditing == false {
               // How to programmatically clear the text of CurrencyTextField:
               // The Binding<String>.text that is passed 
               // into CurrencyTextField.configuration can
               // manually cleared / updated with an empty String
               clearTextFieldText()
            }
         },
         onCommit: {
            // do something when users have committed their inputs
         }
      )
   )
}
```

For more details on specifics please refer to the code documentation and `SwiftUIExampleView` in the [ExampleApp](https://github.com/marinofelipe/CurrencyText/Example/Example/SwiftUI/SwiftUIExampleView.swift).

<a name="whyuikit"/>

###  Why do I have to import UIKit?

As a matter of context, the strategy of bridging the `UIKit` implementation to `SwiftUI` via `UIViewRepresentable` was chosen since there's no API yet for controlling a `SwiftUI.TextField`s `.selectedTextRange`, which is needed in `CurrencyText` for cases e.g. where the currency symbol is at the end and to provide the best user experience the text field has to auto update the `.selectedTextRange` to be before the currency symbol.

With that scenario in mind, and understanding that `CurrencyTextField` uses `UITextField` internally, the easiest way
to allow users to fully control the component was to give them access to the underlying `UITextField` instance so it could be configured and setup accordingly to their needs.

As alternative it was considered wrapping `UIKit.UITextField`s API, but that layer would be both extra work to develop and confusing for users, given that most of us (Apple third-party developers) are already familiar with  `UIKit.UITextField`'s API.
Besides that, the framework would never build for other platforms given that  

<a name="whyonlyios"/>

### Why is it only available for iOS?

Connected to what was mentioned above, the `SwiftUI` library currently bridges the `UIKit` implementation and that limits the framework on building only for iOS.

### Thoughts for the future

https://github.com/marinofelipe/CurrencyText/issues/79
