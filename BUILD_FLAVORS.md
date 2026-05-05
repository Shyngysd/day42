# Build & Flavors Configuration Guide

## Overview

This Flutter app supports multiple build flavors (dev/prod) with automatic APK building and version management via GitHub Actions.

## 📋 Flavor Configuration

### What are Flavors?

Flavors allow you to build multiple variants of your app with different configurations:
- Different API endpoints
- Different app names/icons
- Different configurations
- Different feature flags

### Supported Flavors

| Flavor | Name | API URL | Debug Logging | Purpose |
|--------|------|---------|---------------|---------|
| dev | Dev App | http://localhost:3000 | ✅ Enabled | Development |
| prod | Test App | https://api.production.com | ❌ Disabled | Production |

---

## 🚀 Building Locally

### Build Dev Flavor

**Debug APK (fast, larger, debuggable):**
```bash
flutter build apk --flavor dev --target lib/main_dev.dart --debug
```

**Release APK (optimized, smaller, signed):**
```bash
flutter build apk --flavor dev --target lib/main_dev.dart --release
```

### Build Prod Flavor

**Debug APK:**
```bash
flutter build apk --flavor prod --target lib/main_prod.dart --debug
```

**Release APK:**
```bash
flutter build apk --flavor prod --target lib/main_prod.dart --release
```

### Run with Flavor

**Dev:**
```bash
flutter run -t lib/main_dev.dart --debug
```

**Prod:**
```bash
flutter run -t lib/main_prod.dart --debug
```

---

## 📁 File Structure

```
lib/
├── config/
│   └── flavor_config.dart          # Flavor configuration
├── main.dart                       # Default (not used with flavors)
├── main_dev.dart                   # Dev flavor entry point
├── main_prod.dart                  # Prod flavor entry point
└── ...

scripts/
├── increment_build_number.sh       # Linux/macOS script
└── increment_build_number.bat      # Windows script
```

---

## 🔄 Version & Build Number Management

### Current Version Format

```
version: 1.0.0+5
         ^^^^^  ^
         |      └─ Build number (auto-incremented)
         └─ Semantic version (major.minor.patch)
```

### Increment Build Number Only

This is done **automatically on release builds**:

**Manually (Linux/macOS):**
```bash
chmod +x scripts/increment_build_number.sh
./scripts/increment_build_number.sh build
```

**Manually (Windows):**
```cmd
scripts/increment_build_number.bat build
```

Example: `1.0.0+5` → `1.0.0+6`

### Increment Patch Version

```bash
# Linux/macOS
./scripts/increment_build_number.sh patch

# Windows
scripts/increment_build_number.bat patch
```

Example: `1.0.0+5` → `1.0.1+1`

### Increment Minor Version

```bash
./scripts/increment_build_number.sh minor
```

Example: `1.0.0+5` → `1.1.0+1`

### Increment Major Version

```bash
./scripts/increment_build_number.sh major
```

Example: `1.0.0+5` → `2.0.0+1`

---

## 🤖 GitHub Actions CI/CD

### Workflow File

Location: `.github/workflows/build.yml`

### Trigger Events

| Event | Trigger | Builds |
|-------|---------|--------|
| Push to `develop` | Automatic | Dev Debug APK |
| Push to `main` | Automatic (tests only) | None |
| Workflow Dispatch | Manual | Custom (dev/prod/all) |
| Pull Request | Manual/Auto | Tests only |

### Manual Build via GitHub Actions

1. Go to **Actions** tab
2. Select **"Flutter Build & Deploy"** workflow
3. Click **"Run workflow"**
4. Choose:
   - Build flavor: `dev` / `prod` / `all`
   - Build type: `debug` / `release` / `all`
5. Click **"Run workflow"**

### Automatic Dev Build

Every push to `develop` branch automatically builds:
- ✅ Dev Debug APK
- 📦 Available as artifact for 7 days

### Manual Release Build

To create a release:
1. Run workflow dispatch with:
   - Flavor: `all`
   - Build type: `release`
2. Build number auto-increments
3. Version is committed to repository
4. GitHub Release created with APKs

---

## 📦 APK Outputs

After building, APKs are located at:

### Debug Builds
```
build/app/outputs/flutter-apk/
├── app-dev-debug.apk
└── app-prod-debug.apk
```

### Release Builds
```
build/app/outputs/flutter-apk/
├── app-dev-release.apk
└── app-prod-release.apk
```

### From GitHub Actions

