// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "UserSettings",
    products: [
        .library(
            name: "UserSettings",
            targets: ["UserSettings"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "UserSettings",
            dependencies: []),
        .testTarget(
            name: "UserSettingsTests",
            dependencies: ["UserSettings"]),
    ]
)
