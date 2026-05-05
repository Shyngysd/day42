# 🚀 Android Release Build: Complete Master Guide

## Overview

This guide takes you from development to App Store submission step-by-step. All pieces work together:

```
Design Phase → Setup Phase → Build Phase → Test Phase → Release Phase
    ↓              ↓             ↓            ↓            ↓
 Icons       Keystore      Release Build   Internal Test  Production
 Splash      Gradle        Sign APK        Play Console   Staged Rollout
 Branding    Permissions   Version         Feedback       Monitor
```

---

## 📋 Complete Release Timeline

| Phase | Task | Time | Status |
|-------|------|------|--------|
| **Design** | Create icons & splash | 1-2 hours | 📋 TODO |
| **Setup** | Create keystore, configure gradle | 20 min | 📋 TODO |
| **Permissions** | Write privacy policy, check permissions | 30 min | 📋 TODO |
| **Build** | Build release APK/AAB, verify signing | 15 min | 📋 TODO |
| **Play Console** | Create app, configure listing, upload APK | 1-2 hours | 📋 TODO |
| **Internal Test** | Invite testers, collect feedback | 1-7 days | 📋 TODO |
| **Fix & Iterate** | Fix bugs, release hotfixes if needed | 1-3 days | 📋 TODO |
| **Staging** | Staged rollout 5% → 25% → 100% | 1-3 days | 📋 TODO |
| **Monitor** | Watch metrics, be ready to rollback | Ongoing | 📋 TODO |

**Total Estimated Time: 3-7 days**

---

## 🎨 Phase 1: Design (1-2 hours)

### Step 1.1: Create App Icon

**What you need:**
- 1024x1024 PNG image with transparent background
- Save to: `assets/icon/icon.png`

**Tools:**
- Figma, Canva, GIMP, Photoshop
- Or use online generator: icon-kitchen.vercel.app

**Requirements:**
- Minimum 1024x1024 pixels
- PNG format with transparency
- Safe area: inner 512x512 (won't be cropped)
- No rounded corners (OS adds them)

### Step 1.2: Create Splash Screen

**What you need:**
- 1080x1920 PNG image (full screen)
- Save to: `assets/splash/splash.png`
- Optional dark version: `assets/splash/splash_dark.png`

**Requirements:**
- Full HD resolution (1080x1920)
- Safe area: inner 800x1600 pixels
- Include app logo/name
- High contrast for visibility
- Same design for both orientations

### Step 1.3: Setup Icon Generation

```bash
# Add package
flutter pub add flutter_launcher_icons flutter_native_splash --dev
```

Update `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: assets/icon/icon.png
  min_sdk_android: 21

flutter_native_splash:
  color: "#FFFFFF"
  image: assets/splash/splash.png
  android: true
  color_dark: "#1a1a1a"
  image_dark: assets/splash/splash_dark.png
```

### Step 1.4: Generate Platforms Icons

```bash
# Generate launcher icons
flutter pub run flutter_launcher_icons

# Generate splash screens
flutter pub run flutter_native_splash:create

# Test locally
flutter clean
flutter pub get
flutter run --release
```

✅ **Verify:**
- Icon appears in launcher
- Splash shows on app start
- Both look good

---

## 🔑 Phase 2: Setup Keystore (20 minutes)

### Step 2.1: Create Keystore File

**Windows (PowerShell):**

```powershell
# Create directory
mkdir release_key
cd release_key

# Generate keystore
keytool -genkey -v -keystore release.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias release -storepass MyPassword123! -keypass MyPassword123! `
  -dname "CN=Your Name,O=Company,L=City,ST=State,C=US"
```

**Linux/macOS:**

```bash
mkdir -p release_key
keytool -genkey -v -keystore release_key/release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release -storepass MyPassword123! -keypass MyPassword123! \
  -dname "CN=Your Name,O=Company,L=City,ST=State,C=US"
```

✅ **Save these values:**
```
Keystore: release_key/release.jks
Store Password: MyPassword123!
Key Alias: release
Key Password: MyPassword123!
```

### Step 2.2: Create Configuration File

Create `android/key.properties`:

```properties
storeFile=../release_key/release.jks
storePassword=MyPassword123!
keyAlias=release
keyPassword=MyPassword123!
```

Add to `.gitignore`:

```bash
echo "android/key.properties" >> .gitignore
echo "release_key/" >> .gitignore
```

### Step 2.3: Configure Gradle

Update `android/app/build.gradle.kts`:

```kotlin
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.release
            minifyEnabled = true
            shrinkResources = true
        }
    }
}
```

### Step 2.4: Verify Signing Works

```bash
flutter clean
flutter pub get
flutter build apk --release

# Should output: ✓ Built build/app/outputs/flutter-apk/app-release.apk
```

✅ **Verify signing:**

```bash
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

---

## 📝 Phase 3: Permissions & Privacy (30 minutes)

### Step 3.1: Verify Permissions

