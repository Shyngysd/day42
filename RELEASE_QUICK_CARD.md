# 📋 Android Release: Quick Reference Card

## 🚀 Release Workflow at a Glance

```
START
  │
  ├─→ Phase 1: Design Icons/Splash (1-2h)
  │   └─→ Create assets, setup packages
  │
  ├─→ Phase 2: Setup Keystore (20m)
  │   └─→ Create signing certificate
  │
  ├─→ Phase 3: Permissions & Privacy (30m)
  │   └─→ Write policy, verify permissions
  │
  ├─→ Phase 4: Build Release (15m)
  │   └─→ flutter build appbundle --release
  │
  ├─→ Phase 5: Play Console Setup (1-2h)
  │   └─→ Create app, configure listing
  │
  ├─→ Phase 6: Internal Testing (1-7d)
  │   └─→ Upload APK, invite testers
  │
  ├─→ Phase 7: Fix Issues (1-3d)
  │   └─→ Monitor, fix, resubmit
  │
  ├─→ Phase 8: Staged Rollout (1-3d)
  │   └─→ 5% → 25% → 100%
  │
  └─→ PRODUCTION ✅
```

---

## ⚡ Commands Cheat Sheet

### Create Keystore
```bash
# Windows
keytool -genkey -v -keystore release.jks `
  -keyalg RSA -keysize 2048 -validity 10000 `
  -alias release -storepass Password123! -keypass Password123! `
  -dname "CN=Name,O=Company,L=City,ST=State,C=US"

# Linux/macOS
keytool -genkey -v -keystore release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release -storepass Password123! -keypass Password123! \
  -dname "CN=Name,O=Company,L=City,ST=State,C=US"
```

### Generate Icons & Splash
```bash
flutter pub add flutter_launcher_icons flutter_native_splash --dev
flutter pub run flutter_launcher_icons
flutter pub run flutter_native_splash:create
```

### Build Release
```bash
flutter clean
flutter pub get
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### Test on Device
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Increment Version
```bash
./scripts/increment_build_number.sh patch  # 1.0.0+1 → 1.0.1+1
```

---

## 📋 Pre-Release Checklist

### Before Starting
- [ ] All features implemented & tested
- [ ] All tests passing
- [ ] Code reviewed
- [ ] Team ready

### Design Phase
- [ ] Icon created (1024×1024, PNG)
- [ ] Splash created (1080×1920, PNG)
- [ ] Packages added
- [ ] Icons generated
- [ ] Tested on device

### Setup Phase
- [ ] Keystore created & backed up
- [ ] key.properties created
- [ ] build.gradle.kts updated
- [ ] Release build successful
- [ ] Signing verified

### Permissions & Privacy
- [ ] Privacy policy written
- [ ] Hosted online (public URL)
- [ ] Permissions reviewed
- [ ] AndroidManifest.xml correct

### Build & Test
- [ ] Version updated
- [ ] All tests pass
- [ ] Code analyzed (no errors)
- [ ] APK built & tested
- [ ] Signing certificate valid

### Play Console
- [ ] Account created
- [ ] App created
- [ ] Store listing complete
- [ ] Screenshots provided
- [ ] Content rating done
- [ ] Privacy policy linked

### Internal Testing
- [ ] APK uploaded
- [ ] Testers invited
- [ ] Feedback collected
- [ ] Critical bugs fixed
- [ ] No crashes

### Release
- [ ] Ready to go
- [ ] Rollback plan ready
- [ ] Team notified
- [ ] Staged rollout configured

---

## 🎯 Key Files

| File | Purpose |
|------|---------|
| pubspec.yaml | Version number (1.0.0+1) |
| android/key.properties | Keystore config |
| android/app/build.gradle.kts | Gradle signing setup |
| android/app/src/main/AndroidManifest.xml | Permissions |
| release_key/release.jks | Signing certificate |
| assets/icon/icon.png | App icon |
| assets/splash/splash.png | Splash screen |

---

## 📊 Release Status Dashboard

```
PHASE              TIME        STATUS      DOCS
─────────────────────────────────────────────────────
Design             1-2h        ☐ TODO      ICONS_SPLASH_SETUP
Keystore           20m         ☐ TODO      KEYSTORE_SETUP
Permissions        30m         ☐ TODO      PERMISSIONS_PRIVACY
Build              15m         ☐ TODO      RELEASE_CHECKLIST
Play Console       1-2h        ☐ TODO      PLAY_CONSOLE_GUIDE
Internal Testing   1-7d        ☐ TODO      PLAY_CONSOLE_GUIDE
Fix Issues         1-3d        ☐ TODO      RELEASE_CHECKLIST
Staged Rollout     1-3d        ☐ TODO      RISKS_ROLLBACK
─────────────────────────────────────────────────────
TOTAL              3-7d        ☐ READY?
```

---

## 🔑 Important Passwords to Save

```
Keystore: release.jks
─────────────────────────
Store Password:  ________________
Key Alias:       release
Key Password:    ________________
Validity:        10000 days (~27 years)

⚠️  SAVE IN PASSWORD MANAGER
```

---

## 📱 Version Format

```
pubspec.yaml:
version: 1.0.0+1

Where:
1.0.0 = versionName (what users see)
+1    = versionCode (internal number, must increase)

Rules:
- versionCode MUST always increase
- versionName can match previous or increment
- Can't go backwards (1.0.0+2 → 1.0.0+1 ❌)
```

---

## ⚠️ Critical Mistakes to Avoid

