# CI/CD Pipeline Documentation

## Overview

Complete automated build and deployment pipeline using GitHub Actions.

## Workflows

### 1. Test & Analyze Workflow (`tests.yml`)

**Trigger**: Push to main/develop, Pull requests  
**Runs**: Tests, code analysis, coverage reporting

See [TESTING.md](TESTING.md) for details.

---

## 2. Build & Deploy Workflow (`build.yml`)

**Trigger**: 
- Automatic: Push to `develop` branch (builds dev debug only)
- Manual: Workflow dispatch (flexible build options)

**Jobs**:

### Job: Test & Analyze
- Runs on all pushes/PRs (if not workflow_dispatch)
- Code analysis
- Unit + integration tests
- Coverage upload

### Job: Build Dev Debug
- **Trigger**: Push to `develop` OR manual dispatch
- **Output**: `app-dev-debug.apk`
- **Retention**: 7 days

### Job: Build Dev Release
- **Trigger**: Manual dispatch with flavor=dev or all
- **Auto-increments** build number
- **Output**: `app-dev-release.apk`
- **Retention**: 30 days
- **Commits**: Updated version to repository

### Job: Build Prod Debug
- **Trigger**: Manual dispatch with flavor=prod or all
- **Output**: `app-prod-debug.apk`
- **Retention**: 7 days

### Job: Build Prod Release
- **Trigger**: Manual dispatch with flavor=prod or all
- **Auto-increments** build number
- **Output**: `app-prod-release.apk`
- **Retention**: 30 days
- **Commits**: Updated version to repository

### Job: Create Release
- **Trigger**: Manual dispatch with flavor=all
- **Requires**: Dev Release + Prod Release
- **Action**: Creates GitHub Release with both APKs
- **Tag**: v{version}

### Job: Build Summary
- **Trigger**: After all build jobs
- **Action**: Prints summary of all builds

---

## 🚀 Manual Trigger Guide

### Access Workflow

1. Go to GitHub repository
2. Click **"Actions"** tab
3. Select **"Flutter Build & Deploy"**
4. Click **"Run workflow"** button

### Options

**Build Flavor**:
- `dev` - Development environment only
- `prod` - Production environment only
- `all` - Both dev and prod

**Build Type**:
- `debug` - Fast builds (7 days retention)
- `release` - Optimized builds, auto version increment (30 days retention)
- `all` - Both debug and release (runs 4 builds)

### Examples

#### Example 1: Build Dev Debug
```
Flavor: dev
Type: debug
Result: app-dev-debug.apk (fast, debuggable)
```

#### Example 2: Release All
```
Flavor: all
Type: release
Result: 
  - app-dev-release.apk (optimized)
  - app-prod-release.apk (optimized)
  - Both available in GitHub Release
  - Version auto-incremented
```

#### Example 3: Prod Debug
```
Flavor: prod
Type: debug
Result: app-prod-debug.apk (for testing)
```

---

## 📦 Artifact Download

### From GitHub Actions

1. Open completed workflow run
2. Scroll to **"Artifacts"** section
3. Download desired APK:
   - `flutter-app-dev-debug` (if built)
   - `flutter-app-dev-release` (if built)
   - `flutter-app-prod-debug` (if built)
   - `flutter-app-prod-release` (if built)

### Retention Policy

- **Debug**: 7 days
- **Release**: 30 days

---

## 🔄 Version Management

### Automatic Increment

On **release builds**, the build number auto-increments:

```
Before: version: 1.0.0+5
After:  version: 1.0.0+6
```

The script:
1. Reads current version from `pubspec.yaml`
2. Increments build number
3. Updates `pubspec.yaml`
4. Commits and pushes to repository

### Manual Increment (Before Release)

If you need to increment before building:

```bash
# Linux/macOS
./scripts/increment_build_number.sh [build|patch|minor|major]

# Windows
scripts/increment_build_number.bat [build|patch|minor|major]
```

---

## 🔐 Security

### Secrets Configuration

The workflow doesn't require GitHub Secrets by default, but for production signing:

