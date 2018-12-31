CurrencyText 💶✏️
======================================
[![Build Status](https://travis-ci.org/marinofelipe/UICurrencyTextField.svg?branch=master)](https://travis-ci.org/marinofelipe/UICurrencyTextField)
[![Coverage Status](https://coveralls.io/repos/github/marinofelipe/CurrencyText/badge.svg?branch=master)](https://coveralls.io/github/marinofelipe/CurrencyText?branch=master)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" alt="Swift" /></a>
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.0.2-blue.svg)](https://cocoapods.org/pods/CurrencyText)
[![Platform](https://img.shields.io/cocoapods/p/CurrencyText.svg?style=flat)]()
[![Twitter](https://img.shields.io/badge/twitter-@_marinofelipe-blue.svg?style=flat)](https://twitter.com/_marinofelipe)

CurrencyText has a custom text field delegate that formats inputs as currency. It doesn't require a specific subclass of UITextField. 🙌  
Just adopt it to your text fields and extend it when necessary.

#### Important
~~UICurrencyTextField~~ was deprecated in favor of `CurrencyText`.

## Requirements

Swift >= 3

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

**Tested with `pod --version`: `1.0.2`**

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
pod 'CurrencyText'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

## How to use
As said before, an instance of `CurrencyUITextFieldDelegate` must be adopted as your currency text field's delegate.
By default it allows a maximum of 7 integers and 2 decimals, shows decimal separator and do not autoclears the text when resigning first responder. However if needed you can customize it as you wish.

### Basics

##### Set as textField's UITextFieldDelegate
```swift
let currencyDelegate = CurrencyUITextFieldDelegate()
textField.delegate = currencyDelegate
```  

##### Configuring
```swift
public class CurrencyUITextFieldDelegate: NSObject {

  public var numberFormatter = NumberFormatter()

  /// if true text field is cleared when resign as first responder with value = 0
  public var hasAutoclear: Bool = false

  /// define maximum amount of integer numbers
  public var maxIntegers: Int? {
    didSet {
      guard let maxIntegers = maxIntegers else { return }
      numberFormatter.maximumIntegerDigits = maxIntegers
    }
  }
}
```  
```swift
currencyDelegate.maxIntegers = 4
currencyDelegate.hasAutoclear = true
```

### Currency format
By default the text is formatted accordingly to user locale settings.

#### Language: english, region: Brazil  
`brazilian reais`  
`R$3.000,00`
#### Language: english, region: United States  
`dollars`  
`$3,000.00`

#### Custom currency
To format with a different currency you can change the delegate's `numberFormater` locale.

```swift
delegate.numberFormatter.locale = Locale(identifier: "en_US")
```

#### Advanced set up
If you want to customize more, you are able to create your own number formatter.

```swift
var numberFormatter = NumberFormatter()
numberFormatter.locale = Locale(identifier: "en_US")
numberFormatter.minimumFractionDigits = 1
numberFormatter.maximumFractionDigits = 1
numberFormatter.minimumIntegerDigits = 3
numberFormatter.alwaysShowsDecimalSeparator = false

delegate.numberFormatter = numberFormatter
```

<br>
Please refer to the demo project at `Example/` if you want to take a deeper look.

## Contributing
Contributions are always welcome. Please feel free to fork, follow [Kanban project](https://github.com/marinofelipe/CurrencyText/projects/1) or open new issues.
Every PR will be first validated by the CI service which will run the demo tests.
If you develop new features or solve any issues please verify if tests keep succeeding.

## License
CurrencyText is released under the MIT license. [See LICENSE](https://github.com/marinofelipe/CurrencyText/blob/master/LICENSE) for details.
