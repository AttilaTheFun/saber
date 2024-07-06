// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Packages",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.2"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "510.0.2"),
    ]
)
