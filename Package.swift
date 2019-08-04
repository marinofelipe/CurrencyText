// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CurrencyText",
    products: [
        .library(
            name: "CurrencyText",
            targets: ["Formatter", "TextField"]),
    ],
    targets: [
        .target(
            name: "Formatter",
            dependencies: [],
		  path: "Sources/Formatter"),
        .target(
            name: "TextField",
            dependencies: ["Formatter"],
		  path: "Sources/TextField"),
        .testTarget(
            name: "Tests",
            dependencies: ["Formatter", "TextField"],
		  path: "Tests"),
    ]
)
