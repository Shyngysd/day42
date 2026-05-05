# CI/CD & Flavors - Visual Quick Reference

## 🎯 Build Commands Cheat Sheet

### Quick Builds

| What | Command | Output |
|------|---------|--------|
| Dev Debug | `./scripts/build.sh dev debug` | app-dev-debug.apk (~60MB) |
| Dev Release | `./scripts/build.sh dev release` | app-dev-release.apk (~30MB) |
| Prod Debug | `./scripts/build.sh prod debug` | app-prod-debug.apk (~60MB) |
| Prod Release | `./scripts/build.sh prod release` | app-prod-release.apk (~30MB) |

### Manual Flutter Commands

```bash
flutter build apk --flavor dev --target lib/main_dev.dart --debug
flutter build apk --flavor dev --target lib/main_dev.dart --release
flutter build apk --flavor prod --target lib/main_prod.dart --debug
flutter build apk --flavor prod --target lib/main_prod.dart --release
```

### Version Management

| Task | Command |
|------|---------|
| Build # bump | `./scripts/increment_build_number.sh` |
| Patch bump | `./scripts/increment_build_number.sh patch` |
| Minor bump | `./scripts/increment_build_number.sh minor` |
| Major bump | `./scripts/increment_build_number.sh major` |

---

## 🔄 Version Format

```
Current: 1.0.0+5
         │ │ │ │
         │ │ │ └─ Build number (auto-incremented)
         │ │ └─── Patch version
         │ └───── Minor version
         └─────── Major version

After build bump: 1.0.0+6
After patch bump: 1.0.1+1
After minor bump: 1.1.0+1
After major bump: 2.0.0+1
```

---

## 🌍 Environment Comparison

### Dev Flavor vs Prod Flavor

```
┌─────────────────┬──────────────────────┬─────────────────────┐
│ Aspect          │ Dev                  │ Prod                │
├─────────────────┼──────────────────────┼─────────────────────┤
│ App Name        │ Dev App              │ Test App            │
│ API URL         │ localhost:3000       │ api.production.com  │
│ Debug Logging   │ ✅ Enabled           │ ❌ Disabled         │
│ Visual Badge    │ 🟠 "DEV" (top-right) │ None                │
│ Entry Point     │ lib/main_dev.dart    │ lib/main_prod.dart  │
│ Package ID      │ com.example.app.dev  │ com.example.app     │
│ Use Case        │ Development/Testing  │ Production/Release  │
└─────────────────┴──────────────────────┴─────────────────────┘
```

---

## 📦 Build Matrix

```
Flavors × Types = APK Combinations

Dev  ├─ Debug   → app-dev-debug.apk     (60MB, fast, debuggable)
     └─ Release → app-dev-release.apk   (30MB, optimized, signed)

Prod ├─ Debug   → app-prod-debug.apk    (60MB, fast, debuggable)
     └─ Release → app-prod-release.apk  (30MB, optimized, signed)
```

---

## 🤖 GitHub Actions Triggers

### Automatic Builds
```
Push to develop branch
         │
         ▼
    Tests pass ✅
         │
         ▼
Dev Debug APK ✅
         │
         ▼
Artifact (7 days)
```

### Manual Release Build
```
Workflow Dispatch
   ├─ Flavor: all
   └─ Type: release
         │
         ▼
Tests & Analysis ✅
         │
         ▼
Dev Release ✅  │  Prod Release ✅
   │            │
   Version++    Version++
   │            │
   └────┬───────┘
        │
        ▼
Commit changes
        │
        ▼
GitHub Release ✅
   ├─ app-dev-release.apk
   └─ app-prod-release.apk
```

---

## 📋 Common Workflows

### Daily Development
```
1. Make changes
   └─ ./scripts/build.sh dev debug
   └─ Test on device
   └─ git add/commit/push
   └─ CI auto-builds dev debug
```

### Patch Release
```
1. Fix bug
2. ./scripts/increment_build_number.sh patch
   (1.0.0+5 → 1.0.1+1)
3. ./scripts/build.sh dev release
4. ./scripts/build.sh prod release
5. Test both APKs
6. Create GitHub Release manually
   or via Actions (Flavor: all)
```

### Hotfix Workflow
```
1. git checkout -b hotfix/issue-123
2. Make fix
3. ./scripts/build.sh dev debug
4. Test
5. git push
6. PR + merge to develop
7. CI auto-builds
8. Artifact ready to download
```

### Full Release
```
1. GitHub Actions → Run workflow
2. Select: Flavor=all, Type=release
3. Watch builds complete
4. Version auto-increments
5. GitHub Release created with APKs
6. Download and upload to Play Store
```

---

## 🚨 Troubleshooting Matrix

| Problem | Cause | Solution |
|---------|-------|----------|
| "Flavor not found" | Missing config | `flutter clean && flutter pub get` |
| APK not generated | Build error | Check output, ensure flavor/target correct |
| Version not bumped | Not release build | Version only increments on release builds |
| Actions not running | Wrong branch | Must be `develop` or `main` |
| APK won't install | Different package ID | Clear old: `adb uninstall pkg.id` |

