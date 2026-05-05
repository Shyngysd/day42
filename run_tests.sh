#!/bin/bash

# Test runner script for Flutter application

echo "================================"
echo "Flutter Testing Suite"
echo "================================"
echo ""

echo "Step 1: Getting dependencies..."
flutter pub get
echo "✅ Dependencies installed"
echo ""

echo "Step 2: Running analyzer..."
flutter analyze
if [ $? -eq 0 ]; then
    echo "✅ Analyzer passed"
else
    echo "❌ Analyzer found issues"
    exit 1
fi
echo ""

echo "Step 3: Checking code format..."
dart format --set-exit-if-changed lib test integration_test
if [ $? -eq 0 ]; then
    echo "✅ Code format OK"
else
    echo "❌ Code needs formatting. Run: dart format lib test integration_test"
    exit 1
fi
echo ""

echo "Step 4: Running unit tests..."
flutter test test/ --coverage
if [ $? -eq 0 ]; then
    echo "✅ Unit tests passed"
else
    echo "❌ Unit tests failed"
    exit 1
fi
echo ""

echo "Step 5: Running integration tests..."
flutter test integration_test/app_test.dart --verbose
if [ $? -eq 0 ]; then
    echo "✅ Integration tests passed"
else
    echo "❌ Integration tests failed"
    exit 1
fi
echo ""

echo "================================"
echo "✅ All tests passed!"
echo "================================"
echo ""

# Coverage report
if [ -f coverage/lcov.info ]; then
    echo "Coverage report generated at: coverage/lcov.info"
fi
