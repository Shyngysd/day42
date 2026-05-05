# Quick Start Commands

## 🚀 Get Started in 60 Seconds

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run All Tests
**Windows:**
```bash
.\run_tests.bat
```

**macOS/Linux:**
```bash
chmod +x run_tests.sh
./run_tests.sh
```

### 3. Push to GitHub
```bash
git add .
git commit -m "feat: add comprehensive testing setup"
git push origin main
```

---

## 📋 Common Commands

### Run Specific Tests
```bash
# Unit tests only
flutter test test/

# Integration tests only
flutter test integration_test/app_test.dart

# Single test file
flutter test test/user_repository_test.dart

# With verbose output
flutter test --verbose

# With coverage
flutter test --coverage
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
dart format lib test integration_test

# Check formatting (without changes)
dart format --set-exit-if-changed lib test integration_test
```

### View Coverage
```bash
# Generate coverage report
flutter test --coverage

# View coverage (macOS/Linux)
lcov --list coverage/lcov.info

# Generate HTML report (requires lcov tools)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## 🔧 Development Setup

### Use Fake API Client
Edit `lib/main.dart`:
```dart
import 'package:flutter_application_1/service_locator.dart';

void main() {
  setupServiceLocatorWithFake();  // Use fake API instead of real
  runApp(const MyApp());
}
```

### Use Real API Client
```dart
void main() {
  setupServiceLocator();  // Use real HttpApiClient
  runApp(const MyApp());
}
```

---

## 🧪 Test Credentials

**Email**: `test@example.com`  
**Password**: `password123`

Use these in login screen during manual testing with FakeApiClient.

---

## 🐛 Troubleshooting

### "pub.dev is not available"
```bash
flutter pub get --offline
```

### "Tests hang"
```bash
flutter test --timeout=120s
```

### "Permission denied" (Linux/macOS)
```bash
chmod +x run_tests.sh
./run_tests.sh
```

### "Port already in use" (if running real server)
```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>
```

---

## 📦 Project Structure

```
Key Files:
├── test/user_repository_test.dart     ← Unit tests
├── integration_test/app_test.dart     ← Integration tests
├── lib/data/fake_api_client.dart      ← Fake server
├── lib/service_locator.dart           ← Dependency injection
├── .github/workflows/tests.yml        ← CI/CD
├── run_tests.sh / run_tests.bat       ← Test runners
├── TESTING.md                         ← Full guide
└── IMPLEMENTATION_SUMMARY.md          ← What was built
```

---

## ✅ Verification Checklist

After setup:
- [ ] `flutter pub get` succeeded
- [ ] `flutter analyze` shows no errors
- [ ] Unit tests pass: `flutter test test/`
- [ ] Integration tests pass: `flutter test integration_test/`
- [ ] Coverage report generated: `coverage/lcov.info`
- [ ] GitHub workflow exists: `.github/workflows/tests.yml`

---

## 📚 Documentation

- **[TESTING.md](TESTING.md)** - Complete testing guide with details
- **[TESTING_README.md](TESTING_README.md)** - Quick reference
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - What was built

---

## 🎯 Next Steps

1. ✅ Run tests locally: `./run_tests.sh` or `run_tests.bat`
2. ✅ Verify all pass
3. ✅ Push to GitHub to trigger CI/CD
4. ✅ Check GitHub Actions tab for results
5. ✅ Start development with confidence!

---

## 💡 Pro Tips

### Add test-specific config
```bash
# Create test config if needed
touch test/test_config.dart
```

### Watch mode (auto-run tests on changes)
```bash
flutter test --watch
```

### Run specific test by name
```bash
flutter test -k "login should store user"
```

### Generate coverage HTML report (Linux/macOS)
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Debug a test
```bash
flutter test test/user_repository_test.dart -vv
```

---

## 🌐 GitHub Actions

Status: Check Actions tab in your GitHub repository

**Runs on:**
- Push to `main` or `develop`
- Pull requests to `main` or `develop`

**Steps:**
1. Flutter setup (3.19.0)
2. Get dependencies
3. Code analysis
4. Format check
5. Unit tests + coverage
6. Integration tests

---

## 📞 Support

If tests fail:
1. Check [TESTING.md](TESTING.md) troubleshooting section
2. Verify Flutter version: `flutter --version`
3. Clean and rebuild: `flutter clean && flutter pub get`
4. Run with verbose: `flutter test --verbose`

---

**You're all set! Happy testing! 🚀**
