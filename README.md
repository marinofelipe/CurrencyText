UICurrencyTextField
======================================
[![Build Status](https://travis-ci.org/marinofelipe/UICurrencyTextField.svg?branch=master)](https://travis-ci.org/marinofelipe/UICurrencyTextField)
[![Coverage Status](https://coveralls.io/repos/github/marinofelipe/UICurrencyTextField/badge.svg?branch=chore%2Ffastlane_and_ci)](https://coveralls.io/github/marinofelipe/UICurrencyTextField?branch=chore%2Ffastlane_and_ci)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat" alt="Swift" /></a>

iOS currency text field written in Swift.  
<br>
Inputed numbers are automatically formatted to user Locale currency format.  
###### Language: English, Region: Brazil  
`R$ - brazilian reais`  
###### Language: English, Region: United States  
`$ - dollars`

## Requirements

* Swift >= 3

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

###### create an instance
```swift
let currencyTextField = UICurrencyTextField(frame: frame)
```  

###### set maximum integers digits - default is 7
```swift
currencyTextField.maximumIntegers = 4
```

###### enables autoclear - text will remove content when value is 0
```swift
currencyTextField.hasAutoclear = true
``` 
<br>
Please refer to `Example/` and download the demo for more detailed info.
The demo shows storyboard and programmatically methods.

## Contributing
Please feel free to contribute. Together we can make better reusable code.
Follow [Kanban project](https://github.com/marinofelipe/UICurrencyTextField/projects/1) or open new issues in your fork.
Every PR will be first validated by the CI service which will run the demo tests.
If you develop new features or solve any issues please verify if tests keep succeeding. Feel free to help adding more tets as well.

## License
UICurrencyTextField is released under the MIT license. [See LICENSE](https://github.com/marinofelipe/UICurrencyTextField/blob/master/LICENSE) for details.