Check `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <!-- Add others if needed: CAMERA, READ_EXTERNAL_STORAGE, POST_NOTIFICATIONS -->
</manifest>
```

### Step 3.2: Create Privacy Policy

Write privacy policy (use template from PERMISSIONS_PRIVACY.md):

```markdown
# Privacy Policy for [App Name]

1. What Data We Collect
   - Email (for login)
   - Items you create
   - Crash reports (optional)

2. How We Use Data
   - Provide service
   - Fix bugs
   - Analytics (anonymous)

3. Your Rights
   - Request data deletion
   - Opt out of analytics
   - Update information

4. Contact
   - Email: privacy@example.com
```

### Step 3.3: Host Privacy Policy

**Option A: Firebase Hosting**
```bash
firebase init hosting
# Edit public/privacy.html with policy
firebase deploy
# URL: https://your-project.web.app/privacy.html
```

**Option B: GitHub Pages**
- Create GitHub repo: your-app-privacy
- Add privacy.md
- Enable GitHub Pages
- URL: https://your-username.github.io/your-app-privacy/

**Option C: Simple file**
- Upload to your website
- URL: https://example.com/privacy-policy

✅ **Verify:** URL is public and readable

---

## 🏗️ Phase 4: Build Release APK (15 minutes)

### Step 4.1: Update Version

Update `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

Or increment with script:

```bash
./scripts/increment_build_number.sh patch  # 1.0.0+1 → 1.0.1+1
```

### Step 4.2: Build Release APK

```bash
# Single APK (for testing or older devices)
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk (~30MB)

# App Bundle (recommended for Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab (~20MB)
```

### Step 4.3: Verify APK/AAB

```bash
# Check file exists
ls -lh build/app/outputs/flutter-apk/app-release.apk
ls -lh build/app/outputs/bundle/release/app-release.aab

# Verify signing
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# Check certificate
aapt dump badging build/app/outputs/flutter-apk/app-release.apk
```

### Step 4.4: Test on Device

```bash
# Uninstall old version
adb uninstall com.example.flutter_application_1

# Install signed APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Test thoroughly
# - Login with valid credentials
# - Create items
# - Test all features
# - Check for crashes
```

✅ **Checklist:**
- [ ] APK installs
- [ ] App starts
- [ ] Login works
- [ ] Main features work
- [ ] No crashes
- [ ] No ANRs (freezes)

---

## 🎮 Phase 5: Google Play Console (1-2 hours)

### Step 5.1: Create Developer Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Pay $25 one-time fee
3. Setup profile (name, address, phone)

### Step 5.2: Create App

1. **Dashboard** → **Create app**
2. Fill in:
   - App name: "flutter_application_1"
   - Category: Select appropriate
   - Free or paid: Select "Free"
3. Accept declarations
4. Create

### Step 5.3: Configure Store Listing

1. **Setup** → **Store listing**
   - Title
   - Short description (80 chars)
   - Full description (4000 chars max)
   - Screenshots (5-8, 1080x1920 or 1280x720)
   - Feature graphic (1280x720)
   - App icon (512x512)

2. **App content** → **Content rating questionnaire**
   - Answer questions
   - Get rating (Everyone, 12+, 16+, 18+)

3. **App content** → **Privacy policy**
   - Enter your privacy policy URL

4. **Setup** → **App signing**
   - Use "Google Play App Signing" (automatic)
   - DON'T upload your keystore

### Step 5.4: Upload APK to Internal Testing

1. **Testing** → **Internal testing**
2. Click **Create release**
3. Upload:
   - APK: `build/app/outputs/flutter-apk/app-release.apk`
   - Or Bundle: `build/app/outputs/bundle/release/app-release.aab`
4. Add release notes (optional)
5. Send to review

✅ **Wait for approval** (usually 2 hours)

### Step 5.5: Invite Testers

1. **Testing** → **Internal testing**
2. Click **Invite testers**
3. Add email addresses:
   ```
   tester1@example.com
   tester2@example.com
   tester3@example.com
   ```
4. Send invitations

✅ **Testers receive emails**

---

## 🧪 Phase 6: Internal Testing (1-7 days)

### Step 6.1: Testers Install App

Testers:
1. Click email link
2. Accept invitation
3. Go to Play Store
4. Search for your app
5. Install (shows "You're a beta tester")

### Step 6.2: Collect Feedback

Monitor in Play Console:

1. **User feedback** → **Ratings & reviews**
   - Read tester comments
   - Address issues

2. **Analytics**:
   - Crashes & ANRs
   - Performance metrics
   - Device breakdown

### Step 6.3: Watch Key Metrics

| Metric | Target | Action if Failed |
|--------|--------|------------------|
| Crash rate | < 1% | Fix and resubmit |
| ANR rate | < 0.1% | Fix and resubmit |
| Successful installs | > 95% | Investigate |
| Rating | > 3.5 | Read feedback |

### Step 6.4: Fix Issues & Resubmit

```bash
# Fix bug in code
# ...

