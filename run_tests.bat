@echo off
REM Test runner script for Flutter application (Windows)

echo ================================
echo Flutter Testing Suite
echo ================================
echo.

echo Step 1: Getting dependencies...
flutter pub get
echo ✓ Dependencies installed
echo.

echo Step 2: Running analyzer...
flutter analyze
if errorlevel 1 goto analyzer_failed
echo ✓ Analyzer passed
echo.

echo Step 3: Checking code format...
dart format --set-exit-if-changed lib test integration_test
if errorlevel 1 goto format_failed
echo ✓ Code format OK
echo.

echo Step 4: Running unit tests...
flutter test test/ --coverage
if errorlevel 1 goto unit_tests_failed
echo ✓ Unit tests passed
echo.

echo Step 5: Running integration tests...
flutter test integration_test/app_test.dart --verbose
if errorlevel 1 goto integration_tests_failed
echo ✓ Integration tests passed
echo.

echo ================================
echo ✓ All tests passed!
echo ================================
echo.

if exist "coverage\lcov.info" (
    echo Coverage report generated at: coverage\lcov.info
)

exit /b 0

:analyzer_failed
echo ✗ Analyzer found issues
exit /b 1

:format_failed
echo ✗ Code needs formatting. Run: dart format lib test integration_test
exit /b 1

:unit_tests_failed
echo ✗ Unit tests failed
exit /b 1

:integration_tests_failed
echo ✗ Integration tests failed
exit /b 1
