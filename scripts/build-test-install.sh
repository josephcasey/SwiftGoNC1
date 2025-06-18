#!/bin/bash

# Build, Test & Install Script for CyberpunkGoNC iOS App
# Handles Swift package build, testing, Xcode build, and simulator installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Project paths
PROJECT_DIR="/Users/jo/swiftGoNC1"
XCODE_PROJECT="CyberpunkGoNC.xcodeproj"
SCHEME="CyberpunkGoNC"
SIMULATOR_NAME="iPhone 13"
BUNDLE_ID="com.cyberpunk.gonc"

# Function to print step headers
print_step() {
    echo -e "${CYAN}🔄 Step $1: $2${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Start the build-test-install process
echo -e "${BLUE}🚀 Starting Build-Test-Install Pipeline${NC}"
echo "Project: CyberpunkGoNC iOS App"
echo "Target: ${SIMULATOR_NAME} Simulator"
echo ""

# Step 1: Swift Package Build
print_step "1" "Building Swift Package"
if swift build 2>/dev/null; then
    print_success "Swift package build completed"
else
    print_error "Swift package build failed - check code for compilation errors"
fi

# Step 2: Swift Package Tests
print_step "2" "Running Swift Package Tests"
if swift test 2>/dev/null; then
    print_success "All Swift package tests passed"
else
    print_error "Swift package tests failed - fix failing tests before continuing"
fi

# Step 3: Xcode Build for Simulator
print_step "3" "Building Xcode project for iOS Simulator"
BUILD_OUTPUT=$(xcodebuild -scheme "$SCHEME" -destination "platform=iOS Simulator,name=$SIMULATOR_NAME" build 2>&1)
BUILD_EXIT_CODE=$?

if [ $BUILD_EXIT_CODE -eq 0 ]; then
    print_success "Xcode build completed successfully"
else
    print_error "Xcode build failed:\n$BUILD_OUTPUT"
fi

# Step 4: Get App Path
print_step "4" "Locating built app bundle"
APP_PATH=$(find ~/Library/Developer/Xcode/DerivedData -path "*/Build/Products/Debug-iphonesimulator/CyberpunkGoNC.app" -not -path "*/Index/*" | head -1)
if [ -z "$APP_PATH" ]; then
    print_error "Could not find CyberpunkGoNC.app bundle"
fi
print_success "Found app at: $APP_PATH"

# Step 5: Boot Simulator (if not already running)
print_step "5" "Ensuring iOS Simulator is running"
SIMULATOR_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep "Booted" | head -1 | sed 's/.*(\([^)]*\)).*/\1/')

if [ -z "$SIMULATOR_ID" ]; then
    print_warning "Simulator not running, booting $SIMULATOR_NAME..."
    SIMULATOR_ID=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | head -1 | sed 's/.*(\([^)]*\)).*/\1/')
    xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || true
    sleep 3
    print_success "Simulator booted"
else
    print_success "Simulator already running"
fi

# Step 6: Install App on Simulator
print_step "6" "Installing app on simulator"
if xcrun simctl install booted "$APP_PATH" 2>/dev/null; then
    print_success "App installed successfully"
else
    print_error "Failed to install app on simulator"
fi

# Step 7: Launch App
print_step "7" "Launching CyberpunkGoNC app"
if xcrun simctl launch booted "$BUNDLE_ID" 2>/dev/null; then
    print_success "App launched successfully"
else
    print_error "Failed to launch app"
fi

# Step 8: Final Verification
print_step "8" "Verifying app installation"
APP_INSTALLED=$(xcrun simctl listapps booted | grep "$BUNDLE_ID" | wc -l)
if [ "$APP_INSTALLED" -gt 0 ]; then
    print_success "App verification complete"
else
    print_error "App verification failed - app not found on simulator"
fi

# Step 9: Git Status for README Updates
print_step "9" "Providing git information for README updates"
echo ""
echo -e "${CYAN}=== GIT STATUS FOR README UPDATES ===${NC}"
echo -e "${YELLOW}Current Date: $(date '+%b %d, %Y')${NC}"
echo ""

# Get the most recent commit info
echo -e "${CYAN}--- RECENT COMMITS (for README updates) ---${NC}"
git log --oneline -5 --decorate --color=always

echo ""
echo -e "${CYAN}--- PREVIOUS FEATURE COMMIT INFO ---${NC}"
LAST_COMMIT=$(git log --oneline -1 --format="%h %s")
echo "Last commit: $LAST_COMMIT"

# Show any uncommitted changes that would need documenting
if ! git diff --quiet || ! git diff --cached --quiet; then
    echo ""
    echo -e "${YELLOW}--- UNCOMMITTED CHANGES ---${NC}"
    echo "Note: There are uncommitted changes that may need README documentation"
    git status --porcelain
fi

echo ""
echo -e "${CYAN}--- README UPDATE GUIDANCE ---${NC}"
echo "• Use current date: $(date '+%b %d, %Y')"
echo "• Previous feature commit for reference: $(git log --oneline -1 --format='%h')"
echo "• When documenting new features, add commit hash AFTER deployment"
echo -e "${CYAN}=== END GIT STATUS ===${NC}"
print_success "Git information ready for README updates"

# Success summary
echo ""
echo -e "${GREEN}🎉 Build-Test-Install Complete!${NC}"
echo -e "${CYAN}Summary:${NC}"
echo "  ✅ Swift package built and tested"
echo "  ✅ Xcode project built for iOS Simulator"
echo "  ✅ App installed on $SIMULATOR_NAME"
echo "  ✅ CyberpunkGoNC launched and ready for testing"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  📱 Test the app functionality on simulator"
echo "  🚀 Run deploy-changes.sh when ready to commit changes"

# Output structured results for parsing
echo ""
echo "BUILD_STATUS=SUCCESS"
echo "TEST_STATUS=PASSED"
echo "INSTALL_STATUS=SUCCESS"
echo "APP_LAUNCHED=true"
echo "SIMULATOR=$SIMULATOR_NAME"
echo "BUILD_TEST_INSTALL_SUCCESS=true"
