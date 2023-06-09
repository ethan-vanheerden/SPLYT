// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExerciseCore",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ExerciseCore",
            targets: ["ExerciseCore"]),
    ],
    dependencies: [
        .package(path: "../Caching")
    ],
    targets: [
        .target(
            name: "ExerciseCore",
            dependencies: [
                "Caching"
            ]),
        .testTarget(
            name: "ExerciseCoreTests",
            dependencies: [
                "ExerciseCore"
            ]),
    ]
)
