# 📋 Permissions & Privacy Policy Setup

## Permissions Overview

Your app currently doesn't require special permissions beyond internet access. However, this guide covers setup if you need to add them later.

---

## 📱 Current App Permissions

### Already Declared in `AndroidManifest.xml`

```xml
<!-- Internet access - required for API calls -->
<uses-permission android:name="android.permission.INTERNET" />

<!-- Query activities for text processing -->
<queries>
    <intent>
        <action android:name="android.intent.action.PROCESS_TEXT"/>
        <data android:mimeType="text/plain"/>
    </intent>
</queries>
```

### Verify in AndroidManifest.xml

Check: `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ... >
        <!-- Your activities -->
    </application>
    
    <!-- These are your current permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>
```

---

## 🎥 Common Permissions Guide

### If Adding Camera Feature

**Step 1: Declare in AndroidManifest.xml**

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

**Step 2: Add permission handling package**

```bash
flutter pub add permission_handler
```

**Step 3: Request at runtime**

```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  
  if (status.isDenied) {
    print('Camera permission denied');
    return false;
  } else if (status.isGranted) {
    print('Camera permission granted');
    return true;
  } else if (status.isDenied) {
    print('Camera permission permanently denied');
    openAppSettings();
    return false;
  }
}
```

**Step 4: Check before using camera**

```dart
if (await requestCameraPermission()) {
  // Open camera
} else {
  // Show "Permission required" message
}
```

---

### If Accessing Photos/Files

**Step 1: Declare in AndroidManifest.xml**

```xml
<!-- For Android 10+ (API 29+) use scoped storage -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

<!-- Only if app needs write access -->
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

**Step 2: Add package**

```bash
flutter pub add image_picker
```

**Step 3: Use in code**

```dart
import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<void> pickImage() async {
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    // Use image file
    print('Selected: ${image.path}');
  }
}
```

---

### If Using Notifications

**Step 1: Declare in AndroidManifest.xml**

```xml
<!-- Android 13+ requires POST_NOTIFICATIONS permission -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

**Step 2: Add notification package**

```bash
flutter pub add firebase_messaging
```

**Step 3: Request permission at runtime**

```dart
import 'package:firebase_messaging/firebase_messaging.dart';

Future<bool> requestNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Notification permission granted');
    return true;
  }
  return false;
}
```

---

### If Using Location

**Step 1: Declare in AndroidManifest.xml**

```xml
<!-- Fine location (GPS) -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<!-- Approximate location (network-based) -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**Step 2: Add package**

```bash
flutter pub add geolocator
```

**Step 3: Request and use**

```dart
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services disabled');
    return Future.error('Location services disabled');
  }
  
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
  
  if (permission == LocationPermission.denied) {
    return Future.error('Location permission denied');
  }
  
  return await Geolocator.getCurrentPosition();
}
```

---

## 🔐 Privacy Policy

### Why You Need One

- **Required by Google Play**: Every app must have a privacy policy
- **Legal requirement**: Many countries require it (GDPR, CCPA, etc.)
- **Build trust**: Users need to understand what data you collect

### What to Include

Create file: `privacy_policy.md` or `privacy_policy.html`

```markdown
# Privacy Policy for [Your App Name]

**Last Updated: [Date]**

## 1. Introduction

[Your App Name] ("App") respects your privacy. This Privacy Policy explains how we collect, use, and protect your personal data.

## 2. What Data We Collect

### User-Provided Data
- Email address (for login)
- Username (for display)
- Profile information (if provided)
- Items/content you create

### Automatically Collected Data
- Device information (model, OS version)
- App usage statistics
- Crash reports and error logs
- IP address (for API calls)

### Data We Do NOT Collect
- Location data (unless explicitly requested)
- Contacts or calendar
- Photos (unless you upload)
- Sensitive personal information

## 3. How We Use Your Data

We use your data to:
- Provide and improve the app
- Authenticate your account
- Store your items/content
- Fix bugs and crashes
- Analyze app usage (anonymous)
- Send notifications (if opted in)

## 4. Third-Party Services

Our app uses:
- **Google Analytics**: Tracks anonymous usage (no personal data)
- **Firebase**: Crash reporting and analytics
- **Our API Server**: Stores user accounts and items

## 5. Data Security

- All data transmitted via HTTPS (encrypted)
- Passwords hashed before storage
- Sensitive data never logged
- Regular security reviews
- No data shared with advertisers

## 6. Data Retention

- User account: Until deleted by user
- Items/content: Until deleted by user
- Crash logs: 30 days (anonymous)
- Analytics: 35 days (anonymous)

## 7. Your Rights

You can:
- Access your personal data
- Request data deletion
- Opt out of analytics
- Update your information
- Download your data

## 8. Contact Us

Email: privacy@example.com

For data requests, contact us within 30 days and we'll respond within 7 days.

