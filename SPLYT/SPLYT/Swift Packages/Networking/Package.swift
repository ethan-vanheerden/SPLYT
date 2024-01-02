// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "Networking",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]),
    ],
    dependencies: [
        .package(path: "../UserAuth"),
        .package(path: "../Mocking")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: [
                "UserAuth"
            ]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: [
                "Networking",
                "Mocking"
            ]),
    ]
)
