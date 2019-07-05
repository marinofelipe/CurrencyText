
[![Build Status](https://travis-ci.org/marinofelipe/CurrencyText.svg?branch=master)](https://travis-ci.org/marinofelipe/CurrencyText)
[![Coverage Status](https://coveralls.io/repos/github/marinofelipe/CurrencyText/badge.svg?branch=master)](https://coveralls.io/github/marinofelipe/CurrencyText?branch=master)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift" /></a>
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v2.0.2-blue.svg)](https://cocoapods.org/pods/CurrencyText)
[![Platform](https://img.shields.io/cocoapods/p/CurrencyText.svg?style=flat)]()
[![Twitter](https://img.shields.io/badge/twitter-@_marinofelipe-blue.svg?style=flat)](https://twitter.com/_marinofelipe)

<p align="center">
  <img src="images/logo.png" width="350" title="Currency Text's logo">
</p>

<p align="center" >⭐️ <b>Star me to follow the project </b> ⭐️<br>
</p>


CurrencyText is a lightweight library that allows to format text field inputs as currency. It provides a easy to use and extendable UITextFieldDelegate, so there's no need to use a specific UITextField subclass. _You can keep your text field subclasses_ and just make use of this nice custom delegate.

Its main core, the CurrencyFormatter class, can also be used _a part from text fields_ to format any value that can be monetary represented.

If you need to present currency text or allow users to input currency data, CurrencyText help you do it in a highly readable and configurable matter.

## Documentation

- [Introduction to `CurrencyFormatter`](#currencyformatter)
  - [Basic Setup](#basics)
  - [`Currency and locale` - easily defining style](#currencyandlocale)
  - [`Locale` - setting currency's locale](#locale)
  - [`Currency` - how to choose a specific currency from it's name](#currency)
  - [Advanced setup](#advancedsetup)
- [The `CurrencyTextFieldDelegate`](#delegate)
  - [Setting your text field to format the inputs](#setting)
  - [Allowing users to input `negative values`](#negative)
- [All properties of `CurrencyFormatter`](#properties)
- [Requirements](#requirements)
- [Installation](#installation)
- [Contributing](#contributing)
- [Copyright](#copyright)

<a name="currencyformatter"/>

## Introduction to `CurrencyFormatter`

CurrencyText is made upon `CurrencyFormatter`, which is an abstraction of number formatter with currency number style. It can be used alone or injected into a `CurrencyTextFieldDelegate` to auto format text field's inputs.

<a name="basics"/>

### Basic setup

The `CurrencyFormatter` encapsulates number formatter's currency properties.

Creating a `CurrencyFormatter` instance is pretty simple; you can use the readable builder pattern approach where the init class require a callback in which the self instance is passed, allowing you to configure your properties by keeping the code clean and readable ([Inspired by SwiftRichString](https://github.com/malcommac/SwiftRichString)):

```swift
let formatter = CurrencyFormatter {
  $0.currency = .euro
  // ... set any other attribute
}

let formattedString = formatter.string(from: 30.0) //€30.00
```

<a name="currencyandlocale"/>

### `Currency and locale` - easily defining formatting style

To define the currency style (symbol, formatting, separators) you must make use of `currency` and `locale` properties.
It's important to say that when these are not defined, the current user locale is automatically set, and so is the curency formatting. 
For example if the user Locale's is set to `pt_BR` (indentifier), the amount of 100 would be shown as `R$ 100,00`. What can be made by setting currency to brazilianReal and locale to portugueseBrazil when needed.

<a name="locale"/>

#### `Locale` - setting currency's locale
###### All locales were extracted from [jacobbubu - ioslocaleidentifiers](https://gist.github.com/jacobbubu/1836273)
The `CurrencyLocale` type wraps all available Locale identifiers in an enum type. 
Formatter's `locale` property can be set passing a common system Locale or one of CurrencyLocale's cases, such as .italian, .danish or .chinese. 
Note that you can define locale and compose it with a different currency of your choice, what is going to change generally only the currency symbol.

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
The `Currency` type contains the currency codes as enum cases raw values, what makes it easier to set up the formatter with the currency that you want, such as .euro, .dollar, .brazilianReal.

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

<a name="advancedsetup"/>

### Advanced setup

For those cases where your design requires a custom presentation you are able to heavily customize the formatter.
We can remove decimals, set a maximum allowed value, customize grouping size or even set a hole new currency symbol. It is all up to you.

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

<a name="delegate"/>

## The `CurrencyTextFieldDelegate` - formatting user input as currency

This project started as a way to format user inputs as currency. In the old days it used to be a custom UITextField class, but we changed it to work acting only as a custom delegate, without needing to force users to use an specific UITextField class.
`CurrencyTextFieldDelegate` class comes in hand to act formatting inputs respecting the setup of its currency formatter.

<a name="setting"/>

### Setting your text field to format the inputs
To start formatting your user's numeric text as currency you need to initialize a `CurrencyTextFieldDelegate`, configure it with a formatter with you want to, and then set it as the text field's delegate.

```Swift
let currencyFormatter = CurrencyFormatter()
textFieldDelegate = CurrencyUITextFieldDelegate(formatter: currencyFormatter)
textFieldDelegate.clearsWhenValueIsZero = true

textField.delegate = textFieldDelegate
```

Just by setting a currency text field delegate object to your text field, with given formatter behaviour, the user inputs are going to be formatted as expected.

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

<a name="requirements"/>

## Requirements

CurrencyText is compatible with Swift 3.x.
Only `iOS 8.0+` is supported.
_But we are planning to support other apple OS's soon._

<a name="installation"/>

## Installation

<a name="cocoapods" />

### Install via CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Swift and Objective-C Cocoa projects. It has over 57 thousand libraries and is used in over 3 million apps. CocoaPods can help you scale your projects elegantly.

#### Installing CocoaPods
```bash
$ sudo gem install cocoapods
```

#### Integrating CurrencyText

To integrate CurrencyText into your Xcode project using CocoaPods, specify it in your `Podfile`:

**Tested with `pod --version`: `2.0.2`**

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

##### For those who doesn't need `UICurrencyTextField`, you are able to donwload only the subspec `CurrencyText/Formatter`.

<a name="carthage" />

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.
_Carthage support is comming soon. If you want to help, please contribute :smile._

<a name="contributing" />

## Contributing
Contributions and feedbacks are always welcome. Please feel free to fork, follow, open issues and pull requests. The issues, milestones, and what we are currently working on can be seen in the main [Project](https://github.com/marinofelipe/CurrencyText/projects/1).

## Special Thanks
To [@malcommac](https://github.com/malcommac) for his awesome work with SwiftRichString and SwfitDate, that inspired some readme details, "CurrencyLocale" enum and the init with handler callback.
Also to [myanalysis](https://github.com/myanalysis) for contributing so much by finding issues and giving nice suggestions.

## Copyright
CurrencyText is released under the MIT license. [See LICENSE](https://github.com/marinofelipe/CurrencyText/blob/master/LICENSE) for details.

Felipe Marino: [felipemarino91@gmail.com](mailto:felipemarino91@gmail.com), [@_marinofelipe](https://twitter.com/_marinofelipe)
