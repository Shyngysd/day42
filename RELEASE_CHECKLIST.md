# 🚀 Android Release Build Preparation

## ✅ Complete Release Checklist

### Phase 1: Pre-Release Setup (Before First Release)
- [ ] Create keystore file for signing
- [ ] Store keystore securely
- [ ] Setup GitHub Secrets (keystore + passwords)
- [ ] Configure gradle signing in build.gradle.kts
- [ ] Create app icons (192x192, 512x512)
- [ ] Setup flutter_launcher_icons
- [ ] Generate launcher icons
- [ ] Create splash screen design
- [ ] Setup flutter_native_splash
- [ ] Generate native splash screens
- [ ] Define app colors and branding
- [ ] Write privacy policy
- [ ] Write terms of service

### Phase 2: Pre-Release Verification (Before Every Release)
- [ ] Update version in pubspec.yaml
- [ ] Update CHANGELOG.md
- [ ] Run all tests: `flutter test`
- [ ] Run static analysis: `flutter analyze`
- [ ] Check code coverage
- [ ] Test on debug build locally
- [ ] Test on release build locally
- [ ] Test on multiple Android versions
- [ ] Test on multiple screen sizes
- [ ] Verify all permissions working
- [ ] Test deep links (if implemented)
- [ ] Test offline mode (if implemented)
- [ ] Run `flutter clean`

### Phase 3: Build & Sign Release
- [ ] Build release APK: `flutter build apk --release`
- [ ] Build release bundle: `flutter build appbundle --release`
- [ ] Verify signing certificate is valid
- [ ] Check file sizes are reasonable
- [ ] Run `aapt dump badging` on APK to verify

### Phase 4: Internal Testing (Google Play Console)
- [ ] Create internal testing track
- [ ] Upload signed APK/bundle
- [ ] Add testers to internal testing group
- [ ] Test on real devices (internal testing)
- [ ] Collect feedback from testers
- [ ] Monitor crash reports
- [ ] Check ANRs (Application Not Responding)
- [ ] Verify all features working

### Phase 5: Final Checks
- [ ] Screenshots taken (multiple locales/sizes)
- [ ] App description complete
- [ ] Privacy policy linked
- [ ] Support email configured
- [ ] App category selected
- [ ] Content rating completed
- [ ] Ad ID policy declared
- [ ] Target API level meets requirements
- [ ] Permissions justified

### Phase 6: Release to Production
- [ ] Staged rollout (5% → 10% → 25% → 100%)
- [ ] Monitor crash rate after each stage
- [ ] Monitor user rating changes
- [ ] Monitor review feedback
- [ ] Have rollback plan ready
- [ ] Prepare communication (release notes)

---

## 📋 Version Management

### Current Version Format
```
In pubspec.yaml:
version: 1.0.0+1

Where:
  1.0.0 = versionName (shown to users)
  1      = versionCode (internal identifier)
```

### For This Release
```bash
# Increment based on changes:
1.0.0+1  → 1.0.0+2      (build fix/hotfix)
1.0.0+1  → 1.0.1+1      (patch release)
1.0.0+1  → 1.1.0+1      (minor release)
1.0.0+1  → 2.0.0+1      (major release)

# Use script:
./scripts/increment_build_number.sh build   # Next build
./scripts/increment_build_number.sh patch   # Patch release
```

### In Google Play
```
Users see:       Version 1.0.0 (versionName)
Internally used: Build 1 (versionCode)

When updating:
- versionCode MUST increase (always!)
- versionName can stay same or change
- Usually: versionName bump → versionCode ++
```

---

## 🔑 Keystore Signing Setup

### What is a Keystore?
A keystore file (`release.keystore` or `.jks`) contains the private key used to sign your app. This signature proves the app is from you.

### Generate Keystore (One Time Only)

