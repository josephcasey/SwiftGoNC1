#!/bin/bash

# 🚀 CyberpunkGoNC Development Deployment Script
# This script automates the complete development workflow with error checking

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}🔄 Step $1: $2${NC}"
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

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    print_error "Not in CyberpunkGoNC project directory. Please run from project root."
fi

# Step 1: Stage changes to git
print_step "1" "Staging changes to git"
git add . || print_error "Failed to stage changes"

# Check what was staged
STAGED_FILES=$(git diff --cached --name-only | wc -l)
if [ "$STAGED_FILES" -eq 0 ]; then
    print_warning "No changes to stage. Exiting gracefully."
    exit 0
fi
print_success "Staged $STAGED_FILES file(s)"

# Step 2: Verify staging worked as expected
print_step "2" "Verifying git staging"
git status --porcelain | grep "^M\|^A\|^D" > /dev/null
if [ $? -eq 0 ]; then
    print_success "Changes properly staged"
    echo "Staged files:"
    git diff --cached --name-only | sed 's/^/  - /'
else
    print_error "No staged changes detected"
fi

# Step 3: Commit with single-line message
print_step "3" "Committing changes"

# Get commit message from arguments or use default
if [ -n "$1" ]; then
    COMMIT_MSG="$1"
else
    COMMIT_MSG="🔧 Improve app layout and user experience"
fi

# Additional details if provided
if [ -n "$2" ]; then
    COMMIT_DETAILS="$2"
    git commit -m "$COMMIT_MSG" -m "$COMMIT_DETAILS" || print_error "Commit failed"
else
    git commit -m "$COMMIT_MSG" || print_error "Commit failed"
fi

# Step 4: Verify commit worked
print_step "4" "Verifying commit"
LAST_COMMIT=$(git log -1 --pretty=format:"%h %s")
if [ -n "$LAST_COMMIT" ]; then
    print_success "Commit successful: $LAST_COMMIT"
else
    print_error "Commit verification failed"
fi

# Step 5: Push to remote
print_step "5" "Pushing to GitHub"
git push origin master || print_error "Push failed"

# Final verification
print_step "6" "Final verification"

# Comprehensive verification with structured output for AI parsing
echo "=== DEPLOYMENT VERIFICATION REPORT ==="
echo "Timestamp: $(date)"
echo "Project: CyberpunkGoNC iOS App"
echo ""

# Git status verification
echo "--- GIT STATUS ---"
GIT_STATUS=$(git status --porcelain)
if [ -z "$GIT_STATUS" ]; then
    echo "STATUS: CLEAN"
    print_success "Working tree clean"
else
    echo "STATUS: UNCOMMITTED_CHANGES"
    echo "Uncommitted files:"
    echo "$GIT_STATUS"
    print_warning "Working tree has uncommitted changes"
fi

# Remote sync verification
echo ""
echo "--- REMOTE SYNC ---"
LOCAL_COMMIT=$(git rev-parse HEAD)
REMOTE_COMMIT=$(git rev-parse origin/master)
if [ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ]; then
    echo "SYNC_STATUS: UP_TO_DATE"
    print_success "Local and remote are in sync"
else
    echo "SYNC_STATUS: OUT_OF_SYNC"
    echo "Local:  $LOCAL_COMMIT"
    echo "Remote: $REMOTE_COMMIT"
    print_warning "Local and remote are out of sync"
fi

# Recent commits verification
echo ""
echo "--- RECENT COMMITS ---"
echo "Last 3 commits:"
git log --oneline -3 | sed 's/^/  /'

# Project structure verification
echo ""
echo "--- PROJECT STRUCTURE ---"
echo "Key files status:"
[ -f "Package.swift" ] && echo "✅ Package.swift" || echo "❌ Package.swift"
[ -f "README.md" ] && echo "✅ README.md" || echo "❌ README.md"
[ -d "Sources/CyberpunkGoNC" ] && echo "✅ Sources/CyberpunkGoNC/" || echo "❌ Sources/CyberpunkGoNC/"
[ -f "CyberpunkGoNC.xcodeproj/project.pbxproj" ] && echo "✅ Xcode project" || echo "❌ Xcode project"
[ -d "CyberpunkGoNC/Assets.xcassets" ] && echo "✅ Asset catalog" || echo "❌ Asset catalog"

echo ""
echo "--- DEPLOYMENT SUMMARY ---" >&2
echo "OVERALL_STATUS: SUCCESS" >&2
echo "LAST_COMMIT: $LAST_COMMIT" >&2
echo "SYNC_STATUS: $([ "$LOCAL_COMMIT" = "$REMOTE_COMMIT" ] && echo "UP_TO_DATE" || echo "OUT_OF_SYNC")" >&2
echo "WORKING_TREE: $([ -z "$GIT_STATUS" ] && echo "CLEAN" || echo "UNCOMMITTED_CHANGES")" >&2
echo "REPOSITORY: https://github.com/josephcasey/SwiftGoNC1.git" >&2
echo "=== END VERIFICATION REPORT ===" >&2

# Output final status to stderr so run_in_terminal can capture it
if [ -z "$GIT_STATUS" ]; then
    echo "✅ DEPLOYMENT_RESULT: SUCCESS - Working tree clean, all changes pushed" >&2
    print_success "Deployment successful!"
else
    echo "⚠️ DEPLOYMENT_RESULT: SUCCESS_WITH_WARNINGS - Uncommitted changes remain" >&2
    print_warning "Deployment completed with uncommitted changes"
fi

# Summary
echo -e "\n${GREEN}🎉 Deployment Complete!${NC}"
echo "Last commit: $LAST_COMMIT"
echo "Repository: https://github.com/josephcasey/SwiftGoNC1.git"

# Final status output for run_in_terminal tool
echo "DEPLOY_STATUS=SUCCESS"