## 9. Changes to This Policy

We may update this policy. We'll notify you via:
- Email notification
- In-app notification
- App update notes

Continued use means you accept changes.

## 10. Compliance

This app complies with:
- Google Play Developer Policy
- GDPR (if EU users)
- CCPA (if California users)
- COPPA (if under 13 restriction)
```

### Where to Host Privacy Policy

**Option 1: Firebase Hosting** (free)
```bash
firebase init hosting
# Deploy to: https://your-project.web.app/privacy
```

**Option 2: GitHub Pages** (free)
```bash
# Create repo: your-app-privacy
# Enable GitHub Pages
# https://your-username.github.io/your-app-privacy/
```

**Option 3: Your website**
```
https://yourcompany.com/privacy-policy
```

**Option 4: Simple text file in app** (temporary)
```
Add to app startup:
Show privacy policy in WebView
```

### Link in Google Play Console

1. Go to **Store listing**
2. Find **Privacy policy** section
3. Paste URL: `https://example.com/privacy-policy`
4. Save

---

## 📄 Terms of Service (Optional but Recommended)

Similar to privacy policy, create terms of service:

```markdown
# Terms of Service for [Your App Name]

## 1. Use License

You are granted a non-exclusive license to:
- Download and use this app
- For personal use only
- On compatible Android devices

## 2. Restrictions

You may not:
- Reverse engineer or decompile
- Sell, transfer, or sublicense
- Use to harass or harm others
- Violate any laws

## 3. Limitation of Liability

The app is provided "as is". We are not liable for:
- Data loss
- Service interruptions
- Indirect damages

## 4. Disclaimer

We do not guarantee:
- Service availability
- Error-free operation
- Fitness for specific purpose

## 5. Modifications

We reserve the right to modify the service and terms.

## 6. Governing Law

These terms are governed by [Your Country] law.
```

---

## ✅ Google Play Console Compliance

### Before Submission Checklist

- [ ] Privacy policy URL set
- [ ] Privacy policy is complete and clear
- [ ] Privacy policy matches what app actually does
- [ ] No collecting data not mentioned in policy
- [ ] Permissions in app match permissions declared
- [ ] Content rating completed
- [ ] App doesn't violate Play Store policies

### Common Violations to Avoid

| Violation | Example | Fix |
|-----------|---------|-----|
| Undisclosed data collection | Collecting location without mentioning it | Update privacy policy |
| Mismatched permissions | Requesting camera but not using it | Remove unused permissions |
| Misleading functionality | Fake cleaner app | Describe actual features |
| Prohibited content | Adult content | Don't include |
| Policy violations | Phishing | Follow policies |

---

## 🔄 Sample Privacy Policy URL Pattern

```
https://example.com/privacy-policy
https://yourapp.com/legal/privacy
https://firebase-project-name.web.app/privacy.html
https://github.com/yourname/privacy-policy/blob/main/privacy.md
```

---

## 📝 For Your Current App

### What Needs to Happen

1. ✅ Create privacy policy (simple, 500-800 words)
2. ✅ Host it somewhere (Firebase, GitHub, or website)
3. ✅ Add URL to Google Play Console
4. ✅ No additional code changes needed (no special permissions)
5. ✅ For future features, update privacy policy before coding

### Current Data Collection Summary

```
User-Provided:
- Email (for login)
- Passwords (sent to API, not stored in app)
- Items/content created

Automatically:
- Device info (for analytics)
- Crash reports (if Firebase enabled)
- API calls (logged for debugging)

Data NOT Collected:
- Location
- Contacts
- Calendar
- Photos
- Personal info beyond account
```

### Sample Privacy Policy URL

```
Privacy Policy: https://your-domain.com/privacy-policy
Terms of Service: https://your-domain.com/terms
```

---

## 🚀 Next Steps

### For Release

1. Write privacy policy (30 minutes)
2. Host it online (15 minutes)
3. Add URL to Play Console (5 minutes)
4. Get approved (automatic with policy)
5. Submit to internal testing

### Template Customization

Copy the privacy policy template above and fill in:
- [ ] [Your App Name]
- [ ] [Your Company]
- [ ] privacy@yourcompany.com
- [ ] [Your Country]
- [ ] [List what your app actually does]
- [ ] [Third-party services you use]

---

## ✅ Compliance Checklist

- [ ] Privacy policy written
- [ ] Privacy policy hosted online
- [ ] Privacy policy URL added to Google Play
- [ ] Content rating completed
- [ ] Permissions match actual usage
- [ ] No undisclosed data collection
- [ ] HTTPS for all network requests
- [ ] Terms of Service (optional but good)
- [ ] Support email configured
- [ ] Contact email for privacy requests

---

**Permissions & Privacy Policy Guide**  
Status: Ready to implement  
Estimated Time: 1-2 hours  
Complexity: Medium