Artifacts are uploaded and available for download:
- Dev Debug: 7 days retention
- Dev Release: 30 days retention
- Prod Debug: 7 days retention
- Prod Release: 30 days retention

---

## ⚙️ Configuration

### Flavor Configuration Class

File: `lib/config/flavor_config.dart`

Access current flavor anywhere:
```dart
import 'package:flutter_application_1/config/flavor_config.dart';

final config = FlavorConfig.instance;
print(config.name);              // "Dev App" or "Test App"
print(config.apiBaseUrl);        // API endpoint
print(config.enableDebugLogging);// true/false
print(config.isDev);             // true/false
print(config.isProd);            // true/false
```

### Main Entry Points

**lib/main_dev.dart** - Dev flavor:
- Initializes with dev configuration
- Shows "DEV" badge in top-right
- Uses localhost API

**lib/main_prod.dart** - Prod flavor:
- Initializes with prod configuration
- No debug badge
- Uses production API

---

## 🔧 Build Scripts

### Linux/macOS: increment_build_number.sh

```bash
#!/bin/bash
chmod +x scripts/increment_build_number.sh
./scripts/increment_build_number.sh [build|patch|minor|major]
```

Features:
- Parses current version from pubspec.yaml
- Increments specified version component
- Updates pubspec.yaml
- Cross-platform (macOS & Linux)

### Windows: increment_build_number.bat

```cmd
scripts/increment_build_number.bat [build|patch|minor|major]
```

Same functionality as Bash version.

---

## 📊 Build Matrix (GitHub Actions)

The workflow supports this build matrix:

```
┌─────────────────────────────────────┐
│        Build Matrix                 │
├──────────────┬──────────┬───────────┤
│ Flavor       │ Debug    │ Release   │
├──────────────┼──────────┼───────────┤
│ dev          │ ✅ Auto  │ ✅ Manual │
│ prod         │ ✅ Manual│ ✅ Manual │
└──────────────┴──────────┴───────────┘
```

**Auto**: Builds on every push to `develop`  
**Manual**: Only on workflow dispatch

---

## 🔐 Signing Release APKs

Release APKs need signing for production:

1. **Generate keystore (one-time):**
   ```bash
   keytool -genkey -v -keystore release.keystore \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias release
   ```

2. **Store keystore securely:**
   - Add to GitHub Secrets
   - Never commit to repository

3. **Configure signing in build.gradle.kts:**
   ```kotlin
   signingConfigs {
       release {
           keyAlias = System.getenv("KEY_ALIAS")
           keyPassword = System.getenv("KEY_PASSWORD")
           storeFile = file(System.getenv("KEYSTORE_PATH"))
           storePassword = System.getenv("STORE_PASSWORD")
       }
   }
   ```

4. **Update GitHub Actions** to use secrets

---

## 📋 Checklist

Before releasing:
- [ ] All tests pass
- [ ] Code analyzed successfully
- [ ] Feature branch merged to develop
- [ ] Version bumped correctly
- [ ] Changelog updated
- [ ] APK tested on device
- [ ] Screenshots/documentation updated

---

## 🚨 Troubleshooting

### Build fails with "Flavor not found"
```bash
# Ensure pubspec.yaml and build config match
flutter pub get
flutter clean
flutter build apk --flavor dev --target lib/main_dev.dart --debug
```

### APK not generated
- Check build output: `build/app/outputs/flutter-apk/`
- Ensure correct flavor and target specified
- Check Flutter version matches workflow

### Version not incremented
```bash
# Manually increment:
chmod +x scripts/increment_build_number.sh
./scripts/increment_build_number.sh build
git add pubspec.yaml
git commit -m "chore: bump version"
git push
```

### GitHub Actions workflow not triggering
- Check branch name (develop vs main)
- Verify `.github/workflows/build.yml` exists
- Confirm Actions enabled in repo settings

---

## 📚 References

- [Flutter Flavors Documentation](https://flutter.dev/docs/deployment/flavors)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Android Build Variants](https://developer.android.com/studio/build/build-variants)

---

## 💡 Tips

1. **Always use `-t lib/main_[flavor].dart`** when building with flavors
2. **Test flavor locally** before committing
3. **Use descriptive commit messages** for version bumps
4. **Keep APK sizes in mind** for distribution
5. **Monitor CI/CD jobs** for failures

---

**Version**: 1.0.0+1  
**Last Updated**: 2024  
**Status**: ✅ Ready for Production