---

## 📊 Pipeline Diagram

```
                    GitHub Push
                        │
            ┌───────────┬┴┬───────────┐
            │           │ │           │
        develop       main    workflow
            │           │    dispatch
            │           │       │
     ┌──────▼───────┐   │   ┌───▼────────────┐
     │ Test & Build │   │   │ Manual Options │
     └──────┬───────┘   │   │ ├─ Dev Debug   │
            │           │   │ ├─ Dev Release │
      ┌─────▼──────┐    │   │ ├─ Prod Debug  │
      │            │    │   │ └─ Prod Release│
   Dev Debug    Tests   │   │ └─ All         │
   Artifact      ✅     │   └───┬────────────┘
                        │       │
                        │    ┌──▼─────────────┐
                        │    │ Build Job(s)   │
                        │    │ (1-4 parallel) │
                        │    └──┬─────────────┘
                        │       │
                        │    ┌──▼─────────────┐
                        │    │ Version Check  │
                        │    │ (if release)   │
                        │    └──┬─────────────┘
                        │       │
                        │    ┌──▼─────────────┐
                        │    │ Auto Increment │
                        │    │ Commit & Push  │
                        │    └──┬─────────────┘
                        │       │
                        │    ┌──▼──────────────┐
                        │    │ GitHub Release  │
                        │    │ (if flavor=all) │
                        │    └─────────────────┘
                        │
                    Artifacts
                    Available
```

---

## 📱 Installation Commands

```bash
# Install debug APK
adb install -r build/app/outputs/flutter-apk/app-dev-debug.apk

# Install release APK
adb install -r build/app/outputs/flutter-apk/app-dev-release.apk

# Uninstall before reinstalling
adb uninstall com.example.app.dev
adb install build/app/outputs/flutter-apk/app-dev-debug.apk

# Check installed packages
adb shell pm list packages | grep example
```

---

## 🔑 Key Files Reference

| File | Purpose | Location |
|------|---------|----------|
| FlavorConfig | Configuration class | `lib/config/flavor_config.dart` |
| Dev Entry | Dev main | `lib/main_dev.dart` |
| Prod Entry | Prod main | `lib/main_prod.dart` |
| Build Script | Automate builds | `scripts/build.sh` |
| Version Script | Bump versions | `scripts/increment_build_number.sh` |
| Build Workflow | GitHub Actions | `.github/workflows/build.yml` |
| Build Guide | Full documentation | `BUILD_FLAVORS.md` |
| CI/CD Guide | Pipeline details | `CI_CD_GUIDE.md` |
| Quick Ref | This file | `QUICK_BUILD.md` |

---

## ✅ Success Criteria

### Local Build Success
```
✅ flutter clean succeeds
✅ flutter pub get succeeds
✅ flutter analyze shows no errors
✅ flutter test passes
✅ flutter build apk completes
✅ APK file exists at expected location
```

### GitHub Actions Success
```
✅ Workflow triggers correctly
✅ All jobs complete (with status ✅)
✅ Artifacts downloadable
✅ Version incremented (release builds)
✅ Commit pushed with new version
✅ GitHub Release created (if all flavor)
```

---

## 💡 Pro Tips

1. **Always test locally first** before pushing
2. **Use build scripts** for consistency
3. **Release builds auto-increment** - no manual versioning needed
4. **Check Actions tab** after pushing to develop
5. **Download artifacts early** - only stored 7-30 days
6. **Test both flavors** before production release
7. **Keep changelog updated** with version changes
8. **Tag releases** with version number

---

## 🎯 Decision Tree

```
Want to build?
    │
    ├─ Locally
    │   ├─ Dev flavor?
    │   │   ├─ Debug? → ./scripts/build.sh dev debug
    │   │   └─ Release? → ./scripts/build.sh dev release
    │   └─ Prod flavor?
    │       ├─ Debug? → ./scripts/build.sh prod debug
    │       └─ Release? → ./scripts/build.sh prod release
    │
    ├─ GitHub Actions
    │   ├─ Auto (develop branch)?
    │       └─ Builds dev debug automatically ✅
    │   └─ Manual trigger?
    │       ├─ Select flavor (dev/prod/all)
    │       └─ Select type (debug/release/all)

Want to release?
    │
    ├─ Update version?
    │   ├─ Build # → ./scripts/increment_build_number.sh
    │   ├─ Patch → ./scripts/increment_build_number.sh patch
    │   ├─ Minor → ./scripts/increment_build_number.sh minor
    │   └─ Major → ./scripts/increment_build_number.sh major
    │
    └─ Auto-increments on release builds ✅

Need help?
    │
    ├─ Quick start? → QUICK_BUILD.md
    ├─ Build details? → BUILD_FLAVORS.md
    ├─ CI/CD details? → CI_CD_GUIDE.md
    └─ Architecture? → ARCHITECTURE.md
```

---

## 🚀 Ready to Build!

**Next Step**: `./scripts/build.sh dev debug`

---

**Quick Reference Card**  
Print this for your desk! 📋
