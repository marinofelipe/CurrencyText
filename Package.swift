// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CurrencyText",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "CurrencyTextSwiftUI",
            targets: [
                "CurrencyFormatter",
                "CurrencyTextField"
            ]
        ),
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
    dependencies: [
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            .upToNextMinor(
                from: .init(1, 8, 2)
            )
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
        ),

        /// Can be imported and used to have access to `CurrencyTextField`, a `SwiftUI` text field that
        /// sanitizes user input based on a given `CurrencyFormatter`.
        .target(
            name: "CurrencyTextField",
            dependencies: [
                .target(name: "CurrencyFormatter"),
                .target(name: "CurrencyUITextFieldDelegate")
            ],
            path: "Sources/SwiftUI"
        ),
        .testTarget(
            name: "CurrencyTextFieldTests",
            dependencies: [
                .target(name: "CurrencyTextField"),
                .target(name: "CurrencyTextFieldTestSupport")
            ],
            path: "Tests/SwiftUI"
        ),
        .testTarget(
            name: "CurrencyTextFieldSnapshotTests",
            dependencies: [
                .target(name: "CurrencyTextField"),
                .target(name: "CurrencyTextFieldTestSupport"),
                .product(
                    name: "SnapshotTesting",
                    package: "SnapshotTesting"
                )
            ],
            path: "Tests/SwiftUISnapshotTests",
            resources: [
                .copy("__Snapshots__/CurrencyTextFieldSnapshotTests/test.germanEuro.png"),
                .copy("__Snapshots__/CurrencyTextFieldSnapshotTests/test.noDecimals.png"),
                .copy("__Snapshots__/CurrencyTextFieldSnapshotTests/test.withDecimals.png"),
                .copy("__Snapshots__/CurrencyTextFieldSnapshotTests/test.withMinMaxValues.png"),
                .copy("__Snapshots__/CurrencyTextFieldSnapshotTests/test.yenJapanese.png"),
                .copy("__Snapshots__/CurrencyTextFieldSnapshotTests/testWithCustomTextFiledConfiguration.1.png")
            ]
        ),

        /// Common `CurrencyTextField test helpers` that can be imported by all CurrencyText test targets.
        .target(
            name: "CurrencyTextFieldTestSupport",
            dependencies: [
                .target(name: "CurrencyTextField"),
                .target(name: "CurrencyFormatter")
            ],
            path: "Sources/CurrencyTextFieldTestSupport"
        )
    ]
)
