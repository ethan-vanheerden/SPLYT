// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "Mocking",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Mocking",
            targets: ["Mocking"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Caching"),
        .package(path: "../UserSettings"),
        .package(path: "../UserAuth")
    ],
    targets: [
        .target(
            name: "Mocking",
            dependencies: [
                "Core",
                "Caching",
                "UserSettings",
                "UserAuth"
            ]),
        .testTarget(
            name: "MockingTests",
            dependencies: [
                "Mocking"
            ]),
    ]
)
