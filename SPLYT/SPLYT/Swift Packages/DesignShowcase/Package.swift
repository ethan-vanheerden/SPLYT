// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignShowcase",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DesignShowcase",
            targets: ["DesignShowcase"]),
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "DesignShowcase",
            dependencies: [
                "DesignSystem",
                "Core"
            ]),
        .testTarget(
            name: "DesignShowcaseTests",
            dependencies: [
                "DesignShowcase"
            ]),
    ]
)
