UICurrencyTextField 💶✏️
======================================
[![Build Status](https://travis-ci.org/marinofelipe/UICurrencyTextField.svg?branch=master)](https://travis-ci.org/marinofelipe/UICurrencyTextField)
[![Coverage Status](https://coveralls.io/repos/github/marinofelipe/UICurrencyTextField/badge.svg?branch=master)](https://coveralls.io/github/marinofelipe/UICurrencyTextField?branch=master)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat" alt="Swift" /></a>
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v1.0.1-blue.svg)](https://cocoapods.org/pods/UICurrencyTextField)
[![Platform](https://img.shields.io/cocoapods/p/UICurrencyTextField.svg?style=flat)]()
[![Twitter](https://img.shields.io/badge/twitter-@_marinofelipe-blue.svg?style=flat)](https://twitter.com/_marinofelipe)

Currency text field text formatter that doesn't require a specific subclass of UITextField. 🙌  
Feel free to adopt to your text fields and extend it when necessary as well.

### Currency format
By default the text is formatted accorndingly to user locale settings.

##### Language: english, region: Brazil  
`brazilian reais`  
`R$3.000,00`
##### Language: english, region: United States  
`dollars`  
`$3,000.00`

## Requirements

Swift >= 3

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

**Tested with `pod --version`: `1.0.0`**

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'UICurrencyTextField'
end
```

Replace `YOUR_TARGET_NAME` and then, in the `Podfile` directory, type:

```bash
$ pod install
```

## Usage

###### create an instance of CurrencyUITextFieldDelegate
```swift
let currencyDelegate = CurrencyUITextFieldDelegate()
```  

###### set maximum integers digits - default is 7
```swift
currencyDelegate.maxIntegers = 4
```

###### enables autoclear - text field text is removed when resigns as first responder with value of zero
```swift
currencyDelegate.hasAutoclear = true
``` 
<br>
Please refer to `Example/` and download the demo for more detailed info.

## Contributing
Cnntributions are always welcome. Please feel free to fork, follow [Kanban project](https://github.com/marinofelipe/UICurrencyTextField/projects/1) or open new issues.
Every PR will be first validated by the CI service which will run the demo tests.
If you develop new features or solve any issues please verify if tests keep succeeding. Feel free to help adding more tets as well.

## License
UICurrencyTextField is released under the MIT license. [See LICENSE](https://github.com/marinofelipe/UICurrencyTextField/blob/master/LICENSE) for details.
