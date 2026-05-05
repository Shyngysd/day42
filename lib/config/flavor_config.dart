class FlavorConfig {
  static const String dev = 'dev';
  static const String prod = 'prod';

  final String flavor;
  final String name;
  final String apiBaseUrl;
  final bool enableDebugLogging;

  FlavorConfig({
    required this.flavor,
    required this.name,
    required this.apiBaseUrl,
    required this.enableDebugLogging,
  });

  static FlavorConfig? _instance;

  static FlavorConfig get instance {
    assert(_instance != null, 'FlavorConfig must be initialized');
    return _instance!;
  }

  static Future<void> initialize(String flavor) async {
    switch (flavor) {
      case FlavorConfig.dev:
        _instance = FlavorConfig(
          flavor: FlavorConfig.dev,
          name: 'Dev App',
          apiBaseUrl: 'http://localhost:3000',
          enableDebugLogging: true,
        );
        break;
      case FlavorConfig.prod:
        _instance = FlavorConfig(
          flavor: FlavorConfig.prod,
          name: 'Test App',
          apiBaseUrl: 'https://api.production.com',
          enableDebugLogging: false,
        );
        break;
      default:
        throw 'Unknown flavor: $flavor';
    }
  }

  bool get isDev => flavor == FlavorConfig.dev;
  bool get isProd => flavor == FlavorConfig.prod;
}
