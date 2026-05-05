/// Version management utility
class VersionManager {
  static const String versionFile = 'pubspec.yaml';

  /// Parse version from string "1.0.0+5"
  /// Returns (major, minor, patch, buildNumber)
  static (int, int, int, int) parseVersion(String version) {
    final parts = version.split('+');
    final versionParts = parts[0].split('.');
    
    return (
      int.parse(versionParts[0]), // major
      int.parse(versionParts[1]), // minor
      int.parse(versionParts[2]), // patch
      parts.length > 1 ? int.parse(parts[1]) : 1, // buildNumber
    );
  }

  /// Get next version with incremented build number
  static String incrementBuildNumber(String currentVersion) {
    final (major, minor, patch, build) = parseVersion(currentVersion);
    return '$major.$minor.$patch+${build + 1}';
  }

  /// Get next version with patch increment
  static String incrementPatch(String currentVersion) {
    final (major, minor, patch, _) = parseVersion(currentVersion);
    return '$major.$minor.${patch + 1}+1';
  }

  /// Get next version with minor increment
  static String incrementMinor(String currentVersion) {
    final (major, minor, _, _) = parseVersion(currentVersion);
    return '$major.${minor + 1}.0+1';
  }

  /// Get next version with major increment
  static String incrementMajor(String currentVersion) {
    final (major, _, _, _) = parseVersion(currentVersion);
    return '${major + 1}.0.0+1';
  }
}
