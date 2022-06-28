// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIBackports",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
//        .macOS(.v10_15),
//        .watchOS(.v6)
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
