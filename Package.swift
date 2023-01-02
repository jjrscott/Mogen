// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mogen",
    products: [
        .plugin(name: "BuildTool", targets: ["BuildTool"]),
        .library(name: "Mogen", targets: ["Mogen"]),
        .executable(name: "Generator", targets: ["Generator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .executableTarget(
            name: "Generator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .plugin(
            name: "BuildTool",
            capability: .buildTool(),
            dependencies: [.target(name: "Generator")]
        ),
        .target(
            name: "Mogen",
            dependencies: []),
        .testTarget(
            name: "MogenTests",
            dependencies: ["Mogen"]),
    ]
)
