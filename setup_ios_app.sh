#!/bin/bash

# Script to set up the Cyberpunk GoNC iOS app for development

echo "🎯 Setting up Cyberpunk GoNC iOS App..."

# Create iOS app structure
mkdir -p "CyberpunkGoNCApp"
cd "CyberpunkGoNCApp"

# Initialize as iOS app
cat > "Package.swift" << 'EOF'
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CyberpunkGoNCApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "CyberpunkGoNCApp",
            targets: ["CyberpunkGoNCApp"]
        )
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "CyberpunkGoNCApp",
            dependencies: [
                .product(name: "CyberpunkGoNC", package: "swiftGoNC1")
            ]
        )
    ]
)
EOF

# Create main app file
mkdir -p "Sources/CyberpunkGoNCApp"
cat > "Sources/CyberpunkGoNCApp/main.swift" << 'EOF'
import SwiftUI
import CyberpunkGoNC

@main
struct CyberpunkGoNCApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
EOF

echo "✅ iOS app structure created!"
echo "🚀 To open in Xcode:"
echo "   1. Open Xcode"
echo "   2. File -> Open -> Select the swiftGoNC1 folder"
echo "   3. Or use: open Package.swift"

cd ..
echo "📱 Ready for iOS development!"
