# 🌃 Cyberpunk GoNC - iOS App

A native iOS implementation of the Cyberpunk Gang of Night City (GoNC) territory control game.

## 🎯 Features

- **Native iOS Interface** - No web dependencies, no segfaults
- **Touch-Optimized** - Designed for iPhone/iPad with proper gesture recognition
- **Cyberpunk Aesthetic** - Dark theme with neon colors and custom fonts
- **Authentic Night City Map** - High-quality background with district overlays
- **Interactive District Map** - Tap districts to select and view gang information
- **Real-time Game State** - Live updates of gang territories and unit positions
- **Gang Management** - View detailed gang information and territory control

## 🚀 Quick Start

### Method 1: Open in Xcode (Recommended)

1. Open **Xcode**
2. Go to **File → Open**
3. Navigate to and select the `swiftGoNC1` folder
4. Or double-click `Package.swift` to open directly

### Method 2: Command Line

```bash
cd /Users/jo/swiftGoNC1
open Package.swift
```

## 📱 App Structure

This project uses a **Swift Package + Xcode Project** hybrid structure:

```
swiftGoNC1/
├── Package.swift                    # Swift Package manifest
├── Sources/CyberpunkGoNC/          # Swift Package source files (CANONICAL)
│   ├── CyberpunkGoNCApp.swift      # 📦 Main SwiftUI app definition
│   ├── ContentView.swift          # Root view with navigation
│   ├── GameState.swift            # Game logic and data models
│   ├── DistrictMapView.swift      # Interactive map with authentic Night City background
│   └── GameControlsView.swift     # Game UI and controls
├── App/                           # Xcode project entry point
│   └── iOSApp.swift               # 📱 iOS app wrapper (imports package)
├── CyberpunkGoNC/                 # Xcode-specific assets
│   └── Assets.xcassets/           # App icons and Night City map image
└── Tests/CyberpunkGoNCTests/      # Unit tests
    └── CyberpunkGoNCTests.swift
```

### 🔍 Why Two `CyberpunkGoNCApp.swift` Files?

**1. `/Sources/CyberpunkGoNC/CyberpunkGoNCApp.swift`** 📦
- **Purpose**: Swift Package library containing the actual app logic
- **Contains**: Main `App` struct, views, and game functionality
- **Used by**: Both the iOS app and unit tests
- **Think of it as**: The reusable core library

**2. `/App/iOSApp.swift`** 📱
- **Purpose**: Xcode iOS app entry point that imports the package
- **Contains**: Minimal wrapper that imports and launches the core app
- **Used by**: iOS Simulator and device deployment
- **Think of it as**: The platform-specific launcher

This structure allows the core game logic to be:
- ✅ **Testable** as a Swift Package
- ✅ **Reusable** across different platforms
- ✅ **Deployable** as a native iOS app

## 🎮 How to Use

1. **Launch the app** in Xcode iOS Simulator or on device
2. **Tap any district** on the map to select it
3. **View gang information** in the bottom panel
4. **Tap "GANG INFO"** to see detailed territory breakdown
5. **Use touch gestures** to interact with the map

## 🔧 Development

### Running in Simulator

1. Open in Xcode
2. Select "iPhone 15 Pro" (or preferred simulator)
3. Click the **Play** button or press `Cmd+R`

### Running on Device

1. Connect your iPhone/iPad
2. Select your device from the target menu
3. Ensure you have a valid Apple Developer account
4. Click **Play** to build and install

## 📊 Game Data

The app includes initial game state with:

- **6 Districts**: Watson, Westbrook, City Center, Heywood, Pacifica, Santo Domingo
- **6 Gangs**: Maelstrom, Tyger Claws, Voodoo Boys, Valentinos, Animals, Scavs
- **4 Unit Types**: Solo, Techie, Netrunner, Drone
- **District Boundaries**: Accurate polygon coordinates for touch detection

## 🎨 Cyberpunk Design Elements

- **Color Scheme**: Cyan highlights, neon gang colors, dark backgrounds
- **Typography**: Monospace "Courier" font for terminal aesthetic
- **UI Elements**: Glowing borders, opacity effects, animated selections
- **Responsive**: Adapts to different screen sizes and orientations

## 🔄 Advantages Over Streamlit Version

✅ **No Segfaults** - Native iOS, no Python/PIL compatibility issues  
✅ **Touch Optimized** - Proper gesture recognition for mobile  
✅ **Offline Capable** - No web server required  
✅ **App Store Ready** - Can be distributed through official channels  
✅ **Better Performance** - Native Swift vs web-based solution  
✅ **iOS Features** - Haptics, notifications, background processing  

## 🛠 Recent Improvements

### Enhanced Deployment Workflow (Latest)
- **📝 Streamlined Process** - Refined two-step deployment: AI updates README, script handles git operations
- **🔍 Smart Output Parsing** - Agent rules now parse deploy script output instead of running duplicate git commands
- **⚡ Efficient Verification** - Script provides comprehensive git status, avoiding redundant terminal interactions
- **🎯 Focused Automation** - Removed build/test verification from deploy script (handled separately with AI)

### Layout Optimization
- **🎨 Fixed Map Resizing Issue** - Map now maintains consistent size when district info panel expands
- **📱 Better Screen Space Usage** - Removed redundant "NIGHT CITY Gang Territory Control" header
- **🗺️ Optimized Map Position** - Map positioned higher on screen for better visibility
- **📊 Enhanced District Info** - More space allocated for gang unit details and territory information

### Night City Map Integration
- **🗺️ Authentic Background** - Integrated high-quality Night City map (2.6MB) from original game assets
- **🎯 Perfect Scaling** - Proper 2:3 aspect ratio maintains map proportions
- **🔄 Smart Fallback** - Graceful handling of missing images with cyberpunk-styled placeholder

## 🛠 Next Steps

1. **✅ Authentic Night City Map** - Successfully integrated high-quality background image
2. **Implement Game Mechanics** - Unit movement, combat, turn progression
3. **Add Animations** - Smooth transitions and visual feedback
4. **Save/Load** - Persistent game state storage
5. **Multiplayer** - Network gameplay capabilities

## 📝 Development Notes

- Built with **SwiftUI** for modern iOS development
- Uses **ObservableObject** for reactive game state management
- Implements **proper touch handling** with coordinate scaling
- **No external dependencies** - pure Swift/iOS solution
- **Preview support** for rapid UI development

---

*Ready to jack into Night City! 🕶️⚡*
