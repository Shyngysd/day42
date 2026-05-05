#!/bin/bash

# Update build number in pubspec.yaml
# Usage: ./scripts/increment_build_number.sh [major|minor|patch|build]
# Default: build (increments only build number)

set -e

INCREMENT_TYPE="${1:-build}"

# Read current version from pubspec.yaml
PUBSPEC_FILE="pubspec.yaml"

if [ ! -f "$PUBSPEC_FILE" ]; then
    echo "Error: $PUBSPEC_FILE not found"
    exit 1
fi

# Extract version line (e.g., "version: 1.0.0+5")
CURRENT_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | sed 's/version: //' | xargs)

echo "Current version: $CURRENT_VERSION"

# Parse version string "1.0.0+5"
VERSION_PART=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# Parse semantic version
MAJOR=$(echo "$VERSION_PART" | cut -d'.' -f1)
MINOR=$(echo "$VERSION_PART" | cut -d'.' -f2)
PATCH=$(echo "$VERSION_PART" | cut -d'.' -f3)

# Calculate new version based on increment type
case "$INCREMENT_TYPE" in
    major)
        NEW_MAJOR=$((MAJOR + 1))
        NEW_VERSION="$NEW_MAJOR.0.0+1"
        ;;
    minor)
        NEW_MINOR=$((MINOR + 1))
        NEW_VERSION="$MAJOR.$NEW_MINOR.0+1"
        ;;
    patch)
        NEW_PATCH=$((PATCH + 1))
        NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH+1"
        ;;
    build|*)
        NEW_BUILD=$((BUILD_NUMBER + 1))
        NEW_VERSION="$MAJOR.$MINOR.$PATCH+$NEW_BUILD"
        ;;
esac

echo "New version: $NEW_VERSION"

# Update pubspec.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
else
    # Linux
    sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC_FILE"
fi

echo "✓ Updated $PUBSPEC_FILE"
echo "Version updated: $CURRENT_VERSION → $NEW_VERSION"