1. Create signing keystore
2. Add to GitHub Secrets:
   - `KEYSTORE_FILE` - Base64 encoded keystore
   - `KEYSTORE_PASSWORD` - Keystore password
   - `KEY_ALIAS` - Key alias
   - `KEY_PASSWORD` - Key password

3. Update workflow to use secrets

### Best Practices

- ✅ Never commit keystore to repo
- ✅ Use GitHub Secrets for sensitive data
- ✅ Limit branch access
- ✅ Review workflow changes
- ✅ Use branch protection rules

---

## 📊 Pipeline Status

### Status Badge

Add to README.md:

```markdown
![Build](https://github.com/YOUR_ORG/YOUR_REPO/workflows/Flutter%20Build%20&%20Deploy/badge.svg)
```

### View Status

- GitHub UI: Actions tab → Workflow runs
- CLI: `gh run list --workflow build.yml`

---

## 🧪 Testing Pipeline

### Test Coverage

Every build includes:
- ✅ Code analysis (`flutter analyze`)
- ✅ Format check (`dart format`)
- ✅ Unit tests (8 tests)
- ✅ Integration tests (2 tests)
- ✅ Coverage report (uploaded to Codecov)

### Test Requirements

All tests must pass before APK builds:
- If test fails → Build skipped
- Coverage report available

---

## 📋 Build Checklist

Before creating a release:

- [ ] All tests passing locally
- [ ] Code reviewed
- [ ] Version number updated (if manual)
- [ ] Changelog updated
- [ ] Branch is clean (no uncommitted changes)

After build completes:

- [ ] Download both APKs
- [ ] Test on Android devices
- [ ] Verify version in APK
- [ ] Check file sizes are reasonable
- [ ] Deploy to app store (if applicable)

---

## 🚨 Troubleshooting

### Build Fails

**Problem**: Workflow shows failure  
**Solution**:
1. Click on failed job
2. View logs
3. Common issues:
   - Dependencies not found: `flutter pub get`
   - Tests failing: Run locally first
   - Build files corrupted: `flutter clean`

### APK Not Generated

**Problem**: Build succeeds but no APK  
**Solution**:
1. Check build output in logs
2. Verify flavor and target file correct
3. Try building locally first

### Version Not Incremented

**Problem**: Build number didn't increment  
**Solution**:
1. Check if release build was run
2. View Git history for commits
3. Manually increment if needed

### GitHub Actions Not Triggering

**Problem**: No workflow runs  
**Solution**:
1. Verify branch is `main` or `develop`
2. Check `.github/workflows/build.yml` exists
3. Enable Actions in repo settings
4. Try manual workflow dispatch

---

## 📈 Performance Optimization

### Build Time Reduction

1. **Cache dependencies**:
   ```yaml
   - uses: actions/cache@v3
     with:
       path: ~/.flutter
       key: ${{ runner.os }}-flutter
   ```

2. **Parallel jobs**:
   - Dev and Prod build in parallel
   - Reduces total pipeline time

3. **Skip tests for certain builds**:
   - Tests run only on main workflow
   - APK builds skip tests

### Artifact Size

| Build | Size | Typical |
|-------|------|---------|
| Debug | Large | 50-80MB |
| Release | Small | 20-40MB |

---

## 🔗 Integration Points

### GitHub Actions Contexts

Available in workflows:
- `github.event_name` - Trigger type
- `github.ref` - Branch/tag
- `github.sha` - Commit hash
- `github.actor` - User who triggered

### External Integrations

**Possible extensions**:
- Firebase App Distribution
- Slack notifications
- TestFlight upload
- Play Store upload
- Sentry error tracking
- Datadog monitoring

---

## 📚 References

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Flutter Build Documentation](https://flutter.dev/docs/deployment)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [workflow file syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)

---

## ✅ Verification

### Before Deployment

```bash
# Build locally first
./scripts/build.sh dev debug
./scripts/build.sh dev release
./scripts/build.sh prod debug
./scripts/build.sh prod release

# Test on device
adb install -r build/app/outputs/flutter-apk/app-dev-debug.apk

# Verify app runs
# Login and test features
```

---

**Status**: ✅ Production Ready  
**Last Updated**: 2024  
**Version**: 1.0.0+1
