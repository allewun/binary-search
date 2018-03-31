// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "binary-search",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "binary-search",
            dependencies: ["Core", "Commander"]
        ),
        .target(name: "Core")
    ]
)
