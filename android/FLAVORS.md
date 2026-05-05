# Android Build Configuration for Flavors

This document describes the Android build setup for Flutter flavors.

## Build Variants

The app supports two build variants:
- **dev** - Development environment
- **prod** - Production environment

## Android Configuration

### app/build.gradle.kts

The Gradle configuration defines:
- Build types: debug, release
- Flavors: dev, prod
- Application IDs per flavor

Example structure:
```kotlin
flavorDimensions("env")

productFlavors {
    create("dev") {
        dimension = "env"
        applicationId = "com.example.app.dev"
        versionNameSuffix = "-dev"
    }
    create("prod") {
        dimension = "env"
        applicationId = "com.example.app"
    }
}
```

## Building APKs

### Using Flutter (Recommended)

**Dev Debug:**
```bash
flutter build apk --flavor dev --target lib/main_dev.dart --debug
```

**Dev Release:**
```bash
flutter build apk --flavor dev --target lib/main_dev.dart --release
```

**Prod Debug:**
```bash
flutter build apk --flavor prod --target lib/main_prod.dart --debug
```

**Prod Release:**
```bash
flutter build apk --flavor prod --target lib/main_prod.dart --release
```

### Output Locations

- Dev Debug: `build/app/outputs/flutter-apk/app-dev-debug.apk`
- Dev Release: `build/app/outputs/flutter-apk/app-dev-release.apk`
- Prod Debug: `build/app/outputs/flutter-apk/app-prod-debug.apk`
- Prod Release: `build/app/outputs/flutter-apk/app-prod-release.apk`

## Configuration Files

The build configuration is typically in:
- `android/app/build.gradle.kts` - Main build script
- `android/app/src/main/` - Main source set
- `android/app/src/dev/` - Dev-specific sources (if needed)
- `android/app/src/prod/` - Prod-specific sources (if needed)

## Additional Flavor Configuration (Optional)

You can add flavor-specific resources:

```
android/app/src/
├── main/
│   ├── AndroidManifest.xml
│   └── res/
├── dev/
│   └── res/
│       └── values/
│           └── strings.xml
└── prod/
    └── res/
        └── values/
            └── strings.xml
```

This allows different strings, icons, or other resources per flavor.

## Note

The current setup uses Flutter's flavor system which works cross-platform. The Dart code in `lib/main_dev.dart` and `lib/main_prod.dart` handles flavor-specific configuration.
