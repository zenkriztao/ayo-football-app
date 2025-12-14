/// Enum untuk environment flavors
enum AppFlavor {
  dev,
  staging,
  prod,
}

/// Konfigurasi aplikasi berdasarkan flavor
/// Menggunakan Singleton pattern untuk memastikan satu instance
class AppConfig {
  static AppConfig? _instance;

  final AppFlavor flavor;
  final String appName;
  final String baseUrl;
  final bool enableLogging;
  final bool enableCrashlytics;

  AppConfig._({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
    required this.enableCrashlytics,
  });

  ///  Development
  factory AppConfig.dev() {
    _instance = AppConfig._(
      flavor: AppFlavor.dev,
      appName: 'AYO Football (Dev)',
      // baseUrl: 'http://localhost:8080/api/v1',
      baseUrl: 'https://ayo-football-api-production.up.railway.app/api/v1',
      enableLogging: true,
      enableCrashlytics: false,
    );
    return _instance!;
  }

  /// Staging
  factory AppConfig.staging() {
    _instance = AppConfig._(
      flavor: AppFlavor.staging,
      appName: 'AYO Football (Staging)',
      // baseUrl: 'https://staging-api.ayofootball.com/api/v1',
      baseUrl: 'https://ayo-football-api-production.up.railway.app/api/v1',
      enableLogging: true,
      enableCrashlytics: true,
    );
    return _instance!;
  }

  /// Production
  factory AppConfig.prod() {
    _instance = AppConfig._(
      flavor: AppFlavor.prod,
      appName: 'AYO Football',
      // baseUrl: 'https://api.ayofootball.com/api/v1',
      baseUrl: 'https://ayo-football-api-production.up.railway.app/api/v1',
      enableLogging: false,
      enableCrashlytics: true,
    );
    return _instance!;
  }

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig belum diinisialisasi. Panggil AppConfig.dev(), AppConfig.staging(), atau AppConfig.prod() terlebih dahulu.');
    }
    return _instance!;
  }

  bool get isDev => flavor == AppFlavor.dev;

  bool get isStaging => flavor == AppFlavor.staging;

  bool get isProd => flavor == AppFlavor.prod;

  String get androidEmulatorBaseUrl {
    if (baseUrl.contains('localhost')) {
      return baseUrl.replaceAll('localhost', '10.0.2.2');
    }
    return baseUrl;
  }
}
