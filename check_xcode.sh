#!/bin/bash

echo "🔍 Checking Xcode installation..."
echo ""

# Check if Xcode is installed
if [ -d "/Applications/Xcode.app" ]; then
    echo "✅ Xcode found in /Applications/"
    
    # Check Xcode version
    xcode_version=$(xcodebuild -version 2>/dev/null | head -n 1)
    if [ $? -eq 0 ]; then
        echo "📱 $xcode_version"
    else
        echo "⚠️  Xcode found but command line tools may need setup"
        echo "💡 Run: sudo xcode-select --install"
    fi
    
    # Check iOS Simulator availability
    echo ""
    echo "📲 Checking iOS Simulator..."
    simulator_path="/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
    if [ -d "$simulator_path" ]; then
        echo "✅ iOS Simulator available"
        echo "💡 To open: open -a Simulator"
    else
        echo "❌ iOS Simulator not found"
    fi
    
    echo ""
    echo "🚀 Ready to build iOS app!"
    echo "💡 Run: cd /Users/jo/swiftGoNC1 && open CyberpunkGoNC.xcodeproj"
    
else
    echo "❌ Xcode app not found in /Applications/"
    echo ""
    
    # Check macOS version for compatibility
    macos_version=$(sw_vers -productVersion)
    echo "🖥️  macOS Version: $macos_version"
    
    if [[ "$macos_version" < "15.3" ]]; then
        echo "⚠️  Your macOS version is too old for the latest Xcode"
        echo ""
        echo "📥 For macOS Big Sur (11.x), download Xcode 13.4.1:"
        echo "1. Go to developer.apple.com/download/all/"
        echo "2. Sign in with Apple ID (free developer account)"
        echo "3. Search for 'Xcode 13.4.1'"
        echo "4. Download the .xip file (~10 GB)"
        echo "5. Double-click to extract and move to /Applications/"
        echo ""
        echo "🌐 Opening Apple Developer Downloads..."
        open "https://developer.apple.com/download/all/"
    else
        echo "📥 To install latest Xcode:"
        echo "1. Search 'Xcode' in the Mac App Store"
        echo "2. Click 'Get' or 'Install'"
        echo "3. Wait for download (~11-15 GB)"
        echo "4. Run this script again to verify"
        echo ""
        open "macappstore://apps.apple.com/app/xcode/id497799835"
    fi
fi