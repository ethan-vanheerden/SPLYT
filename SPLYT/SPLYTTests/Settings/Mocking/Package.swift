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
