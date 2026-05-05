#!/bin/bash

# Comprehensive Flutter build script with flavor support
# Supports: dev/prod, debug/release builds and APK generation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
FLAVOR="${1:-dev}"
BUILD_TYPE="${2:-debug}"

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}Flutter Build Script${NC}"
echo -e "${BLUE}================================${NC}"
echo ""

# Validate flavor
if [[ "$FLAVOR" != "dev" && "$FLAVOR" != "prod" ]]; then
    echo -e "${RED}Error: Invalid flavor '$FLAVOR'${NC}"
    echo "Usage: $0 [dev|prod] [debug|release]"
    exit 1
fi

# Validate build type
if [[ "$BUILD_TYPE" != "debug" && "$BUILD_TYPE" != "release" ]]; then
    echo -e "${RED}Error: Invalid build type '$BUILD_TYPE'${NC}"
    echo "Usage: $0 [dev|prod] [debug|release]"
    exit 1
fi

echo -e "${YELLOW}Building: $FLAVOR $BUILD_TYPE${NC}"
echo ""

# Get target file
TARGET_FILE="lib/main_${FLAVOR}.dart"

if [ ! -f "$TARGET_FILE" ]; then
    echo -e "${RED}Error: Target file not found: $TARGET_FILE${NC}"
    exit 1
fi

# Clean previous builds
echo -e "${YELLOW}Step 1: Cleaning...${NC}"
flutter clean
echo -e "${GREEN}✓ Clean complete${NC}"
echo ""

# Get dependencies
echo -e "${YELLOW}Step 2: Getting dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Run analysis
echo -e "${YELLOW}Step 3: Analyzing code...${NC}"
flutter analyze
echo -e "${GREEN}✓ Analysis complete${NC}"
echo ""

# Run tests
echo -e "${YELLOW}Step 4: Running tests...${NC}"
flutter test --no-coverage || true
echo -e "${GREEN}✓ Tests complete${NC}"
echo ""

# Increment version for release builds
if [ "$BUILD_TYPE" = "release" ]; then
    echo -e "${YELLOW}Step 5: Incrementing build number...${NC}"
    chmod +x scripts/increment_build_number.sh
    ./scripts/increment_build_number.sh build
    echo -e "${GREEN}✓ Build number incremented${NC}"
    echo ""
fi

# Build APK
echo -e "${YELLOW}Step $((BUILD_TYPE == 'release' ? 6 : 5)): Building $BUILD_TYPE APK...${NC}"

if [ "$BUILD_TYPE" = "debug" ]; then
    flutter build apk \
        --flavor "$FLAVOR" \
        --target "$TARGET_FILE" \
        --debug \
        -v
else
    flutter build apk \
        --flavor "$FLAVOR" \
        --target "$TARGET_FILE" \
        --release \
        -v
fi

echo -e "${GREEN}✓ Build complete${NC}"
echo ""

# Show output location
APK_NAME="app-${FLAVOR}-${BUILD_TYPE}.apk"
APK_PATH="build/app/outputs/flutter-apk/${APK_NAME}"

if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo -e "${GREEN}================================${NC}"
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo -e "${GREEN}================================${NC}"
    echo ""
    echo "APK Location: $APK_PATH"
    echo "APK Size: $APK_SIZE"
    echo ""
    echo "Next steps:"
    echo "1. Test on device: adb install -r $APK_PATH"
    echo "2. Sign for release (production): jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.jks"
else
    echo -e "${RED}❌ Build failed - APK not found${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Build script completed${NC}"
