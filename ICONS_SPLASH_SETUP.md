# 🎨 App Icons & Splash Screen Setup Guide

## Overview

- **Icons**: What users see in the app launcher
- **Splash Screen**: Loading screen shown when app starts

---

## 🖼️ Part 1: App Icons

### Required Icon Sizes

| Platform | Size | Notes |
|----------|------|-------|
| Android | 192x192 | Launcher icon |
| Android | 512x512 | Google Play Store listing |
| iOS | 180x180 | Launcher icon |
| iOS | 1024x1024 | App Store listing |
| macOS | 512x512 | Application icon |
| Windows | 256x256 | Window icon |
| Web | 512x512 | Web manifest |

### Create Icon Image

**Recommended approach**: Use tool to generate all sizes from one image

**Tools:**
- **Flutter Launcher Icons** (easiest, built-in)
- Figma (design tool)
- Photoshop or GIMP
- Online: icon-generator.com

**Steps:**

1. **Design Master Icon (1024x1024)**
   - Transparent background (.png)
   - Safe area: inner 512x512 pixels (never cropped)
   - Padding: 10% on all sides
   - No rounded corners (system adds them)

2. **Create Folder Structure**
   ```
   flutter_application_1/
   └── assets/
       └── icon/
           └── icon.png  (1024x1024, transparent)
   ```

3. **Place Icon**
   ```bash
   mkdir -p assets/icon
   # Copy your icon.png to assets/icon/
   ```

---

## 🚀 Part 2: Setup flutter_launcher_icons

### Step 1: Add Package

```bash
flutter pub add flutter_launcher_icons --dev
```

### Step 2: Configure in `pubspec.yaml`

Add at the end of the file (after `flutter:` section):

```yaml
flutter:
  # ... existing flutter config ...
  assets:
    - assets/icon/
    - assets/splash/

# ✅ ADD THIS
flutter_launcher_icons:
  android: true
  ios: true
  macos: true
  windows: true
  web:
    generate: true
    background_color: "#ffffff"

  image_path: "assets/icon/icon.png"
  image_path_android: "assets/icon/icon.png"
  image_path_ios: "assets/icon/icon.png"
  image_path_macos: "assets/icon/icon.png"
  image_path_windows: "assets/icon/icon.png"
  image_path_web: "assets/icon/icon.png"

  # Android specific
  android:
    enable: true
    min_sdk_android: 21
    notification_icon: "notification_icon"  # Optional

  # iOS specific
  ios:
    enable: true

  # macOS specific
  macos:
    enable: true

  # Windows specific
  windows:
    enable: true

  # Web specific
  web:
    generate: true
    background_color: "#ffffff"
```

### Step 3: Generate Icons

```bash
# Generate all platform icons
flutter pub run flutter_launcher_icons

# Output should show:
# ✓ Successfully generated launcher icons for platforms: android, ios, macos, windows, web
```

### Step 4: Verify Generated Icons

**Android:**
```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
├── mipmap-xxxhdpi/ic_launcher.png
```

**iOS:**
```
ios/Runner/Assets.xcassets/AppIcon.appiconset/
├── Icon-App-*.png  (multiple sizes)
```

### Step 5: Test on Device

```bash
# Build and run with new icons
flutter clean
flutter pub get
flutter run

# Verify icon appears in launcher
# May need to restart launcher or clear cache
```

---

## 🎬 Part 3: Splash Screen

### Design Splash Screen Image

