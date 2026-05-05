# 🔑 Android Keystore & Signing Setup Guide

## Overview

The keystore is your app's signature certificate. Once uploaded to Play Store, you cannot change it. **Never lose it.**

---

## 📋 Quick Start: Create & Configure Keystore

### Step 1: Create Keystore File

**Windows (PowerShell):**
```powershell
# Navigate to your project
cd flutter_application_1

# Create directory for keystore
New-Item -ItemType Directory -Path "release_key" -Force

# Find Java location (should be installed with Android Studio)
$env:JAVA_HOME = "C:\Program Files\Android\Android Studio\jbr"
# Or for full JDK:
# $env:JAVA_HOME = "C:\Program Files\Java\jdk-17"

# Generate keystore (valid for ~27 years)
& "$env:JAVA_HOME\bin\keytool" -genkey -v -keystore release_key/release.jks `
  -keyalg RSA `
  -keysize 2048 `
  -validity 10000 `
  -alias release `
  -storepass MyStorePassword123! `
  -keypass MyKeyPassword123! `
  -dname "CN=Your Name,O=Your Company,L=City,ST=State,C=US"

# Verify created
Get-Item release_key/release.jks
```

**Linux/macOS (Bash):**
```bash
# Navigate to your project
cd flutter_application_1

# Create directory
mkdir -p release_key

# Generate keystore
keytool -genkey -v -keystore release_key/release.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias release \
  -storepass MyStorePassword123! \
  -keypass MyKeyPassword123! \
  -dname "CN=Your Name,O=Your Company,L=City,ST=State,C=US"

# Verify created
ls -lh release_key/release.jks
```

**Important values to replace:**
- `Your Name` - Your actual name
- `Your Company` - Company name
- `City` - Your city
- `State` - Your state/province
- `US` - Your country code
- `MyStorePassword123!` - Your store password (save this!)
- `MyKeyPassword123!` - Your key password (save this!)

### Step 2: Verify Keystore Created

```bash
# List keystore contents
keytool -list -v -keystore release_key/release.jks -storepass MyStorePassword123!

# Expected output shows:
# - Alias name: release
# - Creation date: [today]
# - Entry type: PrivateKeyEntry
# - Certificate fingerprints
```

### Step 3: Create Configuration File

Create `android/key.properties`:

```properties
# Keystore configuration for signing release builds
storeFile=../release_key/release.jks
storePassword=MyStorePassword123!
keyAlias=release
keyPassword=MyKeyPassword123!
```

**⚠️ IMPORTANT: Add to `.gitignore`:**

```bash
echo "android/key.properties" >> .gitignore
echo "release_key/" >> .gitignore

