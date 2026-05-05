# 📦 Android Release Preparation: Complete Index

## 🚀 Quick Start (Choose Your Path)

### ⏱️ "I have 5 minutes"
→ Read: [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) - Phase 1 section

### ⏱️ "I have 30 minutes"
→ Read: [ANDROID_RELEASE_MASTER.md](ANDROID_RELEASE_MASTER.md) - Overview section

### ⏱️ "I'm doing a release now"
→ Follow: [ANDROID_RELEASE_MASTER.md](ANDROID_RELEASE_MASTER.md) - Step by step

### ⏱️ "I want to understand everything"
→ Read all documents in order (see below)

---

## 📚 Document Guide

### 1. **ANDROID_RELEASE_MASTER.md** (START HERE!)
   - **Purpose**: Complete step-by-step release guide
   - **Time**: 30 minutes to read, 3-7 days to execute
   - **Contains**:
     - Complete timeline overview
     - All 8 phases (Design → Monitor)
     - Quick commands for each phase
     - Pre-release checklist
     - Quick reference links
   - **Best for**: First-time release or complete overview

### 2. **RELEASE_CHECKLIST.md**
   - **Purpose**: Detailed checklist for all release phases
   - **Time**: 15 minutes to review
   - **Contains**:
     - Pre-release setup (one-time items)
     - Pre-release verification (every release)
     - Build & sign steps
     - Internal testing items
     - Final checks
     - Version management details
     - Pre-upload checklist
   - **Best for**: Ensuring nothing is missed

### 3. **KEYSTORE_SETUP.md**
   - **Purpose**: Creating and managing signing certificates
   - **Time**: 20 minutes to complete
   - **Contains**:
     - How to create keystore (Windows/Linux/macOS)
     - Configuration setup
     - Gradle integration
     - GitHub Actions integration
     - Backup and security
     - Troubleshooting
   - **Best for**: First-time keystore creation, CI/CD setup

### 4. **ICONS_SPLASH_SETUP.md**
   - **Purpose**: App branding (icons and splash screens)
   - **Time**: 30-45 minutes to complete
   - **Contains**:
     - Icon design requirements
     - Splash screen design
     - flutter_launcher_icons setup
     - flutter_native_splash setup
     - Testing on devices
     - Design resources and tools
   - **Best for**: Creating professional branding

### 5. **PERMISSIONS_PRIVACY.md**
   - **Purpose**: Handling permissions and legal requirements
   - **Time**: 30 minutes to setup
   - **Contains**:
     - Current permissions review
     - Common permissions guide (camera, photos, location, notifications)
     - Privacy policy template and hosting
     - Terms of service template
     - Compliance checklist
     - Google Play validation
   - **Best for**: Legal compliance and feature setup

### 6. **PLAY_CONSOLE_GUIDE.md**
   - **Purpose**: Google Play Console setup and internal testing
   - **Time**: 1-2 hours for initial setup, 1-7 days for testing
   - **Contains**:
     - Developer account creation
     - App creation and configuration
     - Store listing setup
     - Signing certificate configuration
     - Internal testing track creation
     - Tester management
     - Feedback monitoring
     - Staged rollout process
     - Production release steps
   - **Best for**: First-time Play Console user

### 7. **RELEASE_RISKS_ROLLBACK.md**
   - **Purpose**: Risk management and rollback procedures
   - **Time**: 15 minutes to review, have ready before release
   - **Contains**:
     - Identified risks (critical, major, minor)
     - Risk severity levels
     - Monitoring plan (1 hour, 1 day, 1 week)
     - Rollback decision tree
     - Rollback procedure (step-by-step)
     - Communication templates
     - Prevention checklist
     - Success criteria
   - **Best for**: Pre-release planning, incident response

---

## 🎯 By Task

### "I need to create app icons"
1. Start: [ICONS_SPLASH_SETUP.md](ICONS_SPLASH_SETUP.md) - Part 1
2. Design icon (1024x1024)
3. Setup flutter_launcher_icons
4. Generate for all platforms
5. Test on device

### "I need to create splash screen"
1. Start: [ICONS_SPLASH_SETUP.md](ICONS_SPLASH_SETUP.md) - Part 3
2. Design splash (1080x1920)
3. Setup flutter_native_splash
4. Generate for platforms
5. Test on device

### "I need to setup app signing"
1. Start: [KEYSTORE_SETUP.md](KEYSTORE_SETUP.md)
2. Create keystore file
3. Create key.properties
4. Update build.gradle.kts
5. Test signing
6. Backup keystore

### "I need to write privacy policy"
1. Start: [PERMISSIONS_PRIVACY.md](PERMISSIONS_PRIVACY.md)
2. Write policy from template
3. Host online (Firebase/GitHub)
4. Add URL to Play Console
5. Verify it's public

