// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StepSliderSwift",
    platforms: [.iOS(.v12), .macOS(.v10_13
    )],
    products: [
        .library(
            name: "StepSliderCore",
            targets: ["StepSliderCore"]),
        .library(
            name: "StepSlider",
            targets: ["StepSlider"]),
    ],
    targets: [
        .target(name: "StepSliderCore"),
        .target(
            name: "StepSlider",
            dependencies: ["StepSliderCore"]),
        .testTarget(
            name: "StepSliderTests",
            dependencies: ["StepSlider"]),
        .testTarget(
            name: "StepSliderCoreTests",
            dependencies: ["StepSliderCore"])
    ]
)
