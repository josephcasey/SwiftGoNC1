// swift-tools-version: 5.5
import PackageDescription

let package = Package(
    name: "CyberpunkGoNC",
    platforms: [
        .iOS(.v15),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "CyberpunkGoNC",
            targets: ["CyberpunkGoNC"]),
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .target(
            name: "CyberpunkGoNC",
            dependencies: []),
        .testTarget(
            name: "CyberpunkGoNCTests",
            dependencies: ["CyberpunkGoNC"]),
    ]
)