### "I need to submit to Play Store"
1. Start: [ANDROID_RELEASE_MASTER.md](ANDROID_RELEASE_MASTER.md) - Phase 5
2. Or detailed: [PLAY_CONSOLE_GUIDE.md](PLAY_CONSOLE_GUIDE.md)
3. Create developer account
4. Create app
5. Configure store listing
6. Upload APK
7. Wait for approval

### "I need to do internal testing"
1. Start: [PLAY_CONSOLE_GUIDE.md](PLAY_CONSOLE_GUIDE.md) - Step 7
2. Upload APK to internal testing
3. Invite testers
4. Monitor feedback
5. Fix issues and resubmit

### "I need to handle a release issue"
1. Start: [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md)
2. Identify issue type
3. Check rollback threshold
4. Follow rollback procedure
5. Communicate to users

---

## 📋 Release Phases Overview

### Phase 1: Design (1-2 hours)
- Create app icon (1024x1024)
- Create splash screen (1080x1920)
- Setup icon generation packages
- Generate for all platforms
- **Files**: [ICONS_SPLASH_SETUP.md](ICONS_SPLASH_SETUP.md)

### Phase 2: Setup (20 minutes)
- Create keystore file
- Create key.properties
- Update build.gradle.kts
- Test signing
- **Files**: [KEYSTORE_SETUP.md](KEYSTORE_SETUP.md)

### Phase 3: Permissions & Privacy (30 minutes)
- Verify permissions
- Write privacy policy
- Host privacy policy
- Add to Play Console
- **Files**: [PERMISSIONS_PRIVACY.md](PERMISSIONS_PRIVACY.md)

### Phase 4: Build (15 minutes)
- Update version
- Build release APK/AAB
- Verify signing
- Test on device
- **Files**: [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)

### Phase 5: Play Console (1-2 hours)
- Create developer account
- Create app
- Configure listing
- Upload APK
- **Files**: [PLAY_CONSOLE_GUIDE.md](PLAY_CONSOLE_GUIDE.md)

### Phase 6: Internal Testing (1-7 days)
- Invite testers
- Collect feedback
- Monitor metrics
- Fix issues and resubmit
- **Files**: [PLAY_CONSOLE_GUIDE.md](PLAY_CONSOLE_GUIDE.md)

### Phase 7: Fix & Iterate (1-3 days)
- Fix bugs found
- Increment version
- Rebuild and resubmit
- Continue until ready
- **Files**: [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)

### Phase 8: Staged Rollout & Monitor (1-3 days)
- Move to production
- Start at 5% rollout
- Monitor metrics
- Gradually increase to 100%
- **Files**: [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md)

---

## ✅ Complete Pre-Release Checklist

### Before Starting Release
- [ ] Understand all phases (read ANDROID_RELEASE_MASTER.md)
- [ ] Have all team members ready
- [ ] Clear calendar for 3-7 days

### Phase 1: Design
- [ ] Icons/splash created
- [ ] flutter_launcher_icons installed
- [ ] flutter_native_splash installed
- [ ] Icons generated for all platforms
- [ ] Tested on device

### Phase 2: Setup
- [ ] Keystore created and backed up
- [ ] key.properties created and in .gitignore
- [ ] build.gradle.kts updated
- [ ] Release build succeeds
- [ ] Signing verified

### Phase 3: Permissions & Privacy
- [ ] Privacy policy written
- [ ] Privacy policy hosted online
- [ ] Permissions in AndroidManifest.xml correct
- [ ] No undeclared permissions

### Phase 4: Build
- [ ] Version updated in pubspec.yaml
- [ ] All tests passing
- [ ] Code analyzed and clean
- [ ] APK built and tested on device
- [ ] Signing certificate valid

### Phase 5: Play Console
- [ ] Developer account created
- [ ] App created in Play Console
- [ ] Store listing complete
- [ ] Screenshots provided
- [ ] Privacy policy linked
- [ ] Content rating completed

### Phase 6: Internal Testing
- [ ] APK uploaded to Play Console
- [ ] Testers invited and receiving emails
- [ ] Feedback monitored
- [ ] Critical bugs fixed
- [ ] No crashes in 3 days

### Phase 7: Final Approval
- [ ] All issues resolved
- [ ] Ready for production release
- [ ] Team agrees
- [ ] Rollback plan reviewed

### Phase 8: Release & Monitor
- [ ] Staged rollout started (5%)
- [ ] Monitoring every hour first day
- [ ] No critical issues
- [ ] Gradually increase to 100%

---

## 🔄 Version Management Reference

```
Current: 1.0.0+1
          ↑    ↑
          │    └─ Build number (internal)
          └────── Version name (user-facing)

Increment options:
• Build number: 1.0.0+1 → 1.0.0+2 (hotfix)
• Patch: 1.0.0+1 → 1.0.1+1 (bug fix)
• Minor: 1.0.0+1 → 1.1.0+1 (new features)
• Major: 1.0.0+1 → 2.0.0+1 (breaking changes)

Auto-increment on release:
./scripts/increment_build_number.sh patch
```

---

## 📊 Monitoring Dashboard

