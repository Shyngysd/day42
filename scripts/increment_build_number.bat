@echo off
REM Update build number in pubspec.yaml for Windows
REM Usage: increment_build_number.bat [major|minor|patch|build]
REM Default: build (increments only build number)

setlocal enabledelayedexpansion

set INCREMENT_TYPE=%1
if "%INCREMENT_TYPE%"=="" set INCREMENT_TYPE=build

set PUBSPEC_FILE=pubspec.yaml

if not exist "%PUBSPEC_FILE%" (
    echo Error: %PUBSPEC_FILE% not found
    exit /b 1
)

REM Extract version using findstr and for loop
for /f "tokens=2" %%A in ('findstr "^version:" "%PUBSPEC_FILE%"') do (
    set CURRENT_VERSION=%%A
)

echo Current version: %CURRENT_VERSION%

REM Parse version string "1.0.0+5"
for /f "tokens=1,2 delims=+" %%A in ("%CURRENT_VERSION%") do (
    set VERSION_PART=%%A
    set BUILD_NUMBER=%%B
)

if "%BUILD_NUMBER%"=="" set BUILD_NUMBER=1

REM Parse semantic version "1.0.0"
for /f "tokens=1,2,3 delims=." %%A in ("%VERSION_PART%") do (
    set MAJOR=%%A
    set MINOR=%%B
    set PATCH=%%C
)

REM Calculate new version
if /i "%INCREMENT_TYPE%"=="major" (
    set /a NEW_MAJOR=%MAJOR% + 1
    set NEW_VERSION=!NEW_MAJOR!.0.0+1
) else if /i "%INCREMENT_TYPE%"=="minor" (
    set /a NEW_MINOR=%MINOR% + 1
    set NEW_VERSION=%MAJOR%.!NEW_MINOR!.0+1
) else if /i "%INCREMENT_TYPE%"=="patch" (
    set /a NEW_PATCH=%PATCH% + 1
    set NEW_VERSION=%MAJOR%.%MINOR%.!NEW_PATCH!+1
) else (
    set /a NEW_BUILD=%BUILD_NUMBER% + 1
    set NEW_VERSION=%MAJOR%.%MINOR%.%PATCH%+!NEW_BUILD!
)

echo New version: %NEW_VERSION%

REM Update pubspec.yaml using PowerShell
powershell -Command "(Get-Content '%PUBSPEC_FILE%') -replace '^version: .*', 'version: %NEW_VERSION%' | Set-Content '%PUBSPEC_FILE%'"

echo ✓ Updated %PUBSPEC_FILE%
echo Version updated: %CURRENT_VERSION% ^→ %NEW_VERSION%
