# Flutter Testing Implementation

Complete testing setup for Flutter application with unit tests, integration tests, mocked services, and CI/CD.

## Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run Tests

**All Tests:**
```bash
# Windows
.\run_tests.bat

# macOS/Linux
chmod +x run_tests.sh
./run_tests.sh
```

**Unit Tests Only:**
```bash
flutter test test/
```

**Unit Tests with Coverage:**
```bash
flutter test --coverage
```

**Integration Tests:**
```bash
flutter test integration_test/app_test.dart
```

### 3. View Test Results

Check logs in output or view coverage:
```bash
# macOS/Linux
lcov --list coverage/lcov.info

# Online coverage tool
open http://localhost:8080  # After starting a coverage server
```

## Project Structure

### Models
- `lib/models/user.dart` - User model with serialization
- `lib/models/item.dart` - Item model with serialization

### Data Layer
- `lib/data/api_client.dart` - Abstract API interface
- `lib/data/http_api_client.dart` - Real HTTP implementation
- `lib/data/fake_api_client.dart` - Fake implementation for testing
- `lib/data/user_repository.dart` - Business logic layer

### UI Layer
- `lib/screens/login_screen.dart` - Login page with email/password
- `lib/screens/home_screen.dart` - Items list page with add functionality

### Testing
- `lib/service_locator.dart` - Dependency injection with get_it
- `test/user_repository_test.dart` - Unit tests with mocktail
- `integration_test/app_test.dart` - Full user flow integration tests
- `.github/workflows/tests.yml` - GitHub Actions CI/CD

## Key Features

✅ **Mocked Services** - Uses mocktail/mockito for testing  
✅ **No Real Network Calls** - FakeApiClient with fixed responses  
✅ **Dependency Injection** - get_it for easy test configuration  
✅ **Integration Tests** - Full user flow: login → list → add → logout  
✅ **CI/CD Workflow** - GitHub Actions automated testing  
✅ **Code Analysis** - Flutter analyzer and format checks  
✅ **Coverage Reporting** - Track test coverage with Codecov  

## Test Scenarios

### Unit Tests
- Login with valid/invalid credentials
- Get items when logged in/out
- Add items for authenticated users
- Logout and clear user state

### Integration Tests
1. **Complete Flow**: Login → View Items → Add Item → Logout
2. **Invalid Login**: Verify error handling

## Testing Credentials

Use these credentials in tests:
- **Email**: `test@example.com`
- **Password**: `password123`

## CI/CD Pipeline

The GitHub Actions workflow automatically:
1. Installs Flutter
2. Gets dependencies
3. Runs analyzer
4. Checks code format
5. Runs unit tests with coverage
6. Uploads coverage to Codecov
7. Runs integration tests

### Trigger Events
- Pushes to `main` or `develop`
- Pull requests to `main` or `develop`

## Documentation

For detailed information, see [TESTING.md](TESTING.md) which includes:
- Full testing guide
- Setup instructions
- Test coverage details
- Troubleshooting guide
- Best practices

## Next Steps

1. Run tests locally: `./run_tests.sh` or `run_tests.bat`
2. Push to GitHub to trigger CI/CD pipeline
3. Monitor test results in GitHub Actions
4. Add more integration tests as features grow
5. Maintain test coverage above 80%

## Troubleshooting

**Tests fail with "Not mocked" error**
- Ensure all external methods are mocked using `when()...thenAnswer()`

**Integration tests hang**
- Add `--timeout=120s` to test command
- Check for missing `await tester.pumpAndSettle()`

**GitHub Actions fails**
- Verify Flutter version in `.github/workflows/tests.yml`
- Check for platform-specific issues (Linux desktop tests)

## References

- [Flutter Testing Docs](https://flutter.dev/docs/testing)
- [mocktail Package](https://pub.dev/packages/mocktail)
- [get_it Package](https://pub.dev/packages/get_it)
- [GitHub Actions](https://docs.github.com/en/actions)

---

**Note**: This setup ensures no real network calls during tests. All external services are either mocked (unit tests) or stubbed with fixed responses (integration tests).
