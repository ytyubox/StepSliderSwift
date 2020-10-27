// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StepSliderSwift",
    platforms: [.iOS(SupportedPlatform.IOSVersion.v14)],
    products: [
        .library(
            name: "StepSlider",
            targets: ["StepSlider"]),
    ],
    targets: [
        .target(
            name: "StepSlider",
            dependencies: []),
        .testTarget(
            name: "StepSliderTests",
            dependencies: ["StepSlider"],
            exclude:["snapshots"]),
    ]
)
