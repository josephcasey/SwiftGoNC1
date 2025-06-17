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
git status --porcelain
if [ $? -eq 0 ] && [ -z "$(git status --porcelain)" ]; then
    print_success "Working tree clean - deployment successful!"
else
    print_warning "Working tree may have uncommitted changes"
fi

# Summary
echo -e "\n${GREEN}🎉 Deployment Complete!${NC}"
echo "Last commit: $LAST_COMMIT"
echo "Repository: https://github.com/josephcasey/SwiftGoNC1.git"
