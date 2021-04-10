// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CurrencyText",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "CurrencyText",
            targets: [
                "CurrencyFormatter",
                "CurrencyUITextFieldDelegate"
            ]
        ),
        .library(
            name: "CurrencyFormatter",
            targets: [
                "CurrencyFormatter"
            ]
        )
    ],
    targets: [
        /// Can be imported and used to have access to `CurrencyFormatter`.
        /// Useful to `format and represent currency values`.
        .target(
            name: "CurrencyFormatter",
            dependencies: [],
            path: "Sources/Formatter"
        ),
        .testTarget(
            name: "CurrencyFormatterTests",
            dependencies: [
                .target(name: "CurrencyFormatter")
            ],
            path: "Tests/Formatter"
        ),

        /// Can be imported and used to have access to `CurrencyUITextFieldDelegate`.
        /// Useful to `format text field inputs as currency`, based on a the settings of a CurrencyFormatter.
        .target(
            name: "CurrencyUITextFieldDelegate",
            dependencies: [
                .target(name: "CurrencyFormatter")
            ],
            path: "Sources/UITextFieldDelegate"
        ),
        .testTarget(
            name: "CurrencyUITextFieldDelegateTests",
            dependencies: [
                .target(name: "CurrencyUITextFieldDelegate")
            ],
            path: "Tests/UITextFieldDelegate"
        )
    ]
)
