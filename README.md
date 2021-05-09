[![Build status](https://github.com/marinofelipe/CurrencyText/actions/workflows/ci.yml/badge.svg)
[![Coverate status](https://codecov.io/gh/marinofelipe/CurrencyText/branch/main/graph/badge.svg?token=K4VOS8NH7A)](https://codecov.io/gh/marinofelipe/CurrencyText)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat" alt="Swift" /></a>
[![Platform](https://img.shields.io/cocoapods/p/CurrencyText.svg?style=flat)]()
[![Swift Package Manager](https://rawgit.com/jlyonsmith/artwork/master/SwiftPackageManager/swiftpackagemanager-compatible.svg)](https://swift.org/package-manager/)
[![CocoaPods Compatible](https://img.shields.io/badge/pod-v2.2.0-blue.svg)](https://cocoapods.org/pods/CurrencyText)
[![Twitter](https://img.shields.io/badge/twitter-@_marinofelipe-blue.svg?style=flat)](https://twitter.com/_marinofelipe)

<p align="center">
  <img src="images/logo.png" width="350" title="Currency Text's logo">
</p>

CurrencyText provides lightweight libraries for formating text field text as currency, available for both `UIKit` and `SwiftUI`.

Its main core, the `CurrencyFormatter` class, can also be used _a part from text fields_ to format any value that can be monetary represented.

If you need to present currency formatted text or allow users to input currency data, `CurrencyText` is going to help you do it in a readable and configurable matter.

## Documentation

For details on how to use `CurrencyText` libraries please refer to [the docs](/documentation/Documentation.md).

## Installation

### Swift Package Manager

To install it using Swift Package Manager, just add this repository through Xcode built-in `Swift Packages`, or by manually adding it to your `Package.swift` Package's dependencies:

```swift
dependencies: [
    .package(
    	url: "https://github.com/marinofelipe/CurrencyText.git", 
    	.upToNextMinor(from: .init(2, 1, 0)
    )
]

.target(
    name: "MyTarget",
    dependencies: [
    	// Can be imported to consume the formatter in insolation
        .target(name: "CurrencyFormatter"),

        // UIKit library - Provide access to "CurrencyFormatter" and "CurrencyUITextFieldDelegate" targets
        .target(name: "CurrencyText"),

        // SwiftUI library - Provide access to "CurrencyFormatter" and "CurrencyTextField" targets
        .target(name: "CurrencyTextSwiftUI")
    ],
    ...
)
```

### Install via CocoaPods

To integrate `CurrencyText` using CocoaPods, specify it, one or more of its sub-specs in your `Podfile`:

```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
     pod 'CurrencyText'

     # sub-specs

     # pod 'CurrencyText/CurrencyFormatter'
     # pod 'CurrencyText/CurrencyUITextField'
     # pod 'CurrencyText/CurrencyTextField'
end
```

## Contributing
Contributions and feedbacks are always welcome. Please feel free to fork, follow, open issues and pull requests. The issues, milestones, and what we are currently working on can be seen in the main [Project](https://github.com/marinofelipe/CurrencyText/projects/1).

## Special Thanks
To [@malcommac](https://github.com/malcommac) for his awesome work with [SwiftRichString](https://github.com/malcommac/SwiftRichString) and [SwfitDate](https://github.com/malcommac/SwiftDate), that inspired me when creating this project.
Also to [myanalysis](https://github.com/myanalysis) for contributing so much by finding issues and giving nice suggestions.

## Copyright
CurrencyText is released under the MIT license. [See LICENSE](https://github.com/marinofelipe/CurrencyText/blob/master/LICENSE) for details.

Felipe Marino: [felipemarino91@gmail.com](mailto:felipemarino91@gmail.com), [@_marinofelipe](https://twitter.com/_marinofelipe)