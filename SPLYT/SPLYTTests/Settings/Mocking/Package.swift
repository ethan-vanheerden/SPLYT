// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Mocking",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "Mocking",
            targets: ["Mocking"]),
    ],
    dependencies: [
        .package(path: "../Core")
    ],
    targets: [
        .target(
            name: "Mocking",
            dependencies: [
                "Core"
            ]),
        .testTarget(
            name: "MockingTests",
            dependencies: [
                "Mocking"
            ]),
    ]
)
