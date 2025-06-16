#!/bin/bash

echo "🍎 macOS Big Sur - Xcode 13.2.1 Installation Helper"
echo "=================================================="

# Check current macOS version
macos_version=$(sw_vers -productVersion)
echo "🖥️  Current macOS: $macos_version"

if [[ "$macos_version" < "12.0" ]]; then
    echo "✅ Compatible with Xcode 13.2.1 (iOS 15.2, Swift 5.5)"
    
    # Check if already installed
    if [ -d "/Applications/Xcode.app" ]; then
        echo "✅ Xcode is already installed!"
        xcode_version=$(mdls -name kMDItemVersion /Applications/Xcode.app | cut -d'"' -f2)
        echo "📱 Version: $xcode_version"
    else
        echo ""
        echo "📥 Installation Steps:"
        echo "1. 🌐 Opening Apple Developer Downloads..."
        echo "2. 🔐 Sign in with your Apple ID (free)"
        echo "3. 🔍 Search for 'Xcode 13.2.1'"
        echo "4. ⬇️  Download Xcode_13.2.1.xip (~10 GB)"
        echo "5. 📦 Double-click .xip to extract"
        echo "6. 📁 Move Xcode.app to /Applications/"
        echo "7. 🚀 Run: ./check_xcode.sh to verify"
        echo ""
        
        # Open downloads page
        open "https://developer.apple.com/download/all/"
        
        echo "⏳ After installation, run these commands:"
        echo "   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
        echo "   cd /Users/jo/swiftGoNC1"
        echo "   open Package.swift"
    fi
else
    echo "🔄 Consider upgrading macOS for latest Xcode support"
    echo "   Current: $macos_version"
    echo "   For Xcode 15+: macOS 13.0+ required"
fi

echo ""
echo "🎯 Our Cyberpunk GoNC app works great with Xcode 13.2.1!"
echo "   • iOS 15.2 SDK"
echo "   • Swift 5.5"
echo "   • Full SwiftUI 3.0 support"
