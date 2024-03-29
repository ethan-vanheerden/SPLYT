// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "DesignShowcase",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DesignShowcase",
            targets: ["DesignShowcase"]),
    ],
    dependencies: [
        .package(path: "../DesignSystem"),
        .package(path: "../Core"),
        .package(path: "../ExerciseCore")
    ],
    targets: [
        .target(
            name: "DesignShowcase",
            dependencies: [
                "DesignSystem",
                "Core",
                "ExerciseCore"
            ]),
        .testTarget(
            name: "DesignShowcaseTests",
            dependencies: [
                "DesignShowcase"
            ]),
    ]
)
