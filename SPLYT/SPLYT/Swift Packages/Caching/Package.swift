// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Caching",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Caching",
            targets: ["Caching"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Caching",
            dependencies: [
            ]),
        .testTarget(
            name: "CachingTests",
            dependencies: [
                "Caching"
            ]),
    ]
)

