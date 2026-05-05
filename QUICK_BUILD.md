# Quick Build Guide - Flavors & Releases

## ⚡ 30-Second Start

### Build Dev (Debug)
```bash
# Linux/macOS
./scripts/build.sh dev debug

# Windows
scripts\build.bat dev debug
```

### Build Prod (Debug)
```bash
# Linux/macOS
./scripts/build.sh prod debug

# Windows
scripts\build.bat prod debug
```

### Build Dev (Release)
```bash
# Linux/macOS
./scripts/build.sh dev release

# Windows
scripts\build.bat dev release
```

---

## 📱 Manual Build Commands

### Using Flutter CLI Directly

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

---

## 🚀 Run with Flavor

**Run Dev:**
```bash
flutter run -t lib/main_dev.dart
```

**Run Prod:**
```bash
flutter run -t lib/main_prod.dart
```

---

## 🔄 Version Management

### View Current Version
```bash
grep "^version:" pubspec.yaml
# Output: version: 1.0.0+5
```

### Auto-Increment (Automatic on Release Builds)

**Manual increment - build number only:**
```bash
# Linux/macOS
./scripts/increment_build_number.sh

# Windows
scripts\increment_build_number.bat
```

**Manual increment - patch version:**
```bash
./scripts/increment_build_number.sh patch
# 1.0.0+5 → 1.0.1+1
```

**Manual increment - minor version:**
```bash
./scripts/increment_build_number.sh minor
# 1.0.0+5 → 1.1.0+1
```

**Manual increment - major version:**
```bash
./scripts/increment_build_number.sh major
# 1.0.0+5 → 2.0.0+1
```

---

## 🤖 GitHub Actions

### Manual Build (Workflow Dispatch)

1. Go to GitHub → **Actions** tab
2. Select **"Flutter Build & Deploy"**
3. Click **"Run workflow"**
4. Choose:
   - Flavor: `dev` / `prod` / `all`
   - Build type: `debug` / `release` / `all`
5. Click **"Run workflow"**

### Automatic Dev Build

Every push to `develop` branch automatically builds:
- Dev Debug APK (available 7 days)

### Result

Download APKs from:
1. GitHub Actions → Workflow run → Artifacts
2. Or from GitHub Release (if full release triggered)

---

## 📦 APK Locations

After building locally:

```
build/app/outputs/flutter-apk/
├── app-dev-debug.apk         (size: ~60MB)
├── app-dev-release.apk       (size: ~30MB)
├── app-prod-debug.apk        (size: ~60MB)
└── app-prod-release.apk      (size: ~30MB)
```

---

## 🧪 Testing Before Build

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format check
dart format --set-exit-if-changed lib
```

---

## ✅ Quality Checklist

Before each build:
- [ ] `flutter analyze` passes
- [ ] All tests pass
- [ ] Code formatted
- [ ] Commit message ready
- [ ] Version number checked

---

## 📋 Common Workflows

### 1. Daily Dev Build
```bash
./scripts/build.sh dev debug
# Test locally on device
adb install -r build/app/outputs/flutter-apk/app-dev-debug.apk
```

### 2. Release to App Store
```bash
# Increment patch version
./scripts/increment_build_number.sh patch
# Build release
./scripts/build.sh dev release
./scripts/build.sh prod release
# Upload APKs to Play Store
```

### 3. Hotfix Build
```bash
# Minor increment
./scripts/increment_build_number.sh minor
# Build both
./scripts/build.sh dev release
./scripts/build.sh prod release
```

### 4. Major Release
```bash
# Major increment
./scripts/increment_build_number.sh major
# Build and tag
./scripts/build.sh dev release
./scripts/build.sh prod release
git tag v$(grep "^version:" pubspec.yaml | cut -d' ' -f2)
git push --tags
```

---

## 🔑 Environment Differences

### Dev Flavor
```
Name: Dev App
API: http://localhost:3000
Logging: ✅ Enabled
Icon Badge: 🟠 "DEV"
Use for: Development & testing
```

### Prod Flavor
```
Name: Test App
API: https://api.production.com
Logging: ❌ Disabled
Icon Badge: None
Use for: Production releases
```

---

## 🛠 Build System Features

| Feature | Dev | Prod |
|---------|-----|------|
| Debug builds | ✅ Fast | ✅ Fast |
| Release builds | ✅ Optimized | ✅ Optimized |
| Auto version increment | ✅ Yes | ✅ Yes |
| GitHub Actions | ✅ Auto | ✅ Manual |
| API configuration | ✅ Localhost | ✅ Production |
| Debug logging | ✅ Enabled | ❌ Disabled |

---

## 📊 Build Times (Approximate)

| Build | Time | Size |
|-------|------|------|
| Dev Debug | 2-3 min | 60MB |
| Dev Release | 3-4 min | 30MB |
| Prod Debug | 2-3 min | 60MB |
| Prod Release | 3-4 min | 30MB |

---

## 🚨 Quick Fixes

**"Flavor not found"**
```bash
flutter clean
flutter pub get
flutter build apk --flavor dev --target lib/main_dev.dart --debug
```

**"APK not generated"**
- Check build output
- Ensure correct flavor/target
- Try: `flutter build apk --flavor dev --target lib/main_dev.dart --debug -v`

**"Version not updated"**
```bash
chmod +x scripts/increment_build_number.sh
./scripts/increment_build_number.sh build
git add pubspec.yaml
git commit -m "chore: increment build number"
git push
```

---

## 💡 Pro Tips

1. **Always test locally** before pushing
2. **Use build scripts** for consistency
3. **Version bumps** commit automatically
4. **Release builds** auto-increment
5. **Keep APK sizes small** for distribution
6. **Test both flavors** before release
7. **Monitor CI/CD** for failures

---

## 📞 Need Help?

- Full guide: [BUILD_FLAVORS.md](BUILD_FLAVORS.md)
- CI/CD details: [CI_CD_GUIDE.md](CI_CD_GUIDE.md)
- Testing setup: [TESTING.md](TESTING.md)

---

**Ready to build!** 🚀

Next: `./scripts/build.sh dev debug`