### Key Metrics to Watch

| Metric | Frequency | Target | Action if Failed |
|--------|-----------|--------|------------------|
| Crash rate | Every 1h (day 1) | < 2% | Investigate |
| ANR rate | Every 1h (day 1) | < 0.5% | Investigate |
| Install success | Every 4h | > 95% | Check APK |
| User rating | Daily | ≥ 4.0 | Read reviews |
| Download count | Daily | Growing | Normal variation |

### Where to Check

**In Google Play Console:**
1. **Analytics** → **Crashes & ANRs** (crashes tab)
2. **User feedback** → **Ratings & reviews**
3. **Acquisition** → **Overview** (install count)
4. **Retention** → **Metrics** (user retention)

---

## 🚨 Incident Response

### Critical Issues
- Crash rate > 2%
- Login failures > 30%
- Data loss reported
- Security issue discovered

**Action: ROLLBACK immediately**
See: [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md)

### Major Issues
- ANR rate > 0.5%
- Severe battery drain
- Incompatible on some devices

**Action: Fix or rollback within 4 hours**

### Minor Issues
- UI layout problems
- Typos/grammar
- Missing non-critical feature

**Action: Plan for next release (1.0.1)**

---

## 💡 Pro Tips

1. **Always test locally first**
   ```bash
   flutter build apk --release
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

2. **Use staged rollout**
   - Start 5%, monitor 24h
   - Then 25%, monitor 24h
   - Finally 100%
   - Reduces risk of bad release

3. **Monitor first week closely**
   - Check metrics every hour (day 1)
   - Every 4 hours (day 2-3)
   - Daily (week 1+)

4. **Have rollback plan**
   - Keep version number incremented
   - Be ready to revert within 30 minutes
   - Communicate proactively

5. **Collect feedback early**
   - Internal testing finds 80% of bugs
   - 1 week of testing saves days of fixes
   - Real users find things emulators don't

6. **Read reviews carefully**
   - Pattern in negative reviews = real problem
   - User reports are usually accurate
   - Fix what users complain about

---

## 📞 Quick Links

| Need | Document | Time |
|------|----------|------|
| Complete guide | [ANDROID_RELEASE_MASTER.md](ANDROID_RELEASE_MASTER.md) | 30 min read |
| Checklist | [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) | 15 min review |
| Icons & Splash | [ICONS_SPLASH_SETUP.md](ICONS_SPLASH_SETUP.md) | 45 min setup |
| Keystore signing | [KEYSTORE_SETUP.md](KEYSTORE_SETUP.md) | 20 min setup |
| Permissions | [PERMISSIONS_PRIVACY.md](PERMISSIONS_PRIVACY.md) | 30 min setup |
| Play Console | [PLAY_CONSOLE_GUIDE.md](PLAY_CONSOLE_GUIDE.md) | 2 hours setup |
| Risks & Rollback | [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md) | 15 min review |

---

## 🎯 Next Steps

### For First Time:
1. ✅ Read [ANDROID_RELEASE_MASTER.md](ANDROID_RELEASE_MASTER.md) (30 minutes)
2. ✅ Start Phase 1 - Design (1-2 hours)
3. ✅ Follow each phase in order
4. ✅ Reference documents as needed

### For Production Release:
1. ✅ Use [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)
2. ✅ Follow [ANDROID_RELEASE_MASTER.md](ANDROID_RELEASE_MASTER.md) phases 4-8
3. ✅ Have [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md) ready
4. ✅ Monitor metrics closely

### For Troubleshooting:
1. ✅ Check specific document (e.g., [KEYSTORE_SETUP.md](KEYSTORE_SETUP.md))
2. ✅ See Troubleshooting section in that document
3. ✅ If blocked, check [RELEASE_RISKS_ROLLBACK.md](RELEASE_RISKS_ROLLBACK.md) for rollback

---

## 📈 Timeline Estimate

```
Phase 1: Design           │ 1-2 hours  │ █████░░░░░░░░░░░░░░
Phase 2: Setup            │ 20 min     │ ██░░░░░░░░░░░░░░░░░
Phase 3: Permissions      │ 30 min     │ ███░░░░░░░░░░░░░░░░
Phase 4: Build            │ 15 min     │ ██░░░░░░░░░░░░░░░░░
Phase 5: Play Console     │ 1-2 hours  │ █████░░░░░░░░░░░░░░
Phase 6: Internal Testing │ 1-7 days   │ ████████████████░░░░
Phase 7: Fix & Iterate    │ 1-3 days   │ ████████░░░░░░░░░░░░
Phase 8: Staged Rollout   │ 1-3 days   │ ████████░░░░░░░░░░░░
─────────────────────────────────────────────────────────────
Total                     │ 3-7 days   │ Release Ready! ✅
```

---

**Android Release Preparation: Complete Index**  
Status: Complete and Ready  
Version: 1.0  
Last Updated: 2024  
Estimated Time to Release: 3-7 days
