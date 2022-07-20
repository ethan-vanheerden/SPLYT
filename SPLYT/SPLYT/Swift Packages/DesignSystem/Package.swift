// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "DesignSystem",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", exact: "1.9.0")
    ],
    targets: [
        .target(
            name: "DesignSystem",
            dependencies: []),
        .testTarget(
            name: "DesignSystemTests",
            dependencies: [
                "DesignSystem",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            exclude: ["Atomic/Atoms/__Snapshots__/"]), // Add more folders here once we have snapshots for those
    ]
)