# Increment version
./scripts/increment_build_number.sh patch

# Rebuild
flutter build appbundle --release

# Upload to same internal testing track
# (Play Console → Testing → Internal testing → Create release)
```

✅ **Testers auto-get update**

---

## 🚀 Phase 7: Staged Rollout (1-3 days)

### Step 7.1: Move to Production

When ready:

1. **Release** → **Production**
2. Click **Create release**
3. Upload APK/AAB
4. Add release notes
5. **Setup staged rollout**:
   - Start at 5%
   - Monitor 24 hours
   - Increase to 25%
   - Monitor 24 hours
   - Increase to 100%

### Step 7.2: Monitor Rollout

**First 4 hours:**
- Crash rate
- Install success
- Login errors
- User feedback

**If issues found:**
- Click "Pause rollout"
- Pause at current %
- Fix bug
- Create new version
- Restart rollout

### Step 7.3: Full Rollout

```
Percentage → Percentage → Time
    5% ───────→ 25% ────→ 24 hours
   25% ───────→ 50% ────→ 24 hours
   50% ───────→ 100% ───→ 24 hours
```

---

## 📊 Phase 8: Monitoring (Ongoing)

### Daily Checklist

- [ ] Check crash rate (< 0.5%)
- [ ] Check ANR rate (< 0.1%)
- [ ] Read new reviews
- [ ] Monitor rating (≥ 4.0)
- [ ] Check downloads/installs
- [ ] Verify no negative patterns

### Week 1

- [ ] Cumulative crash < 1%
- [ ] Average rating ≥ 4.0
- [ ] 50%+ of users on new version
- [ ] No critical feedback

### Week 2+

- [ ] Crash rate stabilized
- [ ] Rating stable
- [ ] User base growing
- [ ] Happy to keep released

### Rollback Triggers

If detected:
- Crash rate > 2%
- Login failures > 30%
- Data loss reported
- Security issue

**Rollback time: 15-30 minutes**

See: [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md)

---

## ✅ Pre-Release Final Checklist

### Design
- [ ] Icon created (1024x1024)
- [ ] Splash screen created (1080x1920)
- [ ] Icons generated for all platforms
- [ ] Splash screens generated
- [ ] Tested on device

### Setup
- [ ] Keystore created
- [ ] key.properties configured
- [ ] build.gradle.kts updated
- [ ] Release build succeeds
- [ ] Signing verified

### Permissions & Privacy
- [ ] Privacy policy written
- [ ] Privacy policy hosted (public URL)
- [ ] Permissions reviewed
- [ ] AndroidManifest.xml correct
- [ ] No undeclared permissions

### Build
- [ ] Version updated in pubspec.yaml
- [ ] CHANGELOG updated
- [ ] All tests passing
- [ ] Code analyzed
- [ ] APK tested on device
- [ ] File sizes reasonable

### Play Console
- [ ] Account created and verified
- [ ] App created
- [ ] Store listing complete
- [ ] Screenshots provided
- [ ] Privacy policy linked
- [ ] Content rating done
- [ ] Support email configured

### Internal Testing
- [ ] APK uploaded
- [ ] Testers invited
- [ ] Feedback collected
- [ ] Critical bugs fixed
- [ ] No crashes in 3 days
- [ ] Rating ≥ 3.5

### Production Ready
- [ ] All issues resolved
- [ ] Staged rollout plan ready
- [ ] Communication plan ready
- [ ] Rollback procedure reviewed
- [ ] Team aware and ready

---

## 📞 Quick Reference

| Need | Document |
|------|----------|
| Icons & Splash | [ICONS_SPLASH_SETUP.md](ICONS_SPLASH_SETUP.md) |
| Keystore | [KEYSTORE_SETUP.md](KEYSTORE_SETUP.md) |
| Permissions & Privacy | [PERMISSIONS_PRIVACY.md](PERMISSIONS_PRIVACY.md) |
| Play Console | [PLAY_CONSOLE_GUIDE.md](PLAY_CONSOLE_GUIDE.md) |
| Risks & Rollback | [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md) |
| Checklist | [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) |

---

## 🎯 Summary

**What you're doing:**
1. ✅ Creating release-ready APK with signing
2. ✅ Setting up branding (icons, splash)
3. ✅ Configuring permissions & privacy
4. ✅ Submitting to Google Play
5. ✅ Testing with real users
6. ✅ Releasing to production

**Time Investment:**
- Design: 1-2 hours (one-time)
- Setup: 20 minutes (one-time)
- Build & Release: 2-3 hours per release
- Monitoring: 15 minutes daily

**Risk Mitigation:**
- Complete testing before release
- Staged rollout (not all users at once)
- Monitoring alerts
- Rollback procedure ready

---

**Android Release Build: Master Guide**  
Version: 1.0  
Status: Complete & Ready  
Estimated Time to Release: 3-7 days