# Verify NOT committed to git
git status  # Should not show key.properties or release_key
```

---

## ⚙️ Step 4: Configure Gradle for Signing

Update `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_application_1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // ✅ ADD THIS BLOCK
    def keystoreProperties = new Properties()
    def keystorePropertiesFile = rootProject.file('key.properties')
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
    }

    signingConfigs {
        debug {
            keyAlias 'androiddebugkey'
            keyPassword 'android'
            storeFile file('debug.keystore')
            storePassword 'android'
        }
        
        // ✅ ADD RELEASE SIGNING
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    defaultConfig {
        applicationId = "com.example.flutter_application_1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // ✅ UPDATE THIS
            signingConfig = signingConfigs.release
            
            // Size optimization
            minifyEnabled = true
            shrinkResources = true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

flutter {
    source = "../.."
}
```

---

## ✅ Step 5: Test Release Build

### Build Locally

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Build release APK (unsigned first to test)
flutter build apk --release

# Should succeed with output like:
# ✓ Built build/app/outputs/flutter-apk/app-release.apk (30.5 MB)
```

### Verify Signing

```bash
# Check APK signature
keytool -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk

# Should show your certificate info
```

### Install on Device

```bash
# Uninstall old version
adb uninstall com.example.flutter_application_1

# Install signed APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Verify it works
adb shell am start com.example.flutter_application_1/.MainActivity
```

---

## 🔒 Backup & Security

### Create Secure Backup

```bash
# Create backup of keystore
cp release_key/release.jks release_key/release.jks.backup

# Encrypt for storage (optional but recommended)
# On Windows (7-Zip):
# Right-click release.jks → Add to Archive → 7z format → Set password

# On Linux/macOS (GPG):
gpg --symmetric release_key/release.jks
# Creates: release_key/release.jks.gpg
```

### Store Safely

- ✅ Physical backup drive (encrypted)
- ✅ Cloud storage (password-protected, encrypted)
- ✅ Password manager (store passwords)
- ❌ Never: email, GitHub, cloud (unencrypted)

### Document for Team

Create `KEYSTORE_INFO.txt` (keep private):

```
APP KEYSTORE INFORMATION
⚠️  KEEP THIS SECURE - NEVER SHARE

File: release_key/release.jks
Store Password: MyStorePassword123!
Key Alias: release
Key Password: MyKeyPassword123!
Valid Until: [Date 10000 days from creation]

Created: [Date]
Created By: [Your name]

BACKUP LOCATIONS:
- External drive (encrypted)
- Password manager
- Team secure storage

IF LOST:
- Cannot update app on Play Store
- Must change app ID and start over
- Coordinate with team immediately
```

---

## 🤖 GitHub Actions: Secure Release Build

### Setup GitHub Secrets

In your GitHub repository:

1. **Settings → Secrets and variables → Actions**
2. Create these secrets:

```
KEYSTORE_BASE64:        [Base64 encoded keystore file]
KEYSTORE_PASSWORD:      MyStorePassword123!
KEY_ALIAS:              release
KEY_PASSWORD:           MyKeyPassword123!
```

### Encode Keystore for GitHub

```bash
# Windows (PowerShell):
$encodedKeystore = [Convert]::ToBase64String([IO.File]::ReadAllBytes("release_key/release.jks"))
Write-Host $encodedKeystore | Set-Clipboard

# Linux/macOS:
base64 -i release_key/release.jks | pbcopy  # macOS
base64 release_key/release.jks              # Linux (copy output)
```

### Update `.github/workflows/build.yml`

```yaml
jobs:
  build-release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      
      # ✅ Decode keystore
      - name: Decode keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > release_key/release.jks
      
      # ✅ Create key.properties
      - name: Create key.properties
        run: |
          cat > android/key.properties << EOF
          storeFile=../release_key/release.jks
          storePassword=${{ secrets.KEYSTORE_PASSWORD }}
          keyAlias=${{ secrets.KEY_ALIAS }}
          keyPassword=${{ secrets.KEY_PASSWORD }}
          EOF
      
      - name: Get dependencies
        run: flutter pub get
      
      - name: Build release APK
        run: flutter build apk --release
      
      - name: Build release bundle
        run: flutter build appbundle --release
      
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
      
      - name: Upload AAB
        uses: actions/upload-artifact@v3
        with:
          name: release-bundle
          path: build/app/outputs/bundle/release/app-release.aab
```

---

## 🔍 Troubleshooting

| Problem | Solution |
|---------|----------|
| "keytool: command not found" | Install Java JDK, add to PATH |
| "invalid keystore format" | Keystore file corrupted, regenerate |
| "keystore was tampered with" | File corrupted, restore backup |
| "certificate verify failed" | Wrong password, verify storePassword |
| Build fails with signing error | Check key.properties path and values |

---

## ✅ Checklist

- [ ] Keystore file created
- [ ] Keystore password saved securely
- [ ] key.properties file created
- [ ] key.properties added to .gitignore
- [ ] build.gradle.kts updated
- [ ] Release build succeeds locally
- [ ] APK signature verified
- [ ] Tested on device
- [ ] Keystore backed up (encrypted)
- [ ] Team informed of secure location
- [ ] GitHub Secrets configured (if using CI/CD)

---

**Keystore Setup Guide**  
Status: Complete  
Next Step: Build release APK  
Time Estimate: 15-20 minutes
