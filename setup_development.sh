#!/bin/bash

echo "🛠️  Setting up Cyberpunk GoNC iOS Development Environment"
echo "========================================================="

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode is not installed. Please install Xcode from the App Store first."
    exit 1
fi

# Check if command line tools are installed
if ! xcode-select -p &> /dev/null; then
    echo "📦 Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "⏳ Please complete the Command Line Tools installation and run this script again."
    exit 1
fi

echo "✅ Xcode Command Line Tools are installed"

# Check Swift version
echo "🔍 Checking Swift version..."
swift --version

# Try to build the project
echo "🔨 Building Cyberpunk GoNC project..."
if swift build; then
    echo "✅ Project builds successfully!"
else
    echo "⚠️  Build failed. This is expected if running on macOS without iOS SDK."
    echo "   The project is designed for iOS and should be opened in Xcode."
fi

# Check if iOS Simulator is available
echo "📱 Checking iOS Simulator availability..."
if xcrun simctl list devices | grep -q "iPhone"; then
    echo "✅ iOS Simulator is available"
else
    echo "⚠️  iOS Simulator may not be available"
fi

echo ""
echo "🚀 Setup Complete! Next steps:"
echo "1. Open Xcode: open Package.swift"
echo "2. Select iOS device/simulator from the scheme menu"
echo "3. Press Cmd+R to build and run"
echo ""
echo "📱 The app will launch in the iOS Simulator with:"
echo "   • Interactive district map"
echo "   • Touch-based district selection"
echo "   • Gang territory visualization"
echo "   • Cyberpunk UI theme"
echo ""
