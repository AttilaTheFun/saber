// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Packages",
    dependencies: [

        // MARK: First Party Dependencies

        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),

        // MARK: Third Party Dependencies

        .package(url: "https://github.com/sideeffect-io/AsyncExtensions.git", from: "0.5.2"),
    ]
)
