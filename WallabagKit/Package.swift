// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WallabagKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "WallabagKit",
            targets: ["WallabagKit"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WallabagKit",
            dependencies: []
        ),
        .testTarget(
            name: "WallabagKitTests",
            dependencies: ["WallabagKit"]
        ),
    ]
)
