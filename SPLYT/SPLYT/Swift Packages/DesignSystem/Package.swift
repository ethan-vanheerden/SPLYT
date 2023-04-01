// swift-tools-version: 5.7.1

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", exact: "1.11.0"),
        .package(path: "../ExerciseCore")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: [
                "ExerciseCore"
            ]),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: [
                "DesignSystem",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            exclude: [
                "Atomic/Particles/__Snapshots__/",
                "Atomic/Atoms/__Snapshots__/",
                "Atomic/Molecules/__Snapshots__/"
            ]),
    ]
)