**Master Image:**
- **Resolution**: 1080x1920 (full screen, 9:16 ratio)
- **Safe Area**: Inner 800x1600 pixels (what's safe on any device)
- **Content**: Logo + app name + branding

**Design Tips:**
- Use solid color background
- Center logo in safe area
- Add subtle gradient (optional)
- High contrast for visibility

**Create files:**
```
assets/
├── splash/
│   ├── splash.png  (light theme, 1080x1920)
│   └── splash_dark.png  (dark theme, 1080x1920) - optional
```

### Step 1: Add Package

```bash
flutter pub add flutter_native_splash --dev
```

### Step 2: Configure in `pubspec.yaml`

```yaml
flutter_native_splash:
  # Background color
  color: "#FFFFFF"
  
  # Image for splash
  image: assets/splash/splash.png
  
  # Dark mode image (optional)
  color_dark: "#1a1a1a"
  image_dark: assets/splash/splash_dark.png
  
  # Platform support
  android: true
  ios: true
  web: false
  windows: false
  macos: false
  
  # Android specific
  fullscreen: true  # Hide status bar
  android_gravity: center  # Center image
  
  # iOS specific
  ios_content_mode: center  # Center image
```

### Step 3: Generate Splash Screens

```bash
# Generate platform-specific splash screens
flutter pub run flutter_native_splash:create

# Output should show:
# ✓ Splash screen image generated
```

### Step 4: Verify Generated Screens

**Android:**
```
android/app/src/main/res/drawable/
├── launch_background.xml
└── splash.png  (or splash_dark.png)
```

**iOS:**
```
ios/Runner/Base.lproj/
└── LaunchScreen.storyboard
```

### Step 5: Customize (Optional)

#### Custom Splash Duration

In `lib/main_dev.dart` or `lib/main_prod.dart`:

```dart
void main() async {
  WidgetsBinding.instance.window.physicalSize = Size(540, 960);
  addTearDown(WidgetsBinding.instance.window.clearPhysicalSize);

  // Remove splash after custom delay
  Future.delayed(Duration(seconds: 2), () {
    // Splash screen disappears here
    // Show your app
  });

  runApp(const MyApp());
}
```

#### Animated Splash (Dart)

If you want animated splash instead of native:

```dart
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward().then((_) {
      // Navigate to home after animation
      Navigator.of(context).pushReplacementNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: Tween(begin: 0.0, end: 1.0).animate(_animationController),
          child: Image.asset('assets/icon/icon.png', width: 200),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

### Step 6: Test on Device

```bash
# Build and run
flutter clean
flutter pub get
flutter run --release

# Observe splash screen on app start
# Should appear for ~2 seconds, then fade to app
```

---

## 📱 Testing on Multiple Devices

### Test Resolutions

| Device | Resolution | Ratio |
|--------|-----------|-------|
| Phone | 1080x1920 | 9:16 |
| Phone | 720x1280 | 9:16 |
| Phone | 1440x2560 | 9:16 |
| Tablet | 1280x800 | 16:10 |
| Foldable | 2208x1768 | varies |

### Test Orientations

```bash
# Test portrait
adb shell am start -n com.example.flutter_application_1/.MainActivity

# Rotate to landscape
adb shell settings put system accelerometer_rotation 1
adb shell input keyevent 82  # Rotate

# Check splash stretches correctly
```

### Test Dark Mode

```dart
// In your app
bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

if (isDarkMode) {
  // Use splash_dark.png
}
```

---

## 🎨 Design Resources

### Free Icon Makers
- **Figma**: figma.com (free tier)
- **Canva**: canva.com
- **Adobe XD**: adobe.com/xd (free)
- **Illustrator Online**: drawsql.app

### Icon Design Templates
- **Material Design Icons**: fonts.google.com/icons
- **Feather Icons**: feathericons.com
- **Font Awesome**: fontawesome.com

### Splash Screen Generators
- **AppIcon.co**: appicon.co
- **Icon Kitchen**: icon.kitchen
- **Launcher Icon Generator**: romannurik.github.io/AndroidAssetStudio

---

## ⚠️ Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Icon looks blurry | Ensure minimum 1024x1024, high quality PNG |
| Icon not updating | Run `flutter clean` before `flutter run` |
| Splash shows too long | Remove `flutter_native_splash` and use Dart animation |
| Splash cuts off image | Ensure safe area is within 800x1600 |
| Dark splash not showing | Set `image_dark:` in pubspec.yaml |
| Android icon doesn't show | Clear app data: `adb shell pm clear com.example.app` |

---

## ✅ Complete Workflow

### 1. Design Phase
- [ ] Create 1024x1024 icon (transparent background)
- [ ] Create 1080x1920 splash (high quality)
- [ ] Optional: Create dark theme splash

### 2. Setup Phase
- [ ] Create `assets/icon/` and `assets/splash/` folders
- [ ] Place icon.png and splash.png
- [ ] Add packages: `flutter pub add flutter_launcher_icons flutter_native_splash --dev`
- [ ] Update pubspec.yaml with configuration

### 3. Generation Phase
- [ ] Run `flutter pub run flutter_launcher_icons`
- [ ] Run `flutter pub run flutter_native_splash:create`
- [ ] Verify generated files

### 4. Testing Phase
- [ ] `flutter clean && flutter pub get`
- [ ] `flutter run --release`
- [ ] Check icon in launcher
- [ ] Check splash on startup
- [ ] Test on multiple devices/orientations

### 5. Release Phase
- [ ] Icon shows correctly
- [ ] Splash displays properly
- [ ] No console warnings
- [ ] Build APK: `flutter build apk --release`
- [ ] Ready for Play Store

---

## 📋 Quick Commands Reference

```bash
# Setup
flutter pub add flutter_launcher_icons flutter_native_splash --dev

# Generate
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create

# Test
flutter clean
flutter pub get
flutter run --release

# Build for release
flutter build apk --release

# Install test APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

**Icons & Splash Screen Guide**  
Status: Ready to implement  
Estimated Time: 30-45 minutes  
Complexity: Easy with templates
