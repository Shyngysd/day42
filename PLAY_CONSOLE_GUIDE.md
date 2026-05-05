# 🎮 Google Play Console: Internal Testing Setup

## Overview

Google Play Console allows you to test your app before public release:
- **Internal testing**: For your team (instant)
- **Closed testing**: For small group of testers
- **Open testing**: For open beta (public)
- **Production**: Public release

---

## 📋 Prerequisites

- [ ] Google Play Developer account ($25 one-time fee)
- [ ] Signed release APK or AAB
- [ ] App store listing (description, screenshots, etc.)
- [ ] Privacy policy URL
- [ ] Support email address
- [ ] Testers' Gmail addresses

---

## 🚀 Step 1: Create Google Play Developer Account

### Setup Account

1. Go to [Google Play Console](https://play.google.com/console)
2. Sign in with Google account (or create one)
3. Pay $25 developer fee (one-time)
4. Accept terms and conditions
5. Complete developer profile with:
   - Name
   - Contact email
   - Address
   - Phone number

---

## 📱 Step 2: Create App in Play Console

### Register App

1. **Dashboard** → **Create app**
2. Fill in:
   - **App name**: "flutter_application_1" or your name
   - **Default language**: English
   - **App or game**: Select "App"
   - **Category**: Choose appropriate (Education, Lifestyle, etc.)
   - **Free or paid**: Select "Free"

3. **Accept declarations**:
   - [ ] I confirm this app doesn't violate Google Play policies
   - [ ] I confirm this app is not a re-skinned/spam app

4. **Create app**

---

## 📝 Step 3: Complete App Information

### Basic Info

1. Go to **Setup** → **App information**
   - **App name**: Your app name
   - **Short description**: (80 chars max)
   - **Full description**: (4000 chars max)
   - **Category**: Select category
   - **Type**: Application

### Contact Information

1. Go to **Setup** → **Store listing**
   - **Developer email**: your.email@example.com
   - **Developer website**: (optional) your-website.com
   - **Developer phone**: +1-XXX-XXX-XXXX
   - **Support email**: support@example.com
   - **Support website**: (optional)

### Content Rating

1. Go to **App content** → **Content rating questionnaire**
   - Answer questions about your app content
   - Select appropriate rating (Everyone, 12+, 16+, 18+)
   - Submit rating

### Privacy Policy

1. Go to **App content** → **Privacy policy**
   - Enter URL to your privacy policy (required)
   - Example: `https://example.com/privacy`

### Screenshots

1. Go to **Store listing** → **Graphics**
   - **Screenshots**: 5 minimum, 8 maximum
     - Minimum: 320x1280 pixels (portrait)
     - OR 1280x720 pixels (landscape)
   - **Feature graphic**: 1280x720 pixels
   - **App icon**: 512x512 pixels
   - **App preview video**: (optional) YouTube link

---

## 🔐 Step 4: Setup Signing Certificate

### Google Play App Signing

Google Play handles signing for you:

1. Go to **Setup** → **App signing**
2. **App signing by Google Play** (automatic):
   - Google generates signing certificate
   - You don't need to manage it
   - Recommended for first releases

3. **Manual signing** (advanced):
   - Use your own keystore
   - Upload signed APK

**Recommended**: Use Google Play App Signing (automatic)

---

## 🧪 Step 5: Setup Internal Testing Track

### Create Internal Testing Group

1. Go to **Testing** → **Internal testing**
2. Click **Create internal testing**
3. **Invite testers**:
   - Add email addresses of your testers
   - They receive email invitation
   - Can install from Play Store (beta)

### Add Testers

1. Click **Invite users**
2. Enter email addresses (one per line):
   ```
   tester1@example.com
   tester2@example.com
   tester3@example.com
   ```
3. Send invitation

### Testers Accept Invitation

Testers receive email:
- "Join the beta test for [App Name]"
- Click link
- Accept terms
- Install from Play Store (as beta version)

---

## 📦 Step 6: Upload Release Build

### Build Release APK/AAB

```bash
# Build release app bundle (recommended)
flutter build appbundle --release

# Or single APK
flutter build apk --release

# Outputs:
# - build/app/outputs/bundle/release/app-release.aab
# - build/app/outputs/flutter-apk/app-release.apk
```

### Upload to Internal Testing

1. Go to **Testing** → **Internal testing**
2. Click **Create release**
3. **Select app signing**:
   - Choose "Google Play App Signing"
4. **Upload APK or AAB**:
   - Click "Browse files"
   - Select `app-release.aab` (or `.apk`)
   - Wait for upload (1-2 minutes)

5. **Review release**:
   - Release notes (optional): "First beta release"
   - Confirm app details are correct

6. **Send to review**:
   - Click "Send to review"
   - Status: "In review" (usually passes in ~2 hours)

### Monitor Review Status

- **In review**: Play Store reviewing app
- **Approved**: Ready for testers
- **Rejected**: Check issues and resubmit

Common rejections:
- Crash on startup
- Permissions not justified
- Privacy policy missing
- Unclear app functionality

---

## 👥 Step 7: Testers Install Beta App

### Installation Process

1. **Tester accepts invitation**:
   - Receives email with testing link
   - Clicks link to accept
   - Adds email to test group

2. **Install from Play Store**:
   - Go to Play Store app
   - Search for your app name
   - Should see "You're a beta tester" badge
   - Click "Install" or "Update"
   - Version shows as beta (e.g., "1.0.0 (beta)")

3. **Feedback**:
   - Testers can rate/review
   - Comments visible to developers
   - Testing link includes reporting form

### For Local Testing Without Play Store

If testers can't use Play Store:

```bash
# Download APK from console
# Share via email or cloud storage

# Testers install via ADB:
adb install app-release.apk

# Or share APK file directly
# (they click to install if Android allows unknown sources)
```

---

## 📊 Step 8: Monitor Internal Testing

### Track Beta Feedback

1. Go to **User feedback** → **Ratings & reviews**
   - See beta tester reviews
   - Filter by testing track

2. Go to **Analytics**:
   - Crashes and ANRs
   - Performance metrics
   - Device information
   - Android version breakdown

### Typical Issues Found

- **Crashes**: Check crash reports (stack traces)
- **ANRs**: App freezes, check for blocking operations
- **Permissions**: Denied permissions causing failures
- **Network**: Slow/no network issues
- **UI**: Layout problems on certain devices

---

## 🔄 Step 9: Iterate & Resubmit

### Fix Issues Found

1. **Review crash reports** in Play Console
2. **Fix bugs** in your code
3. **Increment version**: `./scripts/increment_build_number.sh patch`
4. **Build new APK**: `flutter build appbundle --release`
5. **Upload to Play Console**: Same internal testing track
6. **Testers get update**: Auto-installed or manual update

### Release Checklist Before Each Build

- [ ] All crashes fixed
- [ ] Tested on multiple devices
- [ ] No console errors
- [ ] ANRs resolved (< 0.1%)
- [ ] Battery usage reasonable
- [ ] Network calls work
- [ ] Permissions all granted
- [ ] UI responsive (no freezes)

---

## ✅ Step 10: Prepare for Production Release

### Final Checks

- [ ] 7+ days internal testing completed
- [ ] No crash reports in last 3 days
- [ ] All feedback addressed
- [ ] Store listing complete (screenshots, description)
- [ ] Privacy policy approved
- [ ] Content rating assigned
- [ ] Support email works

### Create Production Release

1. Go to **Release** → **Production**
2. Click **Create release**
3. **Select version**:
   - Use version from internal testing
   - Or create new version
4. **Review**:
   - Release notes
   - Screenshots
   - Description

5. **Staged rollout** (recommended):
   - 5% of users first
   - Monitor for crashes
   - Increase to 25% → 50% → 100%

---

## 📈 Monitoring After Release

### Watch Key Metrics

1. **Crash rate**:
   - Should be < 0.1%
   - Monitor for spikes

2. **ANR rate**:
   - Should be < 0.05%
   - Check long operations

3. **Rating**:
   - Target: > 4.0 stars
   - Read reviews for patterns

4. **User retention**:
   - 1-day retention: > 40%
   - 7-day retention: > 20%

### Rollback Plan

If critical issue found:

```
1. Pause rollout (don't proceed to 100%)
2. Fix the bug
3. Increment version
4. Build new APK
5. Create new production release
6. Staged rollout again (5% → 25% → 50% → 100%)
```

---

## 🛠️ Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| "Upload failed" | File too large | Use AAB instead of APK |
| "App rejected" | Policy violation | Check rejection reason, fix, resubmit |
| "Can't install" | Version conflict | Uninstall old app first |
| "App crashes" | Unhandled exception | Check crash report stack trace |
| "Testers not receiving update" | Version number issue | Check version code increased |

---

## 📋 Quick Checklist: Internal Testing

### Before Upload
- [ ] Release APK/AAB built
- [ ] APK tested on device
- [ ] Version code increased
- [ ] Store listing filled
- [ ] Privacy policy URL ready
- [ ] Support email configured

### After Upload
- [ ] Status shows "In review"
- [ ] Wait for approval (2 hours typical)
- [ ] Invite testers
- [ ] Testers receive emails
- [ ] Testers install from Play Store

### During Testing
- [ ] Monitor crash rate
- [ ] Read tester feedback
- [ ] Fix reported bugs
- [ ] Update app and resubmit

### After Testing
- [ ] All critical bugs fixed
- [ ] No crashes in 3 days
- [ ] Ready for production
- [ ] Create production release
- [ ] Setup staged rollout

---

## 💡 Pro Tips

1. **Start with internal testing**:
   - Fastest way to catch bugs
   - Only you and small team

2. **Use crash reports**:
   - Play Console shows exact crash location
   - Stack traces very helpful

3. **Test on real devices**:
   - Emulator doesn't catch all bugs
   - Test on actual user devices

4. **Staged rollout**:
   - Reduces risk of bad release
   - Can rollback quickly if needed

5. **Read reviews carefully**:
   - Users report real issues
   - Pattern in negative reviews = real problem

6. **Monitor daily**:
   - First week critical
   - Check crash rate every day
   - Be ready to rollback

---

**Google Play Console Guide**  
Status: Complete  
Next Step: Create app in Play Console  
Estimated Time: 1-2 hours for complete setup