**Windows:**
```powershell
# Create folder for keystore
mkdir release_key
cd release_key

# Generate keystore (keytool is in Java JDK)
keytool -genkey -v -keystore release.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias release -storepass MyStorePassword123! `
  -keypass MyKeyPassword123! `
  -dname "CN=Your Name,O=Your Company,C=US"

# Replace with YOUR values
```

**Linux/macOS:**
```bash
mkdir release_key
cd release_key

keytool -genkey -v -keystore release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release -storepass MyStorePassword123! \
  -keypass MyKeyPassword123! \
  -dname "CN=Your Name,O=Your Company,C=US"
```

### Keystore Information to Save
```
✅ Keystore file: release.jks
✅ Store password: MyStorePassword123!
✅ Key alias: release
✅ Key password: MyKeyPassword123!
✅ Validity: 10000 days (~27 years)
✅ Location: Keep SAFE! Backup to secure location
```

### ⚠️ CRITICAL: Never Lose Keystore!
- If you lose keystore, you can't update your app on Play Store
- Keep multiple backups (encrypted, offline)
- Don't commit to Git
- Store passwords in secure password manager

---

## ⚙️ Configure Android Gradle Signing

### 1. Create `android/key.properties`

```properties
storeFile=../release_key/release.jks
storePassword=MyStorePassword123!
keyAlias=release
keyPassword=MyKeyPassword123!
```

### 2. Update `android/app/build.gradle.kts`

Find the `buildTypes` section and add signing configuration:

```kotlin
android {
    // ... existing config ...
    
    signingConfigs {
        release {
            keyAlias = "release"
            keyPassword = "MyKeyPassword123!"
            storeFile = file("../release_key/release.jks")
            storePassword = "MyStorePassword123!"
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            minifyEnabled = true
            shrinkResources = true
            proguardFiles getDefaultProguardFile(
                'proguard-android-optimize.txt'),
                'proguard-rules.pro'
        }
    }
}
```

### 3. ✅ Test Signing Works

```bash
flutter build apk --release
# Should succeed and create signed APK at:
# build/app/outputs/flutter-apk/app-release.apk
```

---

## 🎨 Icons & Splash Screen Setup

### 1. Add Packages

```bash
flutter pub add flutter_launcher_icons flutter_native_splash --dev
```

### 2. Create Icon Images

Create these files:
- `assets/icon/icon.png` (1024x1024 pixels, minimum)
- Transparent background recommended
- Safe area: inner 512x512 pixels

### 3. Create Splash Screen

