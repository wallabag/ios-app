// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SharedLib",
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
