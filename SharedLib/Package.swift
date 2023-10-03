// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "SharedLib",
    platforms: [.iOS(.v15), .macOS(.v11)],
    products: [
        .library(
            name: "SharedLib",
            targets: ["SharedLib"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SharedLib",
            dependencies: []
        ),
        .testTarget(
            name: "SharedLibTests",
            dependencies: ["SharedLib"]
        ),
    ]
)
