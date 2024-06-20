// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Packages",
    dependencies: [

        // MARK: First Party Dependencies

        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.2"),
    ]
)
