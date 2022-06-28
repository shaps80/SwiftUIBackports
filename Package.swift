// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIBackports",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "SwiftUIBackports",
            targets: ["SwiftUIBackports"]
        ),
    ],
    targets: [
        .target(name: "SwiftUIBackports")
    ]
)
