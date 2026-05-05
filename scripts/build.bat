@echo off
REM Comprehensive Flutter build script with flavor support for Windows
REM Supports: dev/prod, debug/release builds and APK generation

setlocal enabledelayedexpansion

set FLAVOR=%1
set BUILD_TYPE=%2

if "%FLAVOR%"=="" set FLAVOR=dev
if "%BUILD_TYPE%"=="" set BUILD_TYPE=debug

echo ================================
echo Flutter Build Script
echo ================================
echo.

if not "%FLAVOR%"=="dev" if not "%FLAVOR%"=="prod" (
    echo Error: Invalid flavor '%FLAVOR%'
    echo Usage: %0 [dev^|prod] [debug^|release]
    exit /b 1
)

if not "%BUILD_TYPE%"=="debug" if not "%BUILD_TYPE%"=="release" (
    echo Error: Invalid build type '%BUILD_TYPE%'
    echo Usage: %0 [dev^|prod] [debug^|release]
    exit /b 1
)

echo Building: %FLAVOR% %BUILD_TYPE%
echo.

set TARGET_FILE=lib\main_%FLAVOR%.dart

if not exist "%TARGET_FILE%" (
    echo Error: Target file not found: %TARGET_FILE%
    exit /b 1
)

REM Clean previous builds
echo Step 1: Cleaning...
flutter clean
echo ✓ Clean complete
echo.

REM Get dependencies
echo Step 2: Getting dependencies...
flutter pub get
echo ✓ Dependencies installed
echo.

REM Run analysis
echo Step 3: Analyzing code...
flutter analyze
echo ✓ Analysis complete
echo.

REM Run tests
echo Step 4: Running tests...
flutter test --no-coverage
echo ✓ Tests complete
echo.

REM Increment version for release builds
if /i "%BUILD_TYPE%"=="release" (
    echo Step 5: Incrementing build number...
    call scripts\increment_build_number.bat build
    echo ✓ Build number incremented
    echo.
)

REM Build APK
echo Step 5: Building %BUILD_TYPE% APK...

if /i "%BUILD_TYPE%"=="debug" (
    flutter build apk ^
        --flavor %FLAVOR% ^
        --target %TARGET_FILE% ^
        --debug ^
        -v
) else (
    flutter build apk ^
        --flavor %FLAVOR% ^
        --target %TARGET_FILE% ^
        --release ^
        -v
)

if errorlevel 1 (
    echo Build failed
    exit /b 1
)

echo ✓ Build complete
echo.

REM Show output location
set APK_NAME=app-%FLAVOR%-%BUILD_TYPE%.apk
set APK_PATH=build\app\outputs\flutter-apk\%APK_NAME%

if exist "%APK_PATH%" (
    echo ================================
    echo ✓ Build successful!
    echo ================================
    echo.
    echo APK Location: %APK_PATH%
    echo.
    echo Next steps:
    echo 1. Test on device: adb install -r %APK_PATH%
    echo 2. Sign for release ^(production^): jarsigner -verbose
    exit /b 0
) else (
    echo ❌ Build failed - APK not found
    exit /b 1
)
