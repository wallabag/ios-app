// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "WallabagKit",
    platforms: [.iOS(.v15), .macOS(.v11)],
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
