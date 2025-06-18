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

## 🛠 Recent Improvements

### Codified Commit ID Timing Pattern (Jun 18, 2025)
- **📝 README Update Logic Fix** - Corrected commit ID timing to only add hashes to previous entries, not current ones
- **⏰ Retroactive Hash Assignment** - New entries remain without commit hash until subsequent deployment cycle
- **📋 Workflow Documentation** - Updated deploy-workflow.mdc with clear commit ID timing rules and examples
- **🎯 Logical Deployment Pattern** - Current push gets documented, previous push gets its hash added retroactively
- **📊 Clear Examples** - Added before/after examples showing proper README update sequence
- **🔧 Consistency Rules** - Codified that commit hashes are only known AFTER commits are made, so updates happen in next cycle

### Enhanced Build-Test-Install with Git Interrogation (Jun 18, 2025) - `503eeba`
- **📊 Git Status Integration** - Added comprehensive git information display at end of build-test-install pipeline
- **📅 Date Standardization** - Provides current date in correct format for README updates
- **🔍 Commit History Analysis** - Shows recent commits and previous feature commit hash for documentation reference
- **⚡ Workflow Optimization** - README updates now use git interrogation output instead of manual git commands
- **📝 Documentation Guidance** - Clear instructions on proper README formatting and commit hash handling
- **🎯 Deployment Workflow Integration** - Updated deploy-workflow.mdc to incorporate git information from build step

### Enhanced District Intelligence Panel (Jun 18, 2025) - `cff2e7e`
- **📊 Comprehensive Unit Analytics** - District info now shows total unit count and gang dominance ratios
- **🎯 Strategic Intelligence** - Clear display of which gang dominates each district with unit count comparison  
- **🎮 Enhanced Unit Breakdown** - Vertical layout with tactical roles (ASSAULT, SUPPORT, CYBER, RECON) for each unit type
- **🔧 Visual Unit Indicators** - Unit dots with gang colors and type-specific border colors, enhanced with tactical symbols
- **📈 Smart Gang Sorting** - Gangs automatically sorted by unit count within each district for strategic clarity
- **⚡ Improved Information Hierarchy** - Better visual organization with clear count displays and tactical role descriptions

### Smart Unit Placement & Drone Enhancements (Jun 18, 2025)
- **🧠 Intelligent Unit Positioning** - Implemented size-aware placement algorithm that prevents unit overlaps
- **📏 Dynamic Spacing** - Radius calculation considers unit sizes (16px standard, 8px drones) with 4px minimum spacing
- **🚁 Enhanced Drone Design** - Drones now half-size (8px) with green borders matching techie connection
- **⚡ Scalable Algorithm** - Works with any unit count, automatically expands radius to maintain clear visibility
- **🎯 Collision Prevention** - Mathematical placement ensures no overlapping regardless of district unit density

### Enhanced Unit Visualization (Jun 18, 2025) - `45bb47c`
- **🎨 Unit-Action Disc Color Mapping** - Unit borders now match corresponding action disc colors for clear visual connection
- **🎯 Strategic Clarity** - Orange borders for SOLOS, green for TECHIES, blue for NETRUNNERS, gray for DRONES
- **🎮 Improved Gameplay UX** - Gang colors preserved in unit centers while borders indicate available actions
- **⚡ Visual Harmony** - Perfect integration between unit types and action disc system for intuitive strategy

### Development Pipeline Automation (Jun 18, 2025) - `0cfc102`
- **🔧 Build-Test-Install Script** - Comprehensive automation for Swift build, testing, Xcode compilation, and simulator deployment
- **🎯 Separated Concerns** - build-test-install.sh handles development testing, deploy-changes.sh handles git operations
- **⚡ 8-Step Pipeline** - Automated: package build → tests → Xcode build → app location → simulator boot → install → launch → verify
- **🧹 Clean UI** - Removed redundant district name text overlays (names visible in Night City map graphic)
- **📱 Streamlined Testing** - One command deploys updated app to simulator for immediate testing

### Interactive Action Discs (Jun 18, 2025) - `bf1a08b`
- **🎮 Action Disc System** - Added 6 interactive action disc types positioned on right side of map
- **🎯 Game Mechanics** - ACTIVATE SOLOS, TECHIES, NETRUNNERS, BUILD HIDEOUT, UPGRADE CARDS, WILD actions
- **🎨 Cyberpunk Styling** - Color-coded discs with authentic game aesthetics and touch interaction
- **⚡ Dynamic Selection** - Real-time selection feedback with visual highlighting
- **📱 Optimized Layout** - Strategic positioning alongside Night City map for enhanced gameplay

### Enhanced Deployment Workflow (Jun 17, 2025) - `d5464b9`
- **📝 Streamlined Process** - Refined two-step deployment: AI updates README, script handles git operations
- **🔍 Smart Output Parsing** - Agent rules now parse deploy script output instead of running duplicate git commands
- **⚡ Efficient Verification** - Script provides comprehensive git status, avoiding redundant terminal interactions
- **🎯 Focused Automation** - Removed build/test verification from deploy script (handled separately with AI)

### Layout Optimization (Jun 17, 2025) - `9af1e41`
- **🎨 Fixed Map Resizing Issue** - Map now maintains consistent size when district info panel expands
- **📱 Better Screen Space Usage** - Removed redundant "NIGHT CITY Gang Territory Control" header
- **🗺️ Optimized Map Position** - Map positioned higher on screen for better visibility
- **📊 Enhanced District Info** - More space allocated for gang unit details and territory information

### Night City Map Integration (Jun 17, 2025) - `f8bdb54`
- **🗺️ Authentic Background** - Integrated high-quality Night City map (2.6MB) from original game assets
- **🎯 Perfect Scaling** - Proper 2:3 aspect ratio maintains map proportions
- **🔄 Smart Fallback** - Graceful handling of missing images with cyberpunk-styled placeholder

---

*Ready to jack into Night City! 🕶️⚡*