| Mistake | Impact | Fix |
|---------|--------|-----|
| Lose keystore | Can't update app ever | Recreate with new ID |
| Wrong permissions | App rejected | Add to manifest |
| No privacy policy | Instant rejection | Write & link |
| Missing icon | App rejected | Create icon |
| Crash on startup | Immediate rollback | Fix & resubmit |
| Build number doesn't increase | Update blocked | Increment correctly |

---

## 🚨 If Something Goes Wrong

### App Crashes (> 2%)
```
1. Check Play Console → Analytics → Crashes
2. Click crash to see stack trace
3. Fix code
4. Increment version: ./scripts/increment_build_number.sh patch
5. Rebuild: flutter build appbundle --release
6. Resubmit to Play Console
```

### Can't Build Release
```
1. Run: flutter clean
2. Run: flutter pub get
3. Check: key.properties exists
4. Check: build.gradle.kts signing config
5. Try: flutter build apk --release -v (verbose)
6. Read error carefully
```

### Testers Can't Install
```
1. Check: APK uploaded successfully
2. Check: Wait 2+ hours for approval
3. Check: Tester accepted invitation
4. Check: Not installed already (conflicts)
5. Have tester uninstall old version
```

### Rollback Needed
```
1. Go to: Play Console → Release → Production
2. Click: Pause rollout
3. Prepare: Fixed version
4. Increment version: patch
5. Rebuild & upload
6. Start new 5% rollout
7. See: RELEASE_RISKS_ROLLBACK.md
```

---

## 📈 Monitoring Checklist

### Hour 1-4 (Launch Day)
- [ ] Check crash rate (target < 2%)
- [ ] Check install success (target > 95%)
- [ ] Check login success (target > 90%)
- [ ] Monitor user reviews

### Day 2-7
- [ ] Crash rate < 1%
- [ ] ANR rate < 0.1%
- [ ] Average rating ≥ 4.0
- [ ] Read negative reviews
- [ ] Monitor download count

### Week 2+
- [ ] Crash rate stable (< 0.5%)
- [ ] Rating stable (≥ 4.0)
- [ ] Growing user base
- [ ] Proceed to 100% rollout

---

## 📞 Quick Links

| Problem | Document |
|---------|----------|
| How do I create icons? | ICONS_SPLASH_SETUP.md |
| How do I setup keystore? | KEYSTORE_SETUP.md |
| How do I write privacy policy? | PERMISSIONS_PRIVACY.md |
| How do I use Play Console? | PLAY_CONSOLE_GUIDE.md |
| What are the risks? | RELEASE_RISKS_ROLLBACK.md |
| Complete guide? | ANDROID_RELEASE_MASTER.md |
| Full index? | RELEASE_PREPARATION_INDEX.md |

---

## ✅ Decision Matrix

### Version Type Selection

```
What changed?
  │
  ├─ Bug fix only?
  │  └─ Patch: 1.0.0+1 → 1.0.1+1
  │
  ├─ New features?
  │  └─ Minor: 1.0.0+1 → 1.1.0+1
  │
  ├─ Breaking changes?
  │  └─ Major: 1.0.0+1 → 2.0.0+1
  │
  └─ Build/CI fixes?
     └─ Build: 1.0.0+1 → 1.0.0+2
```

### Rollout Decision

```
Crash rate?
  ├─ < 0.5%  → ✅ All good, increase rollout
  ├─ 0.5-2%  → ⚠️  Monitor closely
  ├─ 2-5%    → ⚠️  Consider pause/rollback
  └─ > 5%    → 🛑 PAUSE ROLLOUT
```

---

## 🎯 Success Criteria

```
✅ PHASE COMPLETE when:
- Design:     Icons/splash generated & tested
- Setup:      Keystore created, gradle updated
- Perms:      Privacy policy hosted & linked
- Build:      APK built, signed, tested on device
- Console:    App created, listing complete
- Testing:    Testers have app, feedback collected
- Fixed:      All bugs resolved, no crashes
- Rollout:    Staged to 100%, metrics good
```

---

## 📚 Document Map

```
Want quick answer?
  └─ ANDROID_RELEASE_MASTER.md

Want complete information?
  ├─ RELEASE_PREPARATION_INDEX.md (all links)
  └─ RELEASE_CHECKLIST.md (detailed checklist)

Need specific help?
  ├─ Icons/Splash → ICONS_SPLASH_SETUP.md
  ├─ Keystore → KEYSTORE_SETUP.md
  ├─ Permissions → PERMISSIONS_PRIVACY.md
  ├─ Play Console → PLAY_CONSOLE_GUIDE.md
  ├─ Risks → RELEASE_RISKS_ROLLBACK.md
  └─ Index → RELEASE_PREPARATION_INDEX.md
```

---

## ⏱️ Timeline

```
Day 1 (2-3h):   Phases 1-3 (Design, Setup, Perms)
Day 1 (30m):    Phase 4 (Build)
Day 1-2 (1-2h): Phase 5 (Play Console)
Day 2-8 (7d):   Phase 6 (Internal Testing)
Day 2-5 (3d):   Phase 7 (Fix Issues)
Day 5-8 (3d):   Phase 8 (Staged Rollout)
─────────────────────────────────────
READY FOR PRODUCTION after Day 8
```

---

## 🖨️ Print This Card!

Save as PDF and keep at your desk during release.

---

**Android Release: Quick Reference Card**  
Print & Keep Handy ✅  
Last Updated: 2024