Create file: `assets/splash/splash.png`
- **Recommended size**: 1080x1920 pixels (full screen)
- **Safe area**: 800x1600 pixels (won't be cropped)
- **Include branding**: Logo + app name

### 4. Configure in `pubspec.yaml`

```yaml
flutter_launcher_icons:
  ios: true
  android: true
  image_path: assets/icon/icon.png
  web:
    generate: true
    image_path: assets/icon/icon.png
    background_color: "#ffffff"
  windows:
    generate: true
    image_path: assets/icon/icon.png
  macos:
    generate: true
    image_path: assets/icon/icon.png
  min_sdk_android: 21

flutter_native_splash:
  color: "#FFFFFF"
  background_image: assets/splash/splash.png
  android: true
  ios: true
  web: false
  color_dark: "#1a1a1a"
  background_image_dark: assets/splash/splash_dark.png
```

### 5. Generate Icons & Splash

```bash
# Generate launcher icons
flutter pub run flutter_launcher_icons

# Generate native splash screens
flutter pub run flutter_native_splash:create

# Verify in android/app/src/main/AndroidManifest.xml
# Should see splash screen configuration
```

### 6. Test on Device

```bash
flutter run --release
# Splash should appear on app start
# Icon should appear in launcher
```

---

## 📱 Permissions & Privacy

### Android Permissions in `android/app/src/main/AndroidManifest.xml`

```xml
<!-- If using camera: -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- If accessing photos: -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

<!-- If using notifications: -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<!-- Internet access (usually required): -->
<uses-permission android:name="android.permission.INTERNET" />

<!-- If using location: -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### Runtime Permissions (Android 6+)

For sensitive permissions (camera, photos, location, notifications), you need to request at runtime:

**Example using `permission_handler` package:**

```bash
flutter pub add permission_handler
```

```dart
import 'package:permission_handler/permission_handler.dart';

// Request camera permission
final status = await Permission.camera.request();

if (status.isDenied) {
  // User denied
} else if (status.isGranted) {
  // User granted
} else if (status.isPermanentlyDenied) {
  // User denied permanently, open app settings
  openAppSettings();
}
```

### Privacy Policy

**Required in Google Play:**

```
Title: Privacy Policy for [Your App Name]

1. Data We Collect
   - Device information
   - Crash logs
   - Usage statistics

2. How We Use Data
   - Improve app functionality
   - Fix bugs and crashes
   - Analytics

3. Data Sharing
   - We do not share personal data with third parties
   - Exception: Analytics services (Google Analytics, Firebase)

4. Data Security
   - HTTPS for all network requests
   - Data encrypted in transit

5. Contact
   - Email: privacy@example.com

6. Changes
   - We may update this policy
   - We will notify users of significant changes
```

---

## 🔗 Build Commands Reference

### Debug Build (local testing)
```bash
flutter build apk --debug
# Result: app-debug.apk (~60MB)
# Faster to build, larger file, debuggable
```

### Release Build (Play Store submission)
```bash
# Single APK
flutter build apk --release
# Result: app-release.apk (~30MB)

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release
# Result: app-release.aab (~20MB)
# Smaller, Play Store optimizes for each device
```

### With Flavor Support
```bash
# Release for production
flutter build apk --flavor prod --release

# Release for dev/testing
flutter build apk --flavor dev --release
```

---

## 📊 APK Analysis

### Check APK Contents
```bash
# List all files in APK
aapt dump badging build/app/outputs/flutter-apk/app-release.apk

# Or use APK Analyzer in Android Studio:
# Build → Analyze APK → select app-release.apk
```

### Verify Signing
```bash
# Check certificate
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# Or check APK:
keytool -list -printcert -jarfile app-release.apk
```

### Size Analysis
```bash
# Check APK size
ls -lh build/app/outputs/flutter-apk/app-release.apk

# Enable R8 obfuscation in build.gradle.kts for smaller size
minifyEnabled = true
shrinkResources = true
```

---

## ✅ Pre-Upload Checklist

Before uploading to Play Console:

- [ ] Signed with release keystore
- [ ] Version code increased from previous
- [ ] Version name format: X.Y.Z (semver)
- [ ] APK tested on device (both orientations)
- [ ] All permissions requested at runtime
- [ ] No console errors or crashes
- [ ] Privacy policy completed
- [ ] App icon appears correctly
- [ ] Splash screen displays on launch
- [ ] File size reasonable (~30MB max)
- [ ] Screenshots prepared (multiple locales)
- [ ] Release notes written
- [ ] Changelog updated

---

## 📝 Version History Template

```
## Version 1.0.0 (Build 1)
- Initial release
- Features: Authentication, Item list, Add item
- Release Date: YYYY-MM-DD

## Version 1.0.1 (Build 2)
- Bug fix: Fixed login crash on slow network
- Bug fix: Fixed item list refresh
- Release Date: YYYY-MM-DD
```

---

## 🚀 Summary

1. ✅ Create keystore (one-time)
2. ✅ Setup gradle signing
3. ✅ Add launcher icons
4. ✅ Add splash screen
5. ✅ Check permissions
6. ✅ Build release APK
7. ✅ Upload to Play Console
8. ✅ Test with internal testing
9. ✅ Staged rollout
10. ✅ Monitor analytics

---

**Release Checklist**  
Status: Ready to prepare  
Next Step: Create keystore file  
Estimated Time: 30-45 minutes
