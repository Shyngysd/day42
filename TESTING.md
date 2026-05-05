# Testing Guide

This document describes the comprehensive testing setup for the Flutter application.

## Overview

The project includes:
- **Unit Tests** with mocked services using `mocktail`
- **Integration Tests** with full user flow scenarios
- **Fake API Client** with fixed JSON responses (no real network calls)
- **Dependency Injection** via `get_it` for easy test configuration
- **GitHub Actions CI/CD** for automated test execution

## Project Structure

```
lib/
├── models/              # Data models (User, Item)
├── data/               
│   ├── api_client.dart           # Abstract API interface
│   ├── http_api_client.dart      # Real HTTP implementation
│   ├── fake_api_client.dart      # Fake implementation for testing
│   └── user_repository.dart      # Business logic layer
├── screens/
│   ├── login_screen.dart         # Login UI
│   └── home_screen.dart          # Items list UI
└── service_locator.dart          # Dependency injection setup

test/
└── user_repository_test.dart     # Unit tests with mocks

integration_test/
└── app_test.dart                 # Full integration tests

.github/
└── workflows/
    └── tests.yml                 # GitHub Actions CI/CD
```

## Running Tests Locally

### Unit Tests

Run all unit tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/user_repository_test.dart
```

Run tests with coverage:
```bash
flutter test --coverage
lcov --list coverage/lcov.info  # View coverage report
```

### Integration Tests

Run integration tests (desktop):
```bash
flutter test integration_test/app_test.dart
```

Run on Android emulator:
```bash
flutter test integration_test/app_test.dart --target=integration_test/app_test.dart
```

## Test Coverage Details

### Unit Tests (`test/user_repository_test.dart`)

Tests the `UserRepository` with mocked `ApiClient` using `mocktail`:

- ✅ `login` stores user and calls API
- ✅ `login` throws on invalid credentials
- ✅ `getItems` returns items for logged-in user
- ✅ `getItems` throws when not logged in
- ✅ `addItem` creates new item for logged-in user
- ✅ `addItem` throws when not logged in
- ✅ `logout` clears user and calls API
- ✅ `logout` throws when not logged in

**Key Points:**
- Uses `MockApiClient` to mock external HTTP calls
- No real network requests
- Tests business logic in isolation
- Validates state management

### Integration Tests (`integration_test/app_test.dart`)

Tests complete user flows with `FakeApiClient`:

**Test 1: Complete Flow**
1. Login with valid credentials
2. View items list (initial items displayed)
3. Add a new item
4. Verify item appears in list
5. Logout
6. Verify returned to login screen

**Test 2: Invalid Login**
- Login with wrong credentials
- Verify error message displayed
- Verify still on login screen

**Key Points:**
- Uses `FakeApiClient` with fixed responses
- Tests full UI interaction flow
- No real network calls
- Tests navigation between screens

## Fake API Client

The `FakeApiClient` implements the `ApiClient` interface with:

**Fixed Credentials:**
- Email: `test@example.com`
- Password: `password123`

**Pre-loaded Data:**
- User ID: `user_1`
- 2 initial items with IDs `item_1` and `item_2`

**Features:**
- Simulates network delays (milliseconds)
- Returns realistic error messages
- Supports adding new items to in-memory storage
- No external dependencies required

```dart
// Setup with fake client for testing
setupServiceLocator(mockApiClient: FakeApiClient());
```

## Dependency Injection

The `get_it` package manages dependencies:

### Production Setup
```dart
setupServiceLocator();  // Uses real HttpApiClient
```

### Testing Setup
```dart
resetServiceLocator();
setupServiceLocator(mockApiClient: MockApiClient());  // Or FakeApiClient
```

### In Tests

```dart
final repository = getIt<UserRepository>();
// Repository uses mocked/fake API client
```

## GitHub Actions CI/CD

The workflow (`.github/workflows/tests.yml`) runs on:
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

### CI Steps

1. **Setup Flutter** - Installs Flutter 3.19.0
2. **Get Dependencies** - `flutter pub get`
3. **Analyze Code** - `flutter analyze` (lint checks)
4. **Format Check** - Ensures consistent code style
5. **Unit Tests** - Runs with coverage report
6. **Coverage Upload** - Sends to Codecov
7. **Integration Tests** - Runs on Linux desktop

### Local CI Simulation

To test the workflow locally:

```bash
# Install act (GitHub Actions runner simulator)
# https://github.com/nektos/act

# Run the workflow
act push

# Or just run the commands manually
flutter analyze
dart format --set-exit-if-changed lib test integration_test
flutter test --coverage
flutter test integration_test/app_test.dart --verbose
```

## Verifying No Real Network Calls

The testing setup ensures no real network requests:

1. **Unit Tests**: Mock `ApiClient` interface
2. **Integration Tests**: `FakeApiClient` with in-memory storage
3. **No hardcoded URLs**: Real client uses localhost only
4. **All endpoints stubbed**: Fake client covers all API operations

To verify:
```bash
# Run tests with network monitoring
flutter test test/user_repository_test.dart --verbose
# Should see no network activity

# Check integration test runs locally
flutter test integration_test/app_test.dart
# Should complete without any network errors
```

## Adding New Tests

### Adding Unit Test

```dart
test('new test case', () async {
  // Arrange
  when(() => mockApiClient.someMethod()).thenAnswer((_) async => result);
  
  // Act
  final result = await repository.someMethod();
  
  // Assert
  expect(result, expectedValue);
  verify(() => mockApiClient.someMethod()).called(1);
});
```

### Adding Integration Test

```dart
testWidgets('new integration test', (WidgetTester tester) async {
  setupServiceLocator(mockApiClient: FakeApiClient());
  app.main();
  await tester.pumpAndSettle();
  
  // Test UI interactions
  await tester.tap(find.byKey(const Key('button')));
  await tester.pumpAndSettle();
  
  expect(find.text('expected text'), findsOneWidget);
});
```

## Troubleshooting

### Tests fail with "Not mocked" error
- Ensure `mocktail` is imported: `import 'package:mocktail/mocktail.dart';`
- Mock all methods used: `when(() => mock.method()).thenAnswer(...)`

### Integration tests hang
- Increase timeout: `flutter test integration_test/app_test.dart --timeout=120s`
- Check for missing `await tester.pumpAndSettle()`

### CI fails with "Flutter not found"
- The workflow uses `subosito/flutter-action@v2`
- Check Flutter version in `.github/workflows/tests.yml` matches your development environment

## Best Practices

1. **Always mock external services** - Never make real network calls in tests
2. **Use FakeApiClient for integration tests** - Faster and more reliable than mocking
3. **Keep unit tests focused** - Test one responsibility per test
4. **Use meaningful test names** - Should describe the test scenario
5. **Clean up in tearDown** - Properly dispose resources
6. **Test error cases** - Not just the happy path
7. **Run tests before committing** - Use `git hooks` if needed

## References

- [Flutter Testing](https://flutter.dev/docs/testing)
- [mocktail Documentation](https://pub.dev/packages/mocktail)
- [get_it Package](https://pub.dev/packages/get_it)
- [GitHub Actions](https://docs.github.com/en/actions)
